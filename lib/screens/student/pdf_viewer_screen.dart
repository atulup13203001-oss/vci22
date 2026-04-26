import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late WebViewController _webViewController;
  late String _pdfUrl;
  late String _title;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    _pdfUrl = arguments['url'] ?? '';
    _title = arguments['title'] ?? 'PDF Document';

    // Convert Google Drive URL to preview URL if needed
    String viewUrl = _pdfUrl;
    if (_pdfUrl.contains('drive.google.com')) {
      // Extract file ID from Google Drive URL
      final fileId = _extractGoogleDriveFileId(_pdfUrl);
      if (fileId.isNotEmpty) {
        viewUrl = 'https://drive.google.com/file/d/$fileId/preview';
      }
    }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(viewUrl));
  }

  String _extractGoogleDriveFileId(String url) {
    try {
      if (url.contains('/d/')) {
        final parts = url.split('/d/');
        if (parts.length > 1) {
          final fileId = parts[1].split('/')[0];
          return fileId;
        }
      } else if (url.contains('id=')) {
        final parts = url.split('id=');
        if (parts.length > 1) {
          final fileId = parts[1].split('&')[0];
          return fileId;
        }
      }
    } catch (e) {
      print('Error extracting file ID: $e');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF9500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading PDF...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

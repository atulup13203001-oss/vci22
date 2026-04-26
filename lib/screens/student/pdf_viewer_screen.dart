import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);
  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late String pdfUrl;
  late String title;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    pdfUrl = args['url'] as String;
    title = args['title'] as String;
    pdfUrl = _getDirectPdfUrl(pdfUrl);
  }

  String _getDirectPdfUrl(String url) {
    if (url.contains('drive.google.com')) {
      final fileIdRegExp = RegExp(r'(?:/d/|id=)([^/&]+)');
      final match = fileIdRegExp.firstMatch(url);
      if (match != null) {
        final fileId = match.group(1);
        if (fileId != null) {
          return 'https://drive.google.com/uc?export=download&id=$fileId';
        }
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: PdfViewer.file(pdfUrl, pdfViewerParams: const PdfViewerParams(enableTextSelection: true)),
    );
  }
}

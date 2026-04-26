import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/routes/app_routes.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EbookDetailScreen extends StatefulWidget {
  const EbookDetailScreen({Key? key}) : super(key: key);

  @override
  State<EbookDetailScreen> createState() => _EbookDetailScreenState();
}

class _EbookDetailScreenState extends State<EbookDetailScreen> {
  late Ebook ebook;
  bool _isPurchased = false;

  @override
  void initState() {
    super.initState();
    ebook = Get.arguments as Ebook;
    _checkPurchase();
  }

  Future<void> _checkPurchase() async {
    final user = FirebaseService.getCurrentUser();
    if (user != null) {
      final purchases = await FirebaseService.getStudentEbookPurchases(user.id);
      setState(() {
        _isPurchased = purchases.any((p) => p.ebookId == ebook.id);
      });
    }
  }

  Future<void> _purchaseEbook() async {
    final user = FirebaseService.getCurrentUser();
    if (user == null) return;

    if (ebook.isPaid) {
      Get.toNamed(AppRoutes.payment, arguments: ebook);
    } else {
      await FirebaseService.purchaseEbook(
        user.id,
        ebook.id,
        0,
        'free_${DateTime.now().millisecondsSinceEpoch}',
      );
      setState(() => _isPurchased = true);
      Get.snackbar('Success', 'Ebook purchased successfully');
    }
  }

  Future<void> _downloadEbook() async {
    if (_isPurchased) {
      Get.toNamed(AppRoutes.pdfViewer, arguments: {
        'url': ebook.pdfUrl,
        'title': ebook.title,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Book Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ebook Cover
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: ebook.coverUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    ebook.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        ebook.author,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating and Downloads
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${ebook.rating} (${ebook.downloads} downloads)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ebook.isPaid ? '₹${ebook.price}' : 'Free',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFF9500),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ebook.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),

                  // Purchase/Download Button
                  if (!_isPurchased)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _purchaseEbook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9500),
                        ),
                        child: Text(
                          ebook.isPaid ? 'Buy Now' : 'Get Free',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'You own this ebook',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.secondary(
                            onPressed: _downloadEbook,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.download),
                                SizedBox(width: 8),
                                Text('Open PDF'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageEbooksScreen extends StatefulWidget {
  const ManageEbooksScreen({Key? key}) : super(key: key);

  @override
  State<ManageEbooksScreen> createState() => _ManageEbooksScreenState();
}

class _ManageEbooksScreenState extends State<ManageEbooksScreen> {
  late Future<List<Ebook>> _ebooksFuture;

  @override
  void initState() {
    super.initState();
    _ebooksFuture = FirebaseService.getAllEbooks();
  }

  Future<void> _deleteEbook(String ebookId) async {
    try {
      await FirebaseService.deleteEbook(ebookId);
      setState(() {
        _ebooksFuture = FirebaseService.getAllEbooks();
      });
      Fluttertoast.showToast(msg: 'E-Book deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting ebook: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage E-Books'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Ebook>>(
        future: _ebooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF003366),
                ),
              ),
            );
          }

          final ebooks = snapshot.data ?? [];
          if (ebooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ebooks available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ebooks.length,
            itemBuilder: (context, index) {
              final ebook = ebooks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: ebook.coverUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ebook.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ebook.author,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ebook.isPaid ? '₹${ebook.price}' : 'Free',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFFF9500),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${ebook.downloads} downloads',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.secondary(
                                  onPressed: () {
                                    // Edit functionality
                                    Fluttertoast.showToast(msg: 'Edit feature coming soon');
                                  },
                                  child: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete E-Book'),
                                        content: const Text(
                                          'Are you sure you want to delete this ebook?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteEbook(ebook.id);
                                              Get.back();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
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
              );
            },
          );
        },
      ),
    );
  }
}

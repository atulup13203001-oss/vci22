import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AddEbookScreen extends StatefulWidget {
  const AddEbookScreen({Key? key}) : super(key: key);

  @override
  State<AddEbookScreen> createState() => _AddEbookScreenState();
}

class _AddEbookScreenState extends State<AddEbookScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _pdfUrlController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isPaid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _coverUrlController.dispose();
    _pdfUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addEbook() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _coverUrlController.text.isEmpty ||
        _pdfUrlController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
      return;
    }

    if (_isPaid && _priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter price for paid ebook');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ebook = Ebook(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        author: _authorController.text,
        coverUrl: _coverUrlController.text,
        pdfUrl: _pdfUrlController.text,
        price: _isPaid ? double.parse(_priceController.text) : 0,
        isPaid: _isPaid,
        rating: 0,
        downloads: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseService.addEbook(ebook);
      Fluttertoast.showToast(msg: 'E-Book added successfully');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding ebook: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New E-Book'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('E-Book Title', _titleController, 'Enter ebook title'),
              const SizedBox(height: 16),
              _buildTextField('Description', _descriptionController, 'Enter ebook description', maxLines: 4),
              const SizedBox(height: 16),
              _buildTextField('Author Name', _authorController, 'Enter author name'),
              const SizedBox(height: 16),
              _buildTextField('Cover Image URL (Google Drive)', _coverUrlController, 'Enter Google Drive cover link'),
              const SizedBox(height: 16),
              _buildTextField('PDF URL (Google Drive)', _pdfUrlController, 'Enter Google Drive PDF link'),
              const SizedBox(height: 16),

              // E-Book Type
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'E-Book Type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isPaid,
                    onChanged: (value) => setState(() => _isPaid = value),
                    activeColor: const Color(0xFFFF9500),
                  ),
                  Text(
                    _isPaid ? 'Paid' : 'Free',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price (if paid)
              if (_isPaid)
                Column(
                  children: [
                    _buildTextField('Price (₹)', _priceController, 'Enter ebook price', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                  ],
                ),

              const SizedBox(height: 30),

              // Add Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addEbook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Add E-Book',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

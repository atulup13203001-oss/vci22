import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/course_model.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _validityDaysController = TextEditingController(text: '365');
  final _videoUrlsController = TextEditingController();
  final _attachmentUrlsController = TextEditingController();
  final _totalLecturesController = TextEditingController();

  bool _isPaid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _thumbnailUrlController.dispose();
    _priceController.dispose();
    _validityDaysController.dispose();
    _videoUrlsController.dispose();
    _attachmentUrlsController.dispose();
    _totalLecturesController.dispose();
    super.dispose();
  }

  Future<void> _addCourse() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _instructorController.text.isEmpty ||
        _thumbnailUrlController.text.isEmpty ||
        _totalLecturesController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
      return;
    }

    if (_isPaid && _priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter price for paid course');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final course = Course(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        instructor: _instructorController.text,
        thumbnailUrl: _thumbnailUrlController.text,
        price: _isPaid ? double.parse(_priceController.text) : 0,
        isPaid: _isPaid,
        validityDays: int.parse(_validityDaysController.text),
        videoUrls: _videoUrlsController.text
            .split('\n')
            .where((url) => url.isNotEmpty)
            .toList(),
        attachmentUrls: _attachmentUrlsController.text
            .split('\n')
            .where((url) => url.isNotEmpty)
            .toList(),
        totalLectures: int.parse(_totalLecturesController.text),
        rating: 0,
        enrolledStudents: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseService.addCourse(course);
      Fluttertoast.showToast(msg: 'Course added successfully');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding course: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Course'),
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
              _buildTextField('Course Title', _titleController, 'Enter course title'),
              const SizedBox(height: 16),
              _buildTextField('Description', _descriptionController, 'Enter course description', maxLines: 4),
              const SizedBox(height: 16),
              _buildTextField('Instructor Name', _instructorController, 'Enter instructor name'),
              const SizedBox(height: 16),
              _buildTextField('Thumbnail URL (Google Drive)', _thumbnailUrlController, 'Enter Google Drive thumbnail link'),
              const SizedBox(height: 16),
              _buildTextField('Total Lectures', _totalLecturesController, 'Enter number of lectures', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Course Validity (Days)', _validityDaysController, 'Enter validity in days', keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              // Course Type
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Course Type',
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
                    _buildTextField('Price (₹)', _priceController, 'Enter course price', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                  ],
                ),

              _buildTextField(
                'Video URLs (YouTube)',
                _videoUrlsController,
                'Enter YouTube URLs (one per line)',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Attachment URLs (Google Drive PDFs)',
                _attachmentUrlsController,
                'Enter Google Drive PDF links (one per line)',
                maxLines: 4,
              ),
              const SizedBox(height: 30),

              // Add Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Add Course',
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

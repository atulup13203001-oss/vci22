import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/course_model.dart';
import 'package:vimal_coaching_institute/routes/app_routes.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course course;
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    course = Get.arguments as Course;
    _checkEnrollment();
  }

  Future<void> _checkEnrollment() async {
    final user = FirebaseService.getCurrentUser();
    if (user != null) {
      final enrollments = await FirebaseService.getStudentEnrollments(user.id);
      setState(() {
        _isEnrolled = enrollments.any((e) => e.courseId == course.id);
      });
    }
  }

  Future<void> _enrollCourse() async {
    final user = FirebaseService.getCurrentUser();
    if (user == null) return;

    if (course.isPaid) {
      Get.toNamed(AppRoutes.payment, arguments: course);
    } else {
      await FirebaseService.enrollStudent(user.id, course.id, course.validityDays);
      setState(() => _isEnrolled = true);
      Get.snackbar('Success', 'Enrolled in course successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Check out this course: ${course.title}\n\n'
                '${course.description}\n\n'
                'Join Vimal Coaching Institute and start learning today!',
                subject: 'Course Sharing: ${course.title}',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: course.thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
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
                    course.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Instructor
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        course.instructor,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating and Enrolled
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${course.rating} (${course.enrolledStudents} enrolled)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${course.totalLectures} Lectures',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFFF9500),
                          ),
                        ),
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
                    course.isPaid ? '₹${course.price}' : 'Free',
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
                    course.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Course Validity
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Course validity: ${course.validityDays} days',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Videos Section
                  if (course.videoUrls.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video Lectures',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: course.videoUrls.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: _isEnrolled
                                  ? () => Get.toNamed(
                                AppRoutes.videoPlayer,
                                arguments: {
                                  'url': course.videoUrls[index],
                                  'title': 'Lecture ${index + 1}',
                                },
                              )
                                  : null,
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.play_circle_outline),
                                  title: Text('Lecture ${index + 1}'),
                                  trailing: _isEnrolled
                                      ? const Icon(Icons.arrow_forward_ios, size: 16)
                                      : const Icon(Icons.lock, size: 16),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  // Attachments Section
                  if (course.attachmentUrls.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attachments',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: course.attachmentUrls.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: _isEnrolled
                                  ? () => Get.toNamed(
                                AppRoutes.pdfViewer,
                                arguments: {
                                  'url': course.attachmentUrls[index],
                                  'title': 'Attachment ${index + 1}',
                                },
                              )
                                  : null,
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.picture_as_pdf),
                                  title: Text('Attachment ${index + 1}'),
                                  trailing: _isEnrolled
                                      ? const Icon(Icons.arrow_forward_ios, size: 16)
                                      : const Icon(Icons.lock, size: 16),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  // Enroll Button
                  if (!_isEnrolled)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _enrollCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9500),
                        ),
                        child: Text(
                          course.isPaid ? 'Enroll Now' : 'Enroll Free',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
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
                            'You are enrolled in this course',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

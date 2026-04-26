import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/routes/app_routes.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late Future<Map<String, dynamic>> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = FirebaseService.getAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseService.logout();
              Get.offAllNamed(AppRoutes.adminLogin);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analytics Cards
              FutureBuilder<Map<String, dynamic>>(
                future: _analyticsFuture,
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

                  final analytics = snapshot.data ?? {};
                  return Column(
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _buildAnalyticsCard(
                            context,
                            'Total Courses',
                            analytics['totalCourses']?.toString() ?? '0',
                            Icons.book,
                            Colors.blue,
                          ),
                          _buildAnalyticsCard(
                            context,
                            'Total E-Books',
                            analytics['totalEbooks']?.toString() ?? '0',
                            Icons.library_books,
                            Colors.green,
                          ),
                          _buildAnalyticsCard(
                            context,
                            'Total Enrollments',
                            analytics['totalEnrollments']?.toString() ?? '0',
                            Icons.people,
                            Colors.orange,
                          ),
                          _buildAnalyticsCard(
                            context,
                            'E-Book Purchases',
                            analytics['totalEbookPurchases']?.toString() ?? '0',
                            Icons.shopping_cart,
                            Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Revenue',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${analytics['totalRevenue']?.toStringAsFixed(2) ?? '0.00'}',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: const Color(0xFFFF9500),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.trending_up,
                                size: 40,
                                color: Colors.green.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),

              // Management Options
              Text(
                'Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                'Manage Courses',
                'Add, edit, or delete courses',
                Icons.book,
                () => Get.toNamed(AppRoutes.manageCourses),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                context,
                'Add New Course',
                'Create a new course',
                Icons.add_circle,
                () => Get.toNamed(AppRoutes.addCourse),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                context,
                'Manage E-Books',
                'Add, edit, or delete e-books',
                Icons.library_books,
                () => Get.toNamed(AppRoutes.manageEbooks),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                context,
                'Add New E-Book',
                'Create a new e-book',
                Icons.add_circle,
                () => Get.toNamed(AppRoutes.addEbook),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                context,
                'Payment Settings',
                'Configure Razorpay and UPI',
                Icons.payment,
                () => Get.toNamed(AppRoutes.paymentSettings),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                context,
                'Analytics',
                'View detailed analytics',
                Icons.analytics,
                () => Get.toNamed(AppRoutes.analytics),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF003366)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

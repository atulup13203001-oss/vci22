import 'package:flutter/material.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
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
        title: const Text('Analytics'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
          final totalCourses = analytics['totalCourses'] ?? 0;
          final totalEbooks = analytics['totalEbooks'] ?? 0;
          final totalEnrollments = analytics['totalEnrollments'] ?? 0;
          final totalEbookPurchases = analytics['totalEbookPurchases'] ?? 0;
          final totalRevenue = (analytics['totalRevenue'] ?? 0).toDouble();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildAnalyticsCard(
                        context,
                        'Courses',
                        totalCourses.toString(),
                        Icons.book,
                        Colors.blue,
                      ),
                      _buildAnalyticsCard(
                        context,
                        'E-Books',
                        totalEbooks.toString(),
                        Icons.library_books,
                        Colors.green,
                      ),
                      _buildAnalyticsCard(
                        context,
                        'Enrollments',
                        totalEnrollments.toString(),
                        Icons.people,
                        Colors.orange,
                      ),
                      _buildAnalyticsCard(
                        context,
                        'E-Book Sales',
                        totalEbookPurchases.toString(),
                        Icons.shopping_cart,
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Revenue Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Revenue',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '₹${totalRevenue.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: const Color(0xFFFF9500),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Revenue from ${totalEbookPurchases} ebook purchases',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Content Distribution',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: totalCourses.toDouble(),
                                    title: 'Courses\n$totalCourses',
                                    color: Colors.blue,
                                    radius: 50,
                                  ),
                                  PieChartSectionData(
                                    value: totalEbooks.toDouble(),
                                    title: 'E-Books\n$totalEbooks',
                                    color: Colors.green,
                                    radius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Engagement Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Engagement Statistics',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            'Average Enrollments per Course',
                            totalCourses > 0
                                ? (totalEnrollments / totalCourses).toStringAsFixed(1)
                                : '0',
                          ),
                          const SizedBox(height: 12),
                          _buildStatRow(
                            'Average Sales per E-Book',
                            totalEbooks > 0
                                ? (totalEbookPurchases / totalEbooks).toStringAsFixed(1)
                                : '0',
                          ),
                          const SizedBox(height: 12),
                          _buildStatRow(
                            'Average Revenue per Sale',
                            totalEbookPurchases > 0
                                ? '₹${(totalRevenue / totalEbookPurchases).toStringAsFixed(2)}'
                                : '₹0.00',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF9500),
          ),
        ),
      ],
    );
  }
}

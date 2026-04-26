import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/routes/app_routes.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    final user = FirebaseService.getCurrentUser();
    if (user != null) {
      Get.offAllNamed(AppRoutes.studentHome);
    } else {
      Get.offAllNamed(AppRoutes.studentLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF9500),
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  'VCI',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: const Color(0xFFFF9500),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Vimal Coaching Institute',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Learn, Grow, Succeed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9500)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:vimal_coaching_institute/screens/student/splash_screen.dart';
import 'package:vimal_coaching_institute/screens/auth/student_login_screen.dart';
import 'package:vimal_coaching_institute/screens/auth/student_signup_screen.dart';
import 'package:vimal_coaching_institute/screens/auth/admin_login_screen.dart';
import 'package:vimal_coaching_institute/screens/auth/admin_signup_screen.dart';
import 'package:vimal_coaching_institute/screens/student/home_screen.dart';
import 'package:vimal_coaching_institute/screens/student/course_detail_screen.dart';
import 'package:vimal_coaching_institute/screens/student/video_player_screen.dart';
import 'package:vimal_coaching_institute/screens/student/pdf_viewer_screen.dart';
import 'package:vimal_coaching_institute/screens/student/ebook_detail_screen.dart';
import 'package:vimal_coaching_institute/screens/student/payment_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/admin_home_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/add_course_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/manage_courses_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/add_ebook_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/manage_ebooks_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/payment_settings_screen.dart';
import 'package:vimal_coaching_institute/screens/admin/analytics_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String studentLogin = '/student-login';
  static const String studentSignup = '/student-signup';
  static const String adminLogin = '/admin-login';
  static const String adminSignup = '/admin-signup';
  static const String studentHome = '/student-home';
  static const String courseDetail = '/course-detail';
  static const String videoPlayer = '/video-player';
  static const String pdfViewer = '/pdf-viewer';
  static const String ebookDetail = '/ebook-detail';
  static const String payment = '/payment';
  static const String adminHome = '/admin-home';
  static const String addCourse = '/add-course';
  static const String manageCourses = '/manage-courses';
  static const String addEbook = '/add-ebook';
  static const String manageEbooks = '/manage-ebooks';
  static const String paymentSettings = '/payment-settings';
  static const String analytics = '/analytics';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: studentLogin, page: () => const StudentLoginScreen()),
    GetPage(name: studentSignup, page: () => const StudentSignupScreen()),
    GetPage(name: adminLogin, page: () => const AdminLoginScreen()),
    GetPage(name: adminSignup, page: () => const AdminSignupScreen()),
    GetPage(name: studentHome, page: () => const StudentHomeScreen()),
    GetPage(name: courseDetail, page: () => const CourseDetailScreen()),
    GetPage(name: videoPlayer, page: () => const VideoPlayerScreen()),
    GetPage(name: pdfViewer, page: () => const PdfViewerScreen()),
    GetPage(name: ebookDetail, page: () => const EbookDetailScreen()),
    GetPage(name: payment, page: () => const PaymentScreen()),
    GetPage(name: adminHome, page: () => const AdminHomeScreen()),
    GetPage(name: addCourse, page: () => const AddCourseScreen()),
    GetPage(name: manageCourses, page: () => const ManageCoursesScreen()),
    GetPage(name: addEbook, page: () => const AddEbookScreen()),
    GetPage(name: manageEbooks, page: () => const ManageEbooksScreen()),
    GetPage(name: paymentSettings, page: () => const PaymentSettingsScreen()),
    GetPage(name: analytics, page: () => const AnalyticsScreen()),
  ];
}

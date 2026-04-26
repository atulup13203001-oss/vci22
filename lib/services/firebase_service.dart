import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vimal_coaching_institute/models/course_model.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Auth
  static Future<UserCredential> studentSignup(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  static Future<UserCredential> studentLogin(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
  static Future<void> logout() async => await _auth.signOut();
  static User? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: '',
      profileImage: user.photoURL ?? '',
      isAdmin: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // User
  static Future<void> createUserProfile(String userId, Map<String, dynamic> userData) async {
    await _database.ref().child('users').child(userId).set(userData);
  }
  static Future<User?> getUserProfile(String userId) async {
    try {
      final snapshot = await _database.ref().child('users').child(userId).get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        final converted = Map<String, dynamic>.from(data);
        return User.fromJson(converted);
      }
    } catch (e) { print(e); }
    return null;
  }

  // Courses
  static Future<void> addCourse(Course course) async {
    await _database.ref().child('courses').child(course.id).set(course.toJson());
  }
  static Future<List<Course>> getAllCourses() async {
    try {
      final snapshot = await _database.ref().child('courses').get();
      if (snapshot.exists) {
        final values = snapshot.value as Map<dynamic, dynamic>;
        return values.values.map((v) => Course.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) { print(e); }
    return [];
  }
  static Future<Course?> getCourseById(String courseId) async {
    try {
      final snapshot = await _database.ref().child('courses').child(courseId).get();
      if (snapshot.exists) {
        return Course.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) { print(e); }
    return null;
  }
  static Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    await _database.ref().child('courses').child(courseId).update(data);
  }
  static Future<void> deleteCourse(String courseId) async {
    await _database.ref().child('courses').child(courseId).remove();
  }

  // Ebooks
  static Future<void> addEbook(Ebook ebook) async {
    await _database.ref().child('ebooks').child(ebook.id).set(ebook.toJson());
  }
  static Future<List<Ebook>> getAllEbooks() async {
    try {
      final snapshot = await _database.ref().child('ebooks').get();
      if (snapshot.exists) {
        final values = snapshot.value as Map<dynamic, dynamic>;
        return values.values.map((v) => Ebook.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) { print(e); }
    return [];
  }
  static Future<Ebook?> getEbookById(String ebookId) async {
    try {
      final snapshot = await _database.ref().child('ebooks').child(ebookId).get();
      if (snapshot.exists) {
        return Ebook.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) { print(e); }
    return null;
  }
  static Future<void> updateEbook(String ebookId, Map<String, dynamic> data) async {
    await _database.ref().child('ebooks').child(ebookId).update(data);
  }
  static Future<void> deleteEbook(String ebookId) async {
    await _database.ref().child('ebooks').child(ebookId).remove();
  }

  // Enrollments
  static Future<void> enrollStudent(String studentId, String courseId, int validityDays) async {
    final ref = _database.ref().child('enrollments').push();
    final enrollment = StudentEnrollment(
      id: ref.key!,
      studentId: studentId,
      courseId: courseId,
      enrolledAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: validityDays)),
      isCompleted: false,
    );
    await ref.set(enrollment.toJson());
  }
  static Future<List<StudentEnrollment>> getStudentEnrollments(String studentId) async {
    try {
      final snapshot = await _database.ref().child('enrollments')
          .orderByChild('studentId')
          .equalTo(studentId)
          .get();
      if (snapshot.exists) {
        final values = snapshot.value as Map<dynamic, dynamic>;
        return values.values.map((v) => StudentEnrollment.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) { print(e); }
    return [];
  }

  // Ebook purchases
  static Future<void> purchaseEbook(String studentId, String ebookId, double amount, String paymentId) async {
    final ref = _database.ref().child('ebook_purchases').push();
    final purchase = EbookPurchase(
      id: ref.key!,
      studentId: studentId,
      ebookId: ebookId,
      purchasedAt: DateTime.now(),
      amount: amount,
      paymentId: paymentId,
    );
    await ref.set(purchase.toJson());
  }
  static Future<List<EbookPurchase>> getStudentEbookPurchases(String studentId) async {
    try {
      final snapshot = await _database.ref().child('ebook_purchases')
          .orderByChild('studentId')
          .equalTo(studentId)
          .get();
      if (snapshot.exists) {
        final values = snapshot.value as Map<dynamic, dynamic>;
        return values.values.map((v) => EbookPurchase.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) { print(e); }
    return [];
  }

  // Payment settings
  static Future<void> updatePaymentSettings(Map<String, dynamic> settings) async {
    await _database.ref().child('settings').child('payment').set(settings);
  }
  static Future<Map<String, dynamic>?> getPaymentSettings() async {
    try {
      final snapshot = await _database.ref().child('settings').child('payment').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
    } catch (e) { print(e); }
    return null;
  }

  // Analytics
  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final courses = await _database.ref().child('courses').get();
      final ebooks = await _database.ref().child('ebooks').get();
      final enrollments = await _database.ref().child('enrollments').get();
      final purchases = await _database.ref().child('ebook_purchases').get();
      double revenue = 0;
      int purchaseCount = 0;
      if (purchases.exists) {
        final map = purchases.value as Map;
        purchaseCount = map.length;
        map.forEach((k, v) {
          revenue += (v as Map)['amount']?.toDouble() ?? 0.0;
        });
      }
      return {
        'totalCourses': courses.exists ? (courses.value as Map).length : 0,
        'totalEbooks': ebooks.exists ? (ebooks.value as Map).length : 0,
        'totalEnrollments': enrollments.exists ? (enrollments.value as Map).length : 0,
        'totalEbookPurchases': purchaseCount,
        'totalRevenue': revenue,
      };
    } catch (e) { print(e); return {}; }
  }
}

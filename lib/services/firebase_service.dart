import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vimal_coaching_institute/models/course_model.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Auth Methods
  static Future<UserCredential> studentSignup(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> studentLogin(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser != null ? User(
      id: _auth.currentUser!.uid,
      email: _auth.currentUser!.email ?? '',
      name: _auth.currentUser!.displayName ?? '',
      phone: '',
      profileImage: _auth.currentUser!.photoURL ?? '',
      isAdmin: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ) : null;
  }

  // User Methods
  static Future<void> createUserProfile(String userId, Map<String, dynamic> userData) async {
    await _database.ref().child('users').child(userId).set(userData);
  }

  static Future<User?> getUserProfile(String userId) async {
    try {
      final snapshot = await _database.ref().child('users').child(userId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return User.fromJson(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  // Course Methods
  static Future<void> addCourse(Course course) async {
    await _database.ref().child('courses').child(course.id).set(course.toJson());
  }

  static Future<List<Course>> getAllCourses() async {
    try {
      final snapshot = await _database.ref().child('courses').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> values = snapshot.value as Map;
        return values.values.map((v) => Course.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
    return [];
  }

  static Future<Course?> getCourseById(String courseId) async {
    try {
      final snapshot = await _database.ref().child('courses').child(courseId).get();
      if (snapshot.exists) {
        return Course.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) {
      print('Error fetching course: $e');
    }
    return null;
  }

  static Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    await _database.ref().child('courses').child(courseId).update(data);
  }

  static Future<void> deleteCourse(String courseId) async {
    await _database.ref().child('courses').child(courseId).remove();
  }

  // Ebook Methods
  static Future<void> addEbook(Ebook ebook) async {
    await _database.ref().child('ebooks').child(ebook.id).set(ebook.toJson());
  }

  static Future<List<Ebook>> getAllEbooks() async {
    try {
      final snapshot = await _database.ref().child('ebooks').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> values = snapshot.value as Map;
        return values.values.map((v) => Ebook.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) {
      print('Error fetching ebooks: $e');
    }
    return [];
  }

  static Future<Ebook?> getEbookById(String ebookId) async {
    try {
      final snapshot = await _database.ref().child('ebooks').child(ebookId).get();
      if (snapshot.exists) {
        return Ebook.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) {
      print('Error fetching ebook: $e');
    }
    return null;
  }

  static Future<void> updateEbook(String ebookId, Map<String, dynamic> data) async {
    await _database.ref().child('ebooks').child(ebookId).update(data);
  }

  static Future<void> deleteEbook(String ebookId) async {
    await _database.ref().child('ebooks').child(ebookId).remove();
  }

  // Enrollment Methods
  static Future<void> enrollStudent(String studentId, String courseId, int validityDays) async {
    final enrollmentRef = _database.ref().child('enrollments').push();
    final enrollment = StudentEnrollment(
      id: enrollmentRef.key!,
      studentId: studentId,
      courseId: courseId,
      enrolledAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: validityDays)),
      isCompleted: false,
    );
    await enrollmentRef.set(enrollment.toJson());
  }

  static Future<List<StudentEnrollment>> getStudentEnrollments(String studentId) async {
    try {
      final snapshot = await _database.ref().child('enrollments')
          .orderByChild('studentId')
          .equalTo(studentId)
          .get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> values = snapshot.value as Map;
        return values.values.map((v) => StudentEnrollment.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) {
      print('Error fetching enrollments: $e');
    }
    return [];
  }

  // Ebook Purchase Methods
  static Future<void> purchaseEbook(String studentId, String ebookId, double amount, String paymentId) async {
    final purchaseRef = _database.ref().child('ebook_purchases').push();
    final purchase = EbookPurchase(
      id: purchaseRef.key!,
      studentId: studentId,
      ebookId: ebookId,
      purchasedAt: DateTime.now(),
      amount: amount,
      paymentId: paymentId,
    );
    await purchaseRef.set(purchase.toJson());
  }

  static Future<List<EbookPurchase>> getStudentEbookPurchases(String studentId) async {
    try {
      final snapshot = await _database.ref().child('ebook_purchases')
          .orderByChild('studentId')
          .equalTo(studentId)
          .get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> values = snapshot.value as Map;
        return values.values.map((v) => EbookPurchase.fromJson(Map<String, dynamic>.from(v))).toList();
      }
    } catch (e) {
      print('Error fetching ebook purchases: $e');
    }
    return [];
  }

  // Payment Settings
  static Future<void> updatePaymentSettings(Map<String, dynamic> settings) async {
    await _database.ref().child('settings').child('payment').set(settings);
  }

  static Future<Map<String, dynamic>?> getPaymentSettings() async {
    try {
      final snapshot = await _database.ref().child('settings').child('payment').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
    } catch (e) {
      print('Error fetching payment settings: $e');
    }
    return null;
  }

  // Analytics
  static Future<void> recordAnalytics(String event, Map<String, dynamic> data) async {
    await _database.ref().child('analytics').push().set({
      'event': event,
      'timestamp': DateTime.now().toIso8601String(),
      ...data,
    });
  }

  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final coursesSnapshot = await _database.ref().child('courses').get();
      final ebooksSnapshot = await _database.ref().child('ebooks').get();
      final enrollmentsSnapshot = await _database.ref().child('enrollments').get();
      final purchasesSnapshot = await _database.ref().child('ebook_purchases').get();

      double totalRevenue = 0;
      int ebookPurchasesCount = 0;
      if (purchasesSnapshot.exists) {
        final Map<dynamic, dynamic> purchases = purchasesSnapshot.value as Map;
        ebookPurchasesCount = purchases.length;
        purchases.forEach((key, value) {
          totalRevenue += (value['amount'] ?? 0).toDouble();
        });
      }

      return {
        'totalCourses': coursesSnapshot.exists ? (coursesSnapshot.value as Map).length : 0,
        'totalEbooks': ebooksSnapshot.exists ? (ebooksSnapshot.value as Map).length : 0,
        'totalEnrollments': enrollmentsSnapshot.exists ? (enrollmentsSnapshot.value as Map).length : 0,
        'totalEbookPurchases': ebookPurchasesCount,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      print('Error fetching analytics: $e');
      return {};
    }
  }
}

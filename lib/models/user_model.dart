class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String profileImage;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.profileImage,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class StudentEnrollment {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime enrolledAt;
  final DateTime expiresAt;
  final bool isCompleted;

  StudentEnrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrolledAt,
    required this.expiresAt,
    required this.isCompleted,
  });

  factory StudentEnrollment.fromJson(Map<String, dynamic> json) {
    return StudentEnrollment(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      courseId: json['courseId'] ?? '',
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'])
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'enrolledAt': enrolledAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

class EbookPurchase {
  final String id;
  final String studentId;
  final String ebookId;
  final DateTime purchasedAt;
  final double amount;
  final String paymentId;

  EbookPurchase({
    required this.id,
    required this.studentId,
    required this.ebookId,
    required this.purchasedAt,
    required this.amount,
    required this.paymentId,
  });

  factory EbookPurchase.fromJson(Map<String, dynamic> json) {
    return EbookPurchase(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      ebookId: json['ebookId'] ?? '',
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'])
          : DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      paymentId: json['paymentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'ebookId': ebookId,
      'purchasedAt': purchasedAt.toIso8601String(),
      'amount': amount,
      'paymentId': paymentId,
    };
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnailUrl; // Google Drive link
  final double price;
  final bool isPaid;
  final int validityDays; // Course validity in days
  final List<String> videoUrls; // YouTube unlisted video URLs
  final List<String> attachmentUrls; // Google Drive PDF links
  final int totalLectures;
  final double rating;
  final int enrolledStudents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnailUrl,
    required this.price,
    required this.isPaid,
    required this.validityDays,
    required this.videoUrls,
    required this.attachmentUrls,
    required this.totalLectures,
    required this.rating,
    required this.enrolledStudents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isPaid: json['isPaid'] ?? false,
      validityDays: json['validityDays'] ?? 365,
      videoUrls: List<String>.from(json['videoUrls'] ?? []),
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      totalLectures: json['totalLectures'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      enrolledStudents: json['enrolledStudents'] ?? 0,
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
      'title': title,
      'description': description,
      'instructor': instructor,
      'thumbnailUrl': thumbnailUrl,
      'price': price,
      'isPaid': isPaid,
      'validityDays': validityDays,
      'videoUrls': videoUrls,
      'attachmentUrls': attachmentUrls,
      'totalLectures': totalLectures,
      'rating': rating,
      'enrolledStudents': enrolledStudents,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

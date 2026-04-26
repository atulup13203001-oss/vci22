class Ebook {
  final String id;
  final String title;
  final String description;
  final String author;
  final String coverUrl; // Google Drive link
  final String pdfUrl; // Google Drive PDF link
  final double price;
  final bool isPaid;
  final double rating;
  final int downloads;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ebook({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverUrl,
    required this.pdfUrl,
    required this.price,
    required this.isPaid,
    required this.rating,
    required this.downloads,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ebook.fromJson(Map<String, dynamic> json) {
    return Ebook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isPaid: json['isPaid'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      downloads: json['downloads'] ?? 0,
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
      'author': author,
      'coverUrl': coverUrl,
      'pdfUrl': pdfUrl,
      'price': price,
      'isPaid': isPaid,
      'rating': rating,
      'downloads': downloads,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

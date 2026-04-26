import 'package:flutter/material.dart';

// Placeholder screens for admin routes that need to be implemented
class PlaceholderAdminScreen extends StatelessWidget {
  final String title;
  const PlaceholderAdminScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('$title - Coming Soon'),
      ),
    );
  }
}

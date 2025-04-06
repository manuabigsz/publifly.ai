import 'package:flutter/material.dart';

import '../../util/web_view_page.dart';

class ResultSearchContentCard extends StatelessWidget {
  final String title;
  final String description;
  final String source;
  final String readTime;
  final String imageUrl;
  final String link;

  const ResultSearchContentCard({
    super.key,
    required this.title,
    required this.description,
    required this.source,
    required this.readTime,
    required this.imageUrl,
    required this.link,
  });

  void _launchURL(BuildContext context) {
    if (link.isEmpty || link == '#') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link inválido')),
      );
      return;
    }

    final url = link.startsWith('http') ? link : 'https://$link';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InAppWebViewPage(url: url),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  source,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  readTime,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

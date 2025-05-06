import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../generate_content_page/generate_content_page.dart';
import '../generated_content_page/generated_content_page.dart';

class GeneratedContentListPage extends StatelessWidget {
  const GeneratedContentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdos Gerados'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('generated_contents')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum conteúdo gerado ainda.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final topic = data['topic'] ?? 'Sem tópico';
              final platform = data['platform'] ?? '';
              final content = data['content'] ?? '';
              final imageDescription = data['image_description'] ?? '';
              final url = data['url'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;
              final imageGeneratedUrl = data['image_generated_url'] ?? '';

              return ListTile(
                title: Text(topic,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(platform),
                trailing: Text(
                  timestamp != null
                      ? _formatDate(timestamp.toDate())
                      : 'Data indefinida',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                leading: const Icon(Icons.article_outlined),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GeneratedContentPage(
                        hasGenerated: true,
                        topic: topic,
                        platform: platform,
                        url: url,
                        content:
                            '$content\n\n🖼️ Descrição da Imagem:\n$imageDescription',
                        imageGeneratedUrl: imageGeneratedUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContentGeneratorPage(),
                ));
          }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

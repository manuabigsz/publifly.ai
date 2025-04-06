import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../contents/generate_content_page.dart';
import '../widgets/result_card.dart';

class SearchContentList extends StatefulWidget {
  const SearchContentList({super.key});

  @override
  State<SearchContentList> createState() => _SearchContentListState();
}

class _SearchContentListState extends State<SearchContentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Salvos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('search_themes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum resultado encontrado.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Column(
                children: [
                  ResultSearchContentCard(
                    title: data['title'] ?? 'Sem título',
                    description: data['description'] ?? 'Sem descrição',
                    source: data['source'] ?? 'Fonte desconhecida',
                    readTime: data['readTime'] ?? 'Data não disponível',
                    imageUrl: data['imageUrl'] ?? '',
                    link: data['link'] ?? '#',
                  ),
                  const SizedBox(height: 10),
                ],
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
              ),
            );
          }),
    );
  }
}

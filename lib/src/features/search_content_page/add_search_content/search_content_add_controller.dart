import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../search_content_result.dart';

class SearchContentController {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);

  Future<void> startSearch(BuildContext context) async {
    final String query = textController.text.trim();
    if (query.isEmpty) return;

    progressNotifier.value = 0.3;

    final Uri url =
        Uri.parse('https://publify-serper-u7el.onrender.com/search?q=$query');
    final response = await http.get(url);

    progressNotifier.value = 1.0;

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      final List results = decodedResponse["news"] ?? [];

      // Salvar no Firestore
      final CollectionReference searchCollection =
          FirebaseFirestore.instance.collection('search_themes');

      for (var result in results) {
        await searchCollection.add({
          'title': result['title'] ?? 'Sem título',
          'description': result['snippet'] ?? 'Sem descrição',
          'source': result['source'] ?? 'Fonte desconhecida',
          'readTime': result['date'] ?? 'Data não disponível',
          'imageUrl': result['imageUrl'] ?? '',
          'link': result['link'] ?? '#',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchContentResultPage(results: results),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar resultados.')),
      );
    }
  }

  void dispose() {
    textController.dispose();
    progressNotifier.dispose();
  }
}

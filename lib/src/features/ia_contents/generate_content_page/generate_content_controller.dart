import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ContentGeneratorController {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);

  String? temaSelecionado;
  String? urlSelecionada;
  String? plataformaSelecionada;
  String? tamanhoSelecionado;
  String? targetPublic;
  String? tone;
  bool isLoading = false;

  final List<String> plataformas = ['Linkedin', 'Instagram', 'Facebook'];
  final List<String> tamanhos = ['Curto', 'Médio', 'Longo'];
  final List<String> publics = [
    'Empreendedores',
    'Estudantes',
    'Profissionais de Marketing',
    'Desenvolvedores',
    'Público geral'
  ];

  final List<String> tones = [
    'Divertido',
    'Sério',
    'Técnico',
    'Inspirador',
    'Informal'
  ];

  Future<List<Map<String, dynamic>>> fetchThemes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('search_themes').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'title': data['title'],
        'url': data['link'],
      };
    }).toList();
  }

  Future<String?> generateContent({
    required String topic,
    required String url,
    required String platform,
    required String textLenght,
    required String targetPublic,
    required String tone,
  }) async {
    final uri = Uri.parse('https://tcc-gemini-api.onrender.com/generate');
    progressNotifier.value = 0.3;
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'topic': topic,
          'url': url,
          'platform': platform.toLowerCase(),
          "text_lenght": textLenght,
          "target_public": targetPublic,
          "tone": tone
        }),
      );

      progressNotifier.value = 1.0;

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        return body['result']['raw'] as String?;
      } else {
        print('Erro ao gerar conteúdo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        progressNotifier.value = 0.0;
      });
    }
    return null;
  }
}

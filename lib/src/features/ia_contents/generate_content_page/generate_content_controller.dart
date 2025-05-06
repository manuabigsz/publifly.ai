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

  String? modeloSelecionado;
  String? modeloUrlSelecionado;

  final List<Map<String, String>> modelos = [
    {
      'nome': 'Gemini Flash 1.5',
      'url': 'https://tcc-gemini-api.onrender.com/generate'
    },
    {
      'nome': 'Groq - Lhamma',
      'url': 'https://tcc-groq-api.onrender.com/generate'
    },
  ];
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
        'imageUrl': data['imageUrl'],
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
    required String urlAgente,
  }) async {
    final uri = Uri.parse(urlAgente);
    print("solicitando para agente $urlAgente");
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
        print(
            'Erro ao gerar conteúdo: ${response.statusCode} - ${response.body}');
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

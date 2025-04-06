import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratedContentController {
  final String content;
  final String topic;
  final String url;
  final String platform;

  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageDescController = TextEditingController();

  final ValueNotifier<bool> isSavingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSavedNotifier = ValueNotifier(false);

  String mainContent = '';
  String imageDescription = '';

  GeneratedContentController({
    required this.content,
    required this.topic,
    required this.url,
    required this.platform,
  }) {
    _separateContentAndImageDescription();
    contentController.text = mainContent;
    imageDescController.text = imageDescription;
  }

  void _separateContentAndImageDescription() {
    final parts = content.split('🖼️ Descrição da Imagem:');
    if (parts.length > 1) {
      mainContent = parts[0].trim();
      imageDescription = parts[1].trim();
    } else {
      mainContent = content.trim();
      imageDescription = '';
    }
  }

  Future<void> saveContentToFirestore() async {
    isSavingNotifier.value = true;

    await FirebaseFirestore.instance.collection('generated_contents').add({
      'topic': topic,
      'url': url,
      'platform': platform,
      'content': mainContent,
      'image_description': imageDescription,
      'timestamp': FieldValue.serverTimestamp(),
    });

    isSavingNotifier.value = false;
    isSavedNotifier.value = true;
  }

  Future<void> updateGeneratedContent() async {
    isSavingNotifier.value = true;

    final query = await FirebaseFirestore.instance
        .collection('generated_contents')
        .where('topic', isEqualTo: topic)
        .where('platform', isEqualTo: platform)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'content': contentController.text.trim(),
        'image_description': imageDescController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    isSavingNotifier.value = false;
  }
}

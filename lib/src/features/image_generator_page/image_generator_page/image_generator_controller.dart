import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader_web/image_downloader_web.dart';
import '../../../shared/util/image_filebase_uploader.dart';

class ImageGeneratorController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final UploadImagemFilebase uploader = UploadImagemFilebase();

  String? imageUrl;
  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> generateImage() async {
    final texto = textController.text.trim();
    if (texto.isEmpty) return;

    _setLoading(true);

    final encodedText = Uri.encodeComponent(texto);
    final url =
        'https://image.pollinations.ai/prompt/$encodedText?width=720&height=1280&seed=1803437057&model=flux&token=desktophut&negative_prompt=worst%20quality%2C%20blurry';

    imageUrl = url;
    _setLoading(false);
  }

  Future<void> downloadImage(BuildContext context) async {
    if (imageUrl != null) {
      try {
        await WebImageDownloader.downloadImageFromWeb(imageUrl!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem baixada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao baixar: $e')),
        );
      }
    }
  }

  Future<void> salvarImagem(BuildContext context, String contentTitle) async {
    if (imageUrl == null) return;

    try {
      _setLoading(true);

      final response = await http.get(Uri.parse(imageUrl!));
      final bytes = response.bodyBytes;

      final text = textController.text.trim();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final objectUrl = await uploader.uploadAndFetchCid(bytes, fileName);

      if (objectUrl == null) {
        throw Exception('Erro ao obter URL do Filebase');
      }

      await FirebaseFirestore.instance.collection('generated_images').add({
        'objectUrl': objectUrl,
        'textGeneration': text,
        'createdAt': DateTime.now(),
        'contentTitle': contentTitle,
      });

      await updateGeneratedContentImage(contentTitle, objectUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem salva com sucesso!')),
      );
    } catch (e) {
      debugPrint('Erro ao salvar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateGeneratedContentImage(
      String topic, String imageUrl) async {
    final query = await FirebaseFirestore.instance
        .collection('generated_contents')
        .where('topic', isEqualTo: topic)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'image_generated_url': imageUrl,
      });
    }
  }

  void disposeController() {
    textController.dispose();
  }
}

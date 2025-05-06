import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_generator_controller.dart';

class ImageGeneratorPage extends StatelessWidget {
  final String? imageDescription;
  final String? contentId;
  const ImageGeneratorPage({super.key, this.imageDescription, this.contentId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageGeneratorController(),
      child: _ImageGeneratorView(
        contentId: contentId,
        imageDescription: imageDescription,
      ),
    );
  }
}

class _ImageGeneratorView extends StatelessWidget {
  final String? imageDescription;
  final String? contentId;
  const _ImageGeneratorView({this.imageDescription, this.contentId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ImageGeneratorController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (imageDescription != null &&
          controller.textController.text != imageDescription) {
        controller.textController.text = imageDescription!;
      }
    });

    return Scaffold(
      appBar:
          AppBar(title: Text('Gerador de Imagens - ${imageDescription ?? ''}')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Descrição da Imagem',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Descreva a imagem que você deseja gerar...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : controller.generateImage,
                      child: controller.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Gerar Imagem'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : controller.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    controller.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image,
                                          size: 50.0, color: Colors.white),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Imagem será exibida aqui',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.imageUrl != null
                            ? () => controller.downloadImage(context)
                            : null,
                        icon: const Icon(Icons.download),
                        label: const Text('Baixar'),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.generateImage,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Gerar Nova'),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.imageUrl != null
                            ? () => controller.salvarImagem(
                                context, contentId! ?? '')
                            : null,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar no banco'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../image_generator_page/image_generator_page/image_generator_page.dart';
import 'generated_content_controller.dart';

class GeneratedContentPage extends StatefulWidget {
  final String content;
  final String topic;
  final String url;
  final String platform;
  final bool hasGenerated;
  final String imageGeneratedUrl;

  const GeneratedContentPage({
    super.key,
    required this.content,
    required this.topic,
    required this.url,
    required this.platform,
    required this.hasGenerated,
    required this.imageGeneratedUrl,
  });

  @override
  State<GeneratedContentPage> createState() => _GeneratedContentPageState();
}

class _GeneratedContentPageState extends State<GeneratedContentPage> {
  late GeneratedContentController controller;

  @override
  void initState() {
    super.initState();
    controller = GeneratedContentController(
      content: widget.content,
      topic: widget.topic,
      url: widget.url,
      platform: widget.platform,
      imageGeneratedUrl: widget.imageGeneratedUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdo Gerado'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tópico e plataforma
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.topic, size: 20, color: Colors.blue),
                Text(
                  widget.topic,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.apps, size: 20, color: Colors.green),
                Text(
                  widget.platform,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Conteúdo principal
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.article, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Conteúdo',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    widget.hasGenerated
                        ? TextFormField(
                            controller: controller.contentController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Escreva o conteúdo...',
                            ),
                          )
                        : MarkdownBody(
                            data: controller.mainContent,
                            selectable: true,
                          ),
                  ],
                ),
              ),
            ),

            // Descrição da imagem
            if (controller.imageDescription.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.image, color: Colors.purple),
                          SizedBox(width: 8),
                          Text(
                            'Descrição da Imagem',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      widget.hasGenerated
                          ? TextFormField(
                              controller: controller.imageDescController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Descrição da imagem...',
                              ),
                            )
                          : SelectableText(controller.imageDescription),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageGeneratorPage(
                                  imageDescription: widget.hasGenerated
                                      ? controller.imageDescController.text
                                      : controller.imageDescription,
                                  contentId: widget.topic,
                                ),
                              ));
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Gerar Imagem'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (controller.imageGeneratedUrl.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(thickness: 1.5),
              const SizedBox(height: 16.0),
              Text(
                'Imagem Gerada',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
                  child: controller.imageGeneratedUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            controller.imageGeneratedUrl!,
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
              const Divider(thickness: 1.5),
            ],
            // URL
            if (widget.url.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 1,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'URL de Referência:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        widget.url,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 100), // espaço para o botão fixo
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: controller.isSavingNotifier,
        builder: (context, isSaving, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: controller.isSavedNotifier,
            builder: (context, isSaved, _) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: (isSaving || isSaved)
                      ? null
                      : widget.hasGenerated
                          ? () async {
                              await controller.updateGeneratedContent();
                            }
                          : () async {
                              await controller.saveContentToFirestore();
                            },
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(widget.hasGenerated
                          ? Icons.update
                          : (isSaved ? Icons.check_circle : Icons.save)),
                  label: Text(
                    isSaving
                        ? 'Salvando...'
                        : widget.hasGenerated
                            ? 'Atualizar Conteúdo'
                            : (isSaved ? 'Conteúdo Salvo' : 'Salvar Conteúdo'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.hasGenerated
                        ? Colors.orange
                        : (isSaved ? Colors.green : Colors.blue),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

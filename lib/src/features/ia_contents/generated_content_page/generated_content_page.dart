import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'generated_content_controller.dart';

class GeneratedContentPage extends StatefulWidget {
  final String content;
  final String topic;
  final String url;
  final String platform;
  final bool hasGenerated;

  const GeneratedContentPage({
    super.key,
    required this.content,
    required this.topic,
    required this.url,
    required this.platform,
    required this.hasGenerated,
  });

  @override
  State<GeneratedContentPage> createState() => _GeneratedContentPageState();
}

class _GeneratedContentPageState extends State<GeneratedContentPage> {
  late GeneratedContentController controller;
  final bool _isSaving = false;
  final bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    controller = GeneratedContentController(
      content: widget.content,
      topic: widget.topic,
      url: widget.url,
      platform: widget.platform,
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
                    ],
                  ),
                ),
              ),
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

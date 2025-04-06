import 'package:flutter/material.dart';
import 'generate_content_controller.dart';
import '../generated_content_page/generated_content_page.dart';

class ContentGeneratorPage extends StatefulWidget {
  const ContentGeneratorPage({super.key});

  @override
  State<ContentGeneratorPage> createState() => _ContentGeneratorPageState();
}

class _ContentGeneratorPageState extends State<ContentGeneratorPage> {
  final ContentGeneratorController controller = ContentGeneratorController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de Conteúdo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: controller.fetchThemes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Erro ao carregar temas');
            }

            final temas = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.temaSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Tema',
                    border: OutlineInputBorder(),
                  ),
                  items: temas.map((tema) {
                    return DropdownMenuItem<String>(
                      value: tema['title']?.toString(),
                      child: Text(
                        tema['title']?.toString() ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.temaSelecionado = value;
                      controller.urlSelecionada = temas
                          .firstWhere((t) => t['title'] == value)['url']
                          ?.toString();
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                if (controller.urlSelecionada != null)
                  Text('URL: ${controller.urlSelecionada}',
                      style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: controller.plataformaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Plataforma de Destino',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.plataformas.map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.plataformaSelecionada = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: controller.tamanhoSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Tamanho do Texto',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.tamanhos.map((t) {
                    return DropdownMenuItem(value: t, child: Text(t));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.tamanhoSelecionado = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final topic = controller.temaSelecionado;
                              final url = controller.urlSelecionada;
                              final platform = controller.plataformaSelecionada;

                              if (topic != null &&
                                  url != null &&
                                  platform != null) {
                                setState(() => _isLoading = true);

                                final response =
                                    await controller.generateContent(
                                  topic: topic,
                                  url: url,
                                  platform: platform,
                                );

                                setState(() => _isLoading = false);

                                if (response != null && mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GeneratedContentPage(
                                        hasGenerated: false,
                                        content: response,
                                        topic: topic,
                                        url: url,
                                        platform: platform,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Gerar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder<double>(
                  valueListenable: controller.progressNotifier,
                  builder: (context, progress, child) {
                    if (progress == 0.0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green[700],
                        minHeight: 8,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                const Text('Sugestões de Melhoria'),
                const SizedBox(height: 8.0),
                Card(
                  color: Colors.grey[100],
                  elevation: 2,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '• Adicione mais palavras-chave relacionadas ao tema principal.'),
                        SizedBox(height: 8.0),
                        Text(
                            '• Inclua dados estatísticos para aumentar credibilidade.'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

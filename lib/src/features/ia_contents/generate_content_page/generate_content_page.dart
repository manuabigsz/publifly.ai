import 'package:flutter/material.dart';
import '../../generate_ideia/widgets/result_card.dart';
import 'generate_content_controller.dart';
import '../generated_content_page/generated_content_page.dart';

class ContentGeneratorPage extends StatefulWidget {
  const ContentGeneratorPage({super.key});

  @override
  State<ContentGeneratorPage> createState() => _ContentGeneratorPageState();
}

class _ContentGeneratorPageState extends State<ContentGeneratorPage> {
  final ContentGeneratorController controller = ContentGeneratorController();
  final _formKey = GlobalKey<FormState>();

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

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: controller.modeloSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Modelo de Geração',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                      items: controller.modelos.map((modelo) {
                        return DropdownMenuItem<String>(
                          value: modelo['nome'],
                          child: Text(modelo['nome']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.modeloSelecionado = value;
                        controller.modeloUrlSelecionado = controller.modelos
                            .firstWhere((m) => m['nome'] == value)['url'];
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.temaSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Tema',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
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
                        controller.temaSelecionado = value;
                        controller.urlSelecionada = temas
                            .firstWhere((t) => t['title'] == value)['url']
                            ?.toString();
                      },
                    ),
                    const SizedBox(height: 8.0),
                    if (controller.urlSelecionada != null)
                      ResultSearchContentCard(
                        title: controller.temaSelecionado!,
                        description: 'Sem descrição',
                        source: 'Fonte desconhecida',
                        readTime: 'Data não disponível',
                        imageUrl: '',
                        link: controller.urlSelecionada! ?? '#',
                      ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: controller.plataformaSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Plataforma de Destino',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                      items: controller.plataformas.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (value) {
                        controller.plataformaSelecionada = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: controller.tamanhoSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Tamanho do Texto',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                      items: controller.tamanhos.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (value) {
                        controller.tamanhoSelecionado = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: controller.targetPublic,
                      decoration: const InputDecoration(
                        labelText: 'Público alvo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                      items: controller.publics.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (value) {
                        controller.targetPublic = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: controller.tone,
                      decoration: const InputDecoration(
                        labelText: 'Tom da publicação',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                      items: controller.tones.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (value) {
                        controller.tone = value;
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
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() => _isLoading = true);

                                    final response =
                                        await controller.generateContent(
                                      topic: controller.temaSelecionado!,
                                      url: controller.urlSelecionada!,
                                      platform:
                                          controller.plataformaSelecionada!,
                                      textLenght:
                                          controller.tamanhoSelecionado!,
                                      targetPublic: controller.targetPublic!,
                                      tone: controller.tone!,
                                      urlAgente:
                                          controller.modeloUrlSelecionado!,
                                    );

                                    setState(() => _isLoading = false);

                                    if (response != null && mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GeneratedContentPage(
                                            hasGenerated: false,
                                            content: response,
                                            topic: controller.temaSelecionado!,
                                            url: controller.urlSelecionada!,
                                            platform: controller
                                                .plataformaSelecionada!,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

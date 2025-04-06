import 'package:flutter/material.dart';

class ContentGeneratorPage extends StatelessWidget {
  const ContentGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Conteúdo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Editor de texto
            const Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite ou edite seu conteúdo aqui...',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Nova Versão'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricCard('Relevância', '85%'),
                _buildMetricCard('SEO Score', '92%'),
                _buildMetricCard('Alcance', '78%'),
              ],
            ),
            const SizedBox(height: 16.0),

            const Text(
              'Sugestões de Melhoria',
            ),
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
                      '• Adicione mais palavras-chave relacionadas ao tema principal.',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '• Inclua dados estatísticos para aumentar credibilidade.',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        width: 100,
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(fontSize: 20.0, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

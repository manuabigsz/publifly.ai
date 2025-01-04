import 'package:flutter/material.dart';

class ImageGeneratorPage extends StatelessWidget {
  const ImageGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Imagens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Descrição
            const Text(
              'Descrição da Imagem',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Descreva a imagem que você deseja gerar...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Botão de Gerar Imagem
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Gerar Imagem'),
              ),
            ),
            const SizedBox(height: 16.0),
            // Área de Exibição da Imagem
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50.0, color: Colors.white),
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
            // Botões de Ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Baixar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Gerar Nova'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Histórico de Imagens
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 4, // Número de imagens no histórico
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Imagem ${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ImageGeneratorPage(),
  ));
}

import 'package:flutter/material.dart';

import 'search_content_result.dart';

class NewSearchContentPage extends StatefulWidget {
  const NewSearchContentPage({super.key});

  @override
  State<NewSearchContentPage> createState() => _NewSearchContentPageState();
}

class _NewSearchContentPageState extends State<NewSearchContentPage> {
  final double _progress = 0.75; // Valor de progresso da pesquisa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Nova Pesquisa',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema da Publicação',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Digite o tema para pesquisa...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.mic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Temas Populares',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _popularTopicChip('Marketing Digital'),
                _popularTopicChip('SEO 2025'),
                _popularTopicChip('Redes Sociais'),
                _popularTopicChip('E-commerce'),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Processando pesquisa...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[300],
              color: Colors.black,
              minHeight: 8,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchContentResultPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Iniciar Pesquisa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularTopicChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}

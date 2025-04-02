import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_content_result.dart';

class NewSearchContentPage extends StatefulWidget {
  const NewSearchContentPage({super.key});

  @override
  State<NewSearchContentPage> createState() => _NewSearchContentPageState();
}

class _NewSearchContentPageState extends State<NewSearchContentPage> {
  final TextEditingController _controller = TextEditingController();
  double _progress = 0.0;

  Future<void> _startSearch() async {
    final String query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _progress = 0.3;
    });

    final Uri url =
        Uri.parse('https://publify-serper-u7el.onrender.com/search?q=$query');
    final response = await http.get(url);

    setState(() {
      _progress = 1.0;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      final List results = decodedResponse["news"] ?? [];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchContentResultPage(results: results),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar resultados.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite o tema para pesquisa...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                onPressed: _startSearch,
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
}

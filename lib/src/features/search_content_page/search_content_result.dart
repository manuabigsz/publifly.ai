import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'
    show LaunchMode, canLaunchUrl, launchUrl;

class SearchContentResultPage extends StatefulWidget {
  final List results;

  const SearchContentResultPage({super.key, required this.results});

  @override
  State<SearchContentResultPage> createState() =>
      _SearchContentResultPageState();
}

class _SearchContentResultPageState extends State<SearchContentResultPage> {
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
          'Resultados da Pesquisa',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.filter_list, color: Colors.white),
                label: const Text(
                  'Refinar Pesquisa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.results.length,
                itemBuilder: (context, index) {
                  final result = widget.results[index];
                  return Column(
                    children: [
                      _resultCard(
                        title: result['title'] ?? 'Sem título',
                        description: result['snippet'] ?? 'Sem descrição',
                        source: result['source'] ?? 'Fonte desconhecida',
                        readTime: result['date'] ?? 'Data não disponível',
                        imageUrl: result['imageUrl'] ?? '',
                        link: result['link'] ?? '#',
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard({
    required String title,
    required String description,
    required String source,
    required String readTime,
    required String imageUrl,
    required String link,
  }) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não foi possível abrir o link')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl,
                    height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  source,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  readTime,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

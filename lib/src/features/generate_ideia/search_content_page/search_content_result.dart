import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'
    show LaunchMode, canLaunchUrl, launchUrl;

import '../widgets/result_card.dart';

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
                      ResultSearchContentCard(
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
}

import 'package:flutter/material.dart';

class SearchContentResultPage extends StatefulWidget {
  const SearchContentResultPage({super.key});

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
              child: ListView(
                children: [
                  _resultCard(
                    title: 'Marketing Digital em 2025',
                    description:
                        'Descubra as últimas tendências em marketing digital para 2025. Estratégias avançadas de SEO e análise de dados.',
                    source: 'blog.marketing.com',
                    readTime: '5 min leitura',
                  ),
                  const SizedBox(height: 10),
                  _resultCard(
                    title: 'Guia de SEO Completo',
                    description:
                        'Aprenda técnicas avançadas de otimização para mecanismos de busca. Inclui estudos de caso e exemplos práticos.',
                    source: 'seomaster.com',
                    readTime: '6 min leitura',
                  ),
                  const SizedBox(height: 10),
                  _resultCard(
                    title: 'Análise de Dados para Marketing',
                    description:
                        'Como utilizar dados para melhorar suas estratégias de marketing. Ferramentas e métricas essenciais.',
                    source: 'datamarketing.io',
                    readTime: '6 min leitura',
                  ),
                ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }
}

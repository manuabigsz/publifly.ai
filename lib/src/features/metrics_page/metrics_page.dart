import 'package:flutter/material.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton('Período'),
                _buildFilterButton('Rede Social'),
              ],
            ),
            const SizedBox(height: 16.0),
            // Estatísticas principais
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 2.5,
              ),
              children: [
                _buildMetricCard(Icons.favorite, 'Curtidas', '12.5K'),
                _buildMetricCard(Icons.share, 'Compartilhamentos', '3.2K'),
                _buildMetricCard(Icons.comment, 'Comentários', '824'),
                _buildMetricCard(Icons.insights, 'Alcance', '45.8K'),
              ],
            ),
            const SizedBox(height: 16.0),
            // Gráfico de Engajamento
            _buildSectionTitle('Engajamento'),
            Container(
              height: 200,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Text('Gráfico de Engajamento'),
            ),
            const SizedBox(height: 16.0),
            // Métricas por Plataforma
            _buildSectionTitle('Métricas por Plataforma'),
            _buildPlatformMetricCard(
              platform: 'Instagram',
              growth: '+15.2%',
              likes: '8.3K',
              comments: '521',
            ),
            _buildPlatformMetricCard(
              platform: 'Facebook',
              growth: '+8.7%',
              likes: '4.2K',
              comments: '303',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Ação do botão
      },
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildMetricCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildPlatformMetricCard({
    required String platform,
    required String growth,
    required String likes,
    required String comments,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platform,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Curtidas: $likes',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                'Comentários: $comments',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            growth,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

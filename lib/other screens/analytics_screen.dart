import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constant/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final NumberFormat _currency = NumberFormat.simpleCurrency(locale: 'en_US');
  String _range = '7d';

  final List<int> _sampleData = [5, 8, 6, 12, 9, 14, 11, 16, 13, 18, 15];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryYellow.withOpacity(0.2),
              Colors.white,
              AppColors.primaryYellow.withOpacity(0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRangeChips(cs),
                const SizedBox(height: 16),
                _buildMetricsGrid(cs),
                const SizedBox(height: 16),
                _buildChartCard(cs),
                const SizedBox(height: 16),
                _buildRecentTrips(cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeChips(ColorScheme cs) {
    final ranges = ['7d', '30d', '90d', '1y'];
    return Row(
      children: ranges.map((r) {
        final selected = r == _range;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(r),
            selected: selected,
            onSelected: (_) => setState(() => _range = r),
            selectedColor: AppColors.primaryBlue,
            backgroundColor: AppColors.softWhite,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.darkNavy,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricsGrid(ColorScheme cs) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _metricCard(
          title: 'Total Rides',
          value: '1,254',
          icon: Icons.directions_car_rounded,
          color: AppColors.primaryBlue,
        ),
        _metricCard(
          title: 'Earnings',
          value: _currency.format(8423.50),
          icon: Icons.attach_money_rounded,
          color: AppColors.primaryYellow,
        ),
        _metricCard(
          title: 'Active Drivers',
          value: '48',
          icon: Icons.people_alt_rounded,
          color: AppColors.primaryBlue,
        ),
        _metricCard(
          title: 'Incidents',
          value: '3',
          icon: Icons.report_problem_rounded,
          color: AppColors.primaryYellow,
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.18),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rides Over Time', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _SparklinePainter(
                data: _sampleData,
                lineColor: AppColors.primaryBlue,
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Peak: ${_sampleData.reduce((a, b) => a > b ? a : b)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Avg: ${(_sampleData.reduce((a, b) => a + b) / _sampleData.length).toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrips(ColorScheme cs) {
    final trips = List.generate(
      5,
      (i) => {
        'from': 'Point ${i + 1}',
        'to': 'Point ${i + 2}',
        'fare': _currency.format(12.5 + i * 3),
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Trips',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...trips.map(
          (t) => Card(
            elevation: 0,
            color: AppColors.softWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              dense: true,
              title: Text('${t['from']} → ${t['to']}'),
              trailing: Text(t['fare'] as String),
              leading: const Icon(
                Icons.place_outlined,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<int> data;
  final Color lineColor;

  _SparklinePainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final double max = data.reduce((a, b) => a > b ? a : b).toDouble();
    final double min = data.reduce((a, b) => a < b ? a : b).toDouble();
    final span = max - min == 0 ? 1 : max - min;

    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final dx = (i / (data.length - 1)) * size.width;
      final normalized = (data[i] - min) / span;
      final dy = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [lineColor.withOpacity(0.16), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/constant/app_colors.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> _getTripStream() {
    return supabase
        .from('trips')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Spending Trends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.darkNavy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getTripStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final userId = supabase.auth.currentUser?.id;
          final completedTrips = snapshot.data!.where((trip) {
            final isMine = trip['passenger_id'] == userId;
            final isDone = trip['status'] == 'completed';
            return isMine && isDone;
          }).toList();

          final stats = _processTripData(completedTrips);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLineGraph(stats['weeklyData']),
              const SizedBox(height: 20),
              _buildSummaryCards(
                today: stats['today'],
                yesterday: stats['yesterday'],
                monday: stats['monday'],
              ),
              const SizedBox(height: 24),
              const Text(
                "Trip History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 12),
              ...completedTrips.take(10).map((trip) => _tripTile(trip)),
            ],
          );
        },
      ),
    );
  }

  Map<String, dynamic> _processTripData(List<Map<String, dynamic>> trips) {
    final now = DateTime.now();
    double today = 0, yesterday = 0, mondayTotal = 0;
    List<double> weekly = List.filled(7, 0.0);

    for (var trip in trips) {
      final dateStr = trip['created_at'];
      if (dateStr == null) continue;
      final date = DateTime.parse(dateStr);
      final fare = (trip['calculated_fare'] as num?)?.toDouble() ?? 0.0;

      if (DateUtils.isSameDay(date, now)) today += fare;
      if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1))))
        yesterday += fare;

      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final tripDate = DateTime(date.year, date.month, date.day);
      final mondayDate = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      );

      if (tripDate.isAtSameMomentAs(mondayDate) ||
          tripDate.isAfter(mondayDate)) {
        if (date.weekday == 1) mondayTotal += fare;
        if (date.weekday <= 7) weekly[date.weekday - 1] += fare;
      }
    }
    return {
      'today': today,
      'yesterday': yesterday,
      'monday': mondayTotal,
      'weeklyData': weekly,
    };
  }

  Widget _buildLineGraph(List<double> weeklyData) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Expense Flow",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: LineGraphPainter(weeklyData),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards({
    required double today,
    required double yesterday,
    required double monday,
  }) {
    return Row(
      children: [
        _summaryItem("Today", today, Colors.blueAccent),
        const SizedBox(width: 8),
        _summaryItem("Yesterday", yesterday, Colors.orangeAccent),
        const SizedBox(width: 8),
        _summaryItem("Monday", monday, Colors.greenAccent),
      ],
    );
  }

  Widget _summaryItem(String label, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              "₱${amount.toStringAsFixed(0)}",
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripTile(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${trip['pickup']} to ${trip['drop_off']}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "₱${trip['calculated_fare']}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class LineGraphPainter extends CustomPainter {
  final List<double> data;
  LineGraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blueAccent.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    double maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    final path = Path();
    final fillPath = Path();

    double dx = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double dy = size.height - (data[i] / maxVal * size.height);
      if (i == 0) {
        path.moveTo(0, dy);
        fillPath.moveTo(0, size.height);
        fillPath.lineTo(0, dy);
      } else {
        path.lineTo(i * dx, dy);
        fillPath.lineTo(i * dx, dy);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = Colors.white;
    for (int i = 0; i < data.length; i++) {
      double dy = size.height - (data[i] / maxVal * size.height);
      canvas.drawCircle(Offset(i * dx, dy), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

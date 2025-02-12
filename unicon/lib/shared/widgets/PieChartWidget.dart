import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final int present;
  final int absent;
  final int total;

  const PieChartWidget({
    Key? key,
    required this.present,
    required this.absent,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double attendancePercentage = (total > 0) ? (present / total) * 100 : 0;

    return Column(
      children: [
        // **Pie Chart UI with Centered Attendance %**
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: getSections(),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            // **Centered Percentage**
            Column(
              children: [
                Text(
                  "${attendancePercentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Attendance",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // **Legend Section (Simple & Horizontal)**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(Colors.green, "Present", present),
            _buildLegendItem(Colors.red, "Absent", absent),
            _buildLegendItem(Colors.blue, "Total", total),
          ],
        ),
      ],
    );
  }

  // **Pie Chart Data**
  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        color: Colors.green.shade400,
        value: present.toDouble(),
        title: '',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.red.shade400,
        value: absent.toDouble(),
        title: '',
        radius: 50,
      ),
    ];
  }

  // **Legend Widget (Simple & Horizontal)**
  Widget _buildLegendItem(Color color, String label, int value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: $value",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

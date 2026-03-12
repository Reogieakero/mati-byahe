import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/app_colors.dart';
import 'widgets/report_detail_row.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final DateTime date =
        DateTime.tryParse(report['reported_at'] ?? '') ?? DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(date),
              const SizedBox(height: 24),
              const _SectionLabel(label: "Trip Logistics"),
              const SizedBox(height: 8),
              _buildTripCard(),
              const SizedBox(height: 24),
              const _SectionLabel(label: "Personnel & Reference"),
              const SizedBox(height: 8),
              _buildShadcnCard(
                child: Column(
                  children: [
                    ReportDetailRow(
                      icon: Icons.person_outline_rounded,
                      label: "Driver Name",
                      value: report['driver_name'] ?? "Unknown Driver",
                    ),
                    _buildDivider(),
                    ReportDetailRow(
                      icon: Icons.badge_outlined,
                      label: "Vehicle Plate",
                      value: report['plate_number'] ?? "N/A",
                    ),
                    _buildDivider(),
                    ReportDetailRow(
                      icon: Icons.confirmation_number_outlined,
                      label: "Trip ID",
                      value:
                          report['trip_uuid']
                              ?.toString()
                              .substring(0, 8)
                              .toUpperCase() ??
                          "N/A",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionLabel(label: "Issue Details"),
              const SizedBox(height: 8),
              _buildShadcnCard(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (report['issue_type'] ?? "General")
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report['description'] ?? "No details provided.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (report['evidence_url'] != null) ...[
                const SizedBox(height: 24),
                const _SectionLabel(label: "Evidence Attached"),
                const SizedBox(height: 8),
                _buildEvidenceView(report['evidence_url']),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24.5,
            top: 36,
            bottom: 36,
            child: Container(width: 1.5, color: Colors.grey.shade200),
          ),
          Column(
            children: [
              _buildLocationRow(
                Icons.radio_button_checked,
                "PICKUP LOCATION",
                report['pickup'] ?? "N/A",
                AppColors.primaryYellow,
              ),
              _buildLocationRow(
                Icons.location_on,
                "DROP-OFF LOCATION",
                report['drop_off'] ?? "---",
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    IconData icon,
    String label,
    String val,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  val,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Report Summary",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkNavy,
              ),
            ),
            _buildStatusChip(report['status'] ?? 'pending'),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Logged on ${DateFormat('MMMM dd, yyyy').format(date)}",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final bool isResolved = status.toLowerCase() == 'resolved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isResolved ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isResolved ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isResolved ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
  }

  Widget _buildShadcnCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }

  Widget _buildEvidenceView(String path) {
    final bool isLocal = !path.startsWith('http');
    return _buildShadcnCard(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isLocal
                ? FileImage(File(path))
                : NetworkImage(path) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.darkNavy, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "CASE-${report['id'] ?? '000'}",
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade100);
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Colors.grey.shade500,
      ),
    );
  }
}

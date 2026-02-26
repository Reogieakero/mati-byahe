import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/app_colors.dart';

class ReportHistoryTile extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback? onDelete;
  final VoidCallback? onViewDetails;

  final GlobalKey<PopupMenuButtonState<String>> menuKey = GlobalKey();

  ReportHistoryTile({
    super.key,
    required this.report,
    this.onDelete,
    this.onViewDetails,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd • hh:mm a').format(date);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onViewDetails,
      onLongPress: () => menuKey.currentState?.showButtonMenu(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(color: AppColors.softWhite, width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.report_problem_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (report['issue_type']?.toString() ?? "REPORT")
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    report['description'] ?? "No details provided.",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkNavy.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(report['reported_at']),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textGrey.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ), // Matches fare text height in HistoryTile
                Theme(
                  data: Theme.of(context).copyWith(
                    useMaterial3: true,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: PopupMenuButton<String>(
                    key: menuKey,
                    padding: EdgeInsets.zero,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    icon: const Icon(
                      Icons.more_horiz, // Changed to match HistoryTile
                      color: AppColors.textGrey,
                      size: 20,
                    ),
                    onSelected: (value) {
                      if (value == 'view') onViewDetails?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      _buildMenuItem(
                        value: 'view',
                        icon: Icons.visibility_outlined,
                        label: 'VIEW DETAILS',
                        color: AppColors.darkNavy,
                      ),
                      _buildMenuItem(
                        value: 'delete',
                        icon: Icons.delete_outline_rounded,
                        label: 'DELETE',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem(
      value: value,
      height: 38,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

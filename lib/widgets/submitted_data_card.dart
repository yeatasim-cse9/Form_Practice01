import 'package:flutter/material.dart';
import '../models/student_model.dart';

class SubmittedDataCard extends StatelessWidget {
  final StudentModel student;

  const SubmittedDataCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_pin, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Submitted Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✓ Success',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Card Body ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Name',
                  value: student.name,
                ),
                _buildDivider(),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        icon: Icons.format_list_numbered,
                        label: 'Roll',
                        value: student.roll,
                        compact: true,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white24,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _buildInfoRow(
                        icon: Icons.app_registration,
                        label: 'Reg. No.',
                        value: student.registrationNumber,
                        compact: true,
                      ),
                    ),
                  ],
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Group',
                  value: student.bloodGroup,
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.wc_outlined,
                  label: 'Gender',
                  value: student.gender,
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: student.phoneNumber,
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.info_outline,
                  label: 'About Me',
                  value: student.aboutMe,
                  isMultiLine: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool compact = false,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: isMultiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: compact ? 16 : 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: compact ? 10 : 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 13 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.15),
      height: 16,
      thickness: 1,
    );
  }
}

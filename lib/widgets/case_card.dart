import 'package:flutter/material.dart';

import '../models/profiler_case.dart';
import '../theme/app_colors.dart';

/// Card que muestra un caso con su título, descripción y botón accionable.
class CaseCard extends StatelessWidget {
  final ProfilerCase profilerCase;
  final VoidCallback? onTap;

  const CaseCard({super.key, required this.profilerCase, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profilerCase.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  profilerCase.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _ActionButton(onTap: onTap),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ActionButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

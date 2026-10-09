import 'package:flutter/material.dart';

import '../models/profiler_case.dart';
import '../theme/app_colors.dart';

/// Card que muestra un caso con su número, título, descripción y botón accionable.
class CaseCard extends StatelessWidget {
  final int index;
  final ProfilerCase profilerCase;
  final VoidCallback? onTap;

  const CaseCard({
    super.key,
    required this.index,
    required this.profilerCase,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              _CaseNumber(number: index + 1),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profilerCase.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profilerCase.description,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const _ActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Número del caso dentro de un contenedor con el morado suave de la marca.
class _CaseNumber extends StatelessWidget {
  final int number;

  const _CaseNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Botón circular con flecha que indica que la card es accionable.
class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: AppColors.white,
        size: 20,
      ),
    );
  }
}

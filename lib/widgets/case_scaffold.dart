import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'brand_logo.dart';
import 'path_switch.dart';

/// Scaffold común a todas las pantallas de caso, con identidad Pragma:
/// header con gradiente morado, isotipo como marca de agua, número de caso,
/// título, descripción, switch de camino y píldora de estado.
class CaseScaffold extends StatelessWidget {
  final int caseNumber;
  final String title;
  final String description;
  final bool problematico;
  final ValueChanged<bool> onPathChanged;
  final Widget child;

  const CaseScaffold({
    super.key,
    required this.caseNumber,
    required this.title,
    required this.description,
    required this.problematico,
    required this.onPathChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _CaseHeader(
            caseNumber: caseNumber,
            title: title,
            description: description,
            problematico: problematico,
            onPathChanged: onPathChanged,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CaseHeader extends StatelessWidget {
  final int caseNumber;
  final String title;
  final String description;
  final bool problematico;
  final ValueChanged<bool> onPathChanged;

  const _CaseHeader({
    required this.caseNumber,
    required this.title,
    required this.description,
    required this.problematico,
    required this.onPathChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Stack(
          children: [
            // Isotipo grande como marca de agua, recortado por el header.
            Positioned(
              right: -40,
              bottom: -50,
              child: Opacity(
                opacity: 0.12,
                child: BrandLogo(size: 190, onDark: true),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: volver, número de caso y switch de camino.
                    Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 12),
                        _CaseBadge(number: caseNumber),
                        const Spacer(),
                        PathSwitch(
                          problematico: problematico,
                          onChanged: onPathChanged,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StatusPill(problematico: problematico),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Insignia circular con el número del caso.
class _CaseBadge extends StatelessWidget {
  final int number;

  const _CaseBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Caso $number',
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Botón circular translúcido para acciones del header (volver).
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
      ),
    );
  }
}

/// Píldora que refleja el camino activo: problemático u optimizado.
class _StatusPill extends StatelessWidget {
  final bool problematico;

  const _StatusPill({required this.problematico});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            problematico ? Icons.warning_amber_rounded : Icons.check_circle,
            size: 16,
            color: problematico ? const Color(0xFFE2A400) : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            problematico ? 'Camino con problema' : 'Camino optimizado',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

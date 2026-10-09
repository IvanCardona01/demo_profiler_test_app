import 'package:flutter/material.dart';

import '../models/profiler_case.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_logo.dart';
import '../widgets/case_card.dart';
import 'case_one_screen.dart';
import 'case_two_screen.dart';
import 'case_three_screen.dart';
import 'case_four_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              itemCount: profilerCases.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return CaseCard(
                  index: index,
                  profilerCase: profilerCases[index],
                  onTap: _navegateRegardingCase(context, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _navegateRegardingCase(BuildContext context, int index) {
    final pantallas = <int, WidgetBuilder>{
      0: (_) => const CaseOneScreen(),
      1: (_) => const CaseTwoScreen(),
      2: (_) => const CaseThreeScreen(),
      3: (_) => const CaseFourScreen(),
    };
    final builder = pantallas[index];
    if (builder == null) return null;
    return () => Navigator.of(context).push(
          MaterialPageRoute(builder: builder),
        );
  }
}

/// Encabezado con gradiente morado, isotipo de marca y título de la demo.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const BrandLogo(size: 32),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Pragma',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Flutter Profiler',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Casos prácticos para analizar y corregir rendimiento',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

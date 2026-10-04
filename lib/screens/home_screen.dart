import 'package:flutter/material.dart';

import '../models/profiler_case.dart';
import '../theme/app_colors.dart';
import '../widgets/case_card.dart';
import 'case_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Flutter Profiler',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Casos prácticos para analizar y corregir rendimiento',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.black.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 28),
              // Expanded(
              //   child: ListView.separated(
              //     itemCount: profilerCases.length,
              //     separatorBuilder: (_, _) => const SizedBox(height: 16),
              //     itemBuilder: (context, index) {
              //       return CaseCard(
              //         profilerCase: profilerCases[index],
              //         // Solo el Caso 1 tiene navegación por ahora.
              //         onTap: index == 0
              //             ? () => Navigator.of(context).push(
              //                   MaterialPageRoute(
              //                     builder: (_) => const CaseOneScreen(),
              //                   ),
              //                 )
              //             : null,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

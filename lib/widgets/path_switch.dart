import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Switch para alternar en vivo entre el camino problemático y el optimizado.
/// Se coloca en el AppBar de cada caso.
class PathSwitch extends StatelessWidget {
  final bool problematico;
  final ValueChanged<bool> onChanged;

  const PathSwitch({
    super.key,
    required this.problematico,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          problematico ? 'Malo' : 'Bueno',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: problematico,
          onChanged: onChanged,
          activeThumbColor: AppColors.white,
          activeTrackColor: AppColors.black.withValues(alpha: 0.3),
          inactiveThumbColor: AppColors.white,
          inactiveTrackColor: AppColors.black.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

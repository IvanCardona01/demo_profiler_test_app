import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// Isotipo de Pragma usado como identidad visual de la app.
class BrandLogo extends StatelessWidget {
  final double size;

  /// Si true, pinta el isotipo en blanco (para fondos oscuros).
  final bool onDark;

  const BrandLogo({super.key, this.size = 40, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/isotipo_morado_principal.svg',
      width: size,
      height: size,
      colorFilter: onDark
          ? const ColorFilter.mode(AppColors.white, BlendMode.srcIn)
          : null,
    );
  }
}

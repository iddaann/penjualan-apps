import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SelloraBackground extends StatelessWidget {
  const SelloraBackground({super.key, required this.child, this.blur = 70});

  final Widget child;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.background),
        Positioned(
          top: -120,
          right: -80,
          child: _AmbientOrb(
            color: AppColors.ambientBlue,
            size: 320,
            blur: blur,
          ),
        ),
        Positioned(
          top: 180,
          left: -150,
          child: _AmbientOrb(
            color: AppColors.ambientPurple,
            size: 300,
            blur: blur,
          ),
        ),
        Positioned(
          bottom: -160,
          right: 80,
          child: _AmbientOrb(
            color: AppColors.ambientCyan,
            size: 360,
            blur: blur,
          ),
        ),
        child,
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({
    required this.color,
    required this.size,
    required this.blur,
  });

  final Color color;
  final double size;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

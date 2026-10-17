// Widgets decorativos reutilizables:
//  - GradientHeader: encabezado con degradado y borde curvo
//  - FadeSlideIn: animación de entrada (aparece y sube)
//  - SectionCard: tarjeta blanca con título
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// (No visto en clase) CustomClipper recorta un widget con la
/// forma que queramos. Aquí dibujamos una curva en la parte inferior.
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 40)
      ..quadraticBezierTo(size.width / 2, size.height + 10, size.width, size.height - 40)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Encabezado con degradado, círculos decorativos y borde curvo
class GradientHeader extends StatelessWidget {
  final double height;
  final Widget child;

  const GradientHeader({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: Stack(
          children: [
            // Círculos translúcidos de fondo
            Positioned(top: -70, right: -50, child: _circulo(200, 0.10)),
            Positioned(top: 60, left: -60, child: _circulo(150, 0.07)),
            Positioned(bottom: -20, right: 70, child: _circulo(90, 0.08)),
            Positioned.fill(child: child),
          ],
        ),
      ),
    );
  }

  Widget _circulo(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
}

/// (No visto en clase) TweenAnimationBuilder anima un valor de
/// 0 a 1 sin necesidad de AnimationController ni StatefulWidget.
/// Usamos `delay` (en ms) para que los elementos aparezcan en cascada.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const FadeSlideIn({super.key, required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 28 * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}

/// Tarjeta blanca con ícono + título, para agrupar campos
class SectionCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget child;

  const SectionCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

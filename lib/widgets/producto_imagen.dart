// Widget reutilizable: foto del producto desde internet
// - Muestra un indicador mientras carga
// - Si falla (sin internet o URL mala) muestra el ícono de respaldo
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProductoImagen extends StatelessWidget {
  final String? url;
  final IconData iconoRespaldo;
  final String categoria;
  final double size;
  final double radius;

  const ProductoImagen({
    super.key,
    required this.url,
    required this.iconoRespaldo,
    required this.categoria,
    this.size = 80,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    // Sin URL -> directamente el ícono con degradado
    if (url == null || url!.isEmpty) return _respaldo();

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.08),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(radius),
      ),
      // (No visto en clase) Image.network carga la foto desde una URL.
      //  - loadingBuilder: qué mostrar mientras descarga
      //  - errorBuilder: qué mostrar si la descarga falla
      child: Image.network(
        url!,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progreso) {
          if (progreso == null) return child; // ya terminó de cargar
          final total = progreso.expectedTotalBytes;
          return Center(
            child: SizedBox(
              width: size * 0.3,
              height: size * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
                value: total != null ? progreso.cumulativeBytesLoaded / total : null,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => _respaldo(conFondo: false),
      ),
    );
  }

  /// Ícono blanco sobre degradado (cuando no hay foto)
  Widget _respaldo({bool conFondo = true}) {
    final degradado = AppColors.gradientFor(categoria);
    return Container(
      width: conFondo ? size : null,
      height: conFondo ? size : null,
      decoration: BoxDecoration(
        gradient: degradado,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Icon(iconoRespaldo, size: size * 0.48, color: Colors.white),
      ),
    );
  }
}

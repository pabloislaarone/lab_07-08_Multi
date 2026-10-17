// Tema global: colores, degradados, sombras y estilos
import 'package:flutter/material.dart';

class AppColors {
  // Paleta principal (índigo + violeta + cian)
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF312E81);
  static const Color violet = Color(0xFF7C3AED);
  static const Color cyan = Color(0xFF06B6D4);

  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Colors.white;
  static const Color inputFill = Color(0xFFF1F4F9);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color danger = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  /// Degradado de los encabezados
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryDark, primary, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Degradado de los botones principales
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primary, violet],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Degradados para las categorías de productos y accesos del menú
  static const List<List<Color>> _paletas = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)], // índigo
    [Color(0xFF06B6D4), Color(0xFF3B82F6)], // cian -> azul
    [Color(0xFFF59E0B), Color(0xFFF97316)], // ámbar
    [Color(0xFF10B981), Color(0xFF059669)], // verde
    [Color(0xFFEC4899), Color(0xFF8B5CF6)], // rosa -> violeta
    [Color(0xFF0EA5E9), Color(0xFF6366F1)], // celeste -> índigo
  ];

  /// Devuelve siempre el mismo degradado para el mismo texto (categoría)
  static LinearGradient gradientFor(String clave) {
    final colores = _paletas[clave.hashCode.abs() % _paletas.length];
    return LinearGradient(
      colors: colores,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient gradientIndex(int i) => LinearGradient(
        colors: _paletas[i % _paletas.length],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Sombra suave usada en tarjetas
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF1E1B4B).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];
}

class AppTheme {
  static ThemeData get light {
    // (No visto en clase) ColorScheme.fromSeed genera una paleta
    // completa (Material 3) a partir de un solo color.
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
    );

    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      // Estilo de TODOS los campos de texto en un solo lugar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: borde,
        enabledBorder: borde,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

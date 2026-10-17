// TechStore App - Laboratorio Flutter (Sección B)
// Punto de entrada de la aplicación.
import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // La app arranca en el Login
      initialRoute: AppRoutes.login,
      // (No visto en clase) onGenerateRoute centraliza TODA la
      // navegación en un solo lugar y permite animaciones personalizadas
      // y pasar argumentos entre pantallas de forma ordenada.
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

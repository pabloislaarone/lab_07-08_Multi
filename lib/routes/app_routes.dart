// Rutas de la aplicación (navegación centralizada)
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../screens/listar_productos_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/registrar_producto_screen.dart';

class AppRoutes {
  // Nombres de las rutas: así evitamos escribir textos "a mano" en cada pantalla
  static const String login = '/';
  static const String menu = '/menu';
  static const String listarProductos = '/productos';
  static const String registrarProducto = '/productos/registrar';
  static const String perfil = '/perfil';

  /// Devuelve la pantalla que corresponde a cada nombre de ruta.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _fade(const LoginScreen(), settings);
      case menu:
        return _slide(const MenuScreen(), settings);
      case listarProductos:
        return _slide(const ListarProductosScreen(), settings);
      case registrarProducto:
        // (No visto en clase) la misma pantalla sirve para
        // REGISTRAR o EDITAR. Si llega un Producto como argumento,
        // se abre en modo edición.
        final producto = settings.arguments as Producto?;
        return _slide(RegistrarProductoScreen(productoEditar: producto), settings);
      case perfil:
        return _slide(const PerfilScreen(), settings);
      default:
        return _fade(
          const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
          settings,
        );
    }
  }

  // (No visto en clase) PageRouteBuilder permite definir
  // nuestras propias transiciones entre pantallas.

  /// Transición deslizando desde la derecha (para avanzar en el flujo).
  static PageRouteBuilder _slide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Transición con desvanecimiento (para login / logout).
  static PageRouteBuilder _fade(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}

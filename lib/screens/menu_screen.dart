// PANTALLA 2: MENÚ PRINCIPAL
// Encabezado con saludo, estadísticas y accesos a cada pantalla.
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/decorations.dart';
import '../widgets/menu_option_tile.dart';
import '../widgets/producto_imagen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  /// Pide confirmación antes de cerrar sesión
  static Future<void> logout(BuildContext context) async {
    // (No visto en clase) showDialog devuelve un valor (true/false)
    // según el botón que el usuario presione.
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 32),
        ),
        title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          '¿Seguro que deseas salir de la aplicación?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, salir'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      // (No visto en clase) pushNamedAndRemoveUntil borra TODO el
      // historial de navegación y deja solo el Login.
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  /// Fecha en español sin librerías: "Sábado, 17 de octubre"
  String _fechaHoy() {
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    final h = DateTime.now();
    return '${dias[h.weekday - 1]}, ${h.day} de ${meses[h.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _MenuDrawer(onLogout: () => logout(context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Encabezado + estadísticas superpuestas
            Stack(
              children: [
                GradientHeader(
                  height: 270,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Builder: da un context DENTRO del Scaffold
                              // para poder abrir el Drawer
                              Builder(
                                builder: (ctx) => IconButton(
                                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                                ),
                              ),
                              const Text(
                                'Menú',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              ValueListenableBuilder<Usuario>(
                                valueListenable: AppData.usuario,
                                builder: (_, u, __) => GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      u.iniciales,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ValueListenableBuilder<Usuario>(
                              valueListenable: AppData.usuario,
                              builder: (_, u, __) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _fechaHoy(),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.75),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hola, ${u.nombre.split(' ').first} 👋',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Estadísticas que "flotan" sobre el borde del encabezado
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 200, 20, 0),
                  child: FadeSlideIn(
                    child: ValueListenableBuilder<List<Producto>>(
                      valueListenable: AppData.productos,
                      builder: (_, lista, __) => Row(
                        children: [
                          _StatCard(
                            icono: Icons.inventory_2_rounded,
                            valor: '${lista.length}',
                            etiqueta: 'Productos',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icono: Icons.layers_rounded,
                            valor: '${AppData.totalUnidades}',
                            etiqueta: 'Unidades',
                            color: AppColors.cyan,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icono: Icons.payments_rounded,
                            valor: _compacto(AppData.valorInventario),
                            etiqueta: 'Inventario',
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Accesos rápidos en cuadrícula
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accesos rápidos',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // (No visto en clase) GridView dentro de un scroll
                  // necesita shrinkWrap y NeverScrollableScrollPhysics.
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      FadeSlideIn(
                        delay: 100,
                        child: MenuOptionTile(
                          icon: Icons.add_shopping_cart_rounded,
                          title: 'Registrar\nProductos',
                          subtitle: 'Nuevo producto',
                          gradient: AppColors.gradientIndex(0),
                          onTap: () => Navigator.pushNamed(context, AppRoutes.registrarProducto),
                        ),
                      ),
                      FadeSlideIn(
                        delay: 200,
                        child: MenuOptionTile(
                          icon: Icons.view_list_rounded,
                          title: 'Listar\nProductos',
                          subtitle: 'Ver y editar',
                          gradient: AppColors.gradientIndex(1),
                          onTap: () => Navigator.pushNamed(context, AppRoutes.listarProductos),
                        ),
                      ),
                      FadeSlideIn(
                        delay: 300,
                        child: MenuOptionTile(
                          icon: Icons.person_rounded,
                          title: 'Mi\nPerfil',
                          subtitle: 'Datos de cuenta',
                          gradient: AppColors.gradientIndex(3),
                          onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
                        ),
                      ),
                      FadeSlideIn(
                        delay: 400,
                        child: MenuOptionTile(
                          icon: Icons.logout_rounded,
                          title: 'Cerrar\nSesión',
                          subtitle: 'Logout',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () => logout(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Productos destacados (carrusel)
                  Row(
                    children: [
                      const Text(
                        'Destacados',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.listarProductos),
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 228,
                    child: ValueListenableBuilder<List<Producto>>(
                      valueListenable: AppData.productos,
                      builder: (_, lista, __) {
                        // Los 6 productos de mayor precio
                        final top = [...lista]..sort((a, b) => b.precio.compareTo(a.precio));
                        final destacados = top.take(6).toList();
                        // (No visto en clase) ListView horizontal
                        // (scrollDirection) para hacer un carrusel.
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: destacados.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (_, i) => _DestacadoCard(
                            producto: destacados[i],
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.listarProductos),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 45600 -> "S/ 45.6k"
  static String _compacto(double v) {
    if (v >= 1000000) return 'S/ ${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return 'S/ ${(v / 1000).toStringAsFixed(1)}k';
    return 'S/ ${v.toStringAsFixed(0)}';
  }
}

/// Tarjeta del carrusel de destacados
class _DestacadoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  const _DestacadoCard({required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductoImagen(
              url: producto.imagenUrl,
              iconoRespaldo: producto.icono,
              categoria: producto.categoria,
              size: 132,
              radius: 16,
            ),
            const SizedBox(height: 10),
            Text(
              producto.marca,
              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
            ),
            Text(
              producto.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 2),
            Text(
              producto.precioFormateado,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta pequeña de estadística
class _StatCard extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color color;

  const _StatCard({
    required this.icono,
    required this.valor,
    required this.etiqueta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            // (No visto en clase) FittedBox reduce el texto si no
            // entra en el ancho disponible (evita overflow en pantallas chicas)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              etiqueta,
              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menú lateral (se abre con el ícono ☰)
class _MenuDrawer extends StatelessWidget {
  // Recibimos el logout desde el Menú para usar SU context (el del
  // drawer deja de existir al cerrarse).
  final VoidCallback onLogout;
  const _MenuDrawer({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    void ir(String ruta) {
      Navigator.pop(context); // cierra el drawer
      Navigator.pushNamed(context, ruta);
    }

    final u = AppData.usuario.value;

    Widget item(IconData icono, String texto, VoidCallback onTap, {Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: Icon(icono, color: color ?? AppColors.primary),
          title: Text(
            texto,
            style: TextStyle(fontWeight: FontWeight.w600, color: color ?? AppColors.textDark),
          ),
          onTap: onTap,
        ),
      );
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(u.iniciales,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ),
                const SizedBox(height: 14),
                Text(u.nombre,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                Text(u.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          item(Icons.add_shopping_cart_rounded, 'Registrar Productos',
              () => ir(AppRoutes.registrarProducto)),
          item(Icons.view_list_rounded, 'Listar Productos', () => ir(AppRoutes.listarProductos)),
          item(Icons.person_rounded, 'Perfil', () => ir(AppRoutes.perfil)),
          const Spacer(),
          const Divider(indent: 24, endIndent: 24),
          item(Icons.logout_rounded, 'Logout', () {
            Navigator.pop(context);
            onLogout();
          }, color: AppColors.danger),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

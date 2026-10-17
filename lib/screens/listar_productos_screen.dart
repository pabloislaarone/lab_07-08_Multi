// PANTALLA 3: LISTAR PRODUCTOS
// Buscador, filtro por categoría, editar, eliminar (con deshacer)
// y botón "+" para registrar.
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/decorations.dart';
import '../widgets/producto_card.dart';
import '../widgets/producto_imagen.dart';

class ListarProductosScreen extends StatefulWidget {
  const ListarProductosScreen({super.key});

  @override
  State<ListarProductosScreen> createState() => _ListarProductosScreenState();
}

class _ListarProductosScreenState extends State<ListarProductosScreen> {
  final _buscarCtrl = TextEditingController();
  String _filtro = '';
  String _categoria = 'Todos';

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  void _irARegistrar([Producto? producto]) {
    // Si se manda un producto, la pantalla se abre en modo EDITAR
    Navigator.pushNamed(context, AppRoutes.registrarProducto, arguments: producto);
  }

  void _eliminar(Producto p) {
    AppData.eliminarProducto(p.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${p.nombre}" eliminado'),
          // (No visto en clase) SnackBarAction permite DESHACER
          action: SnackBarAction(
            label: 'DESHACER',
            textColor: const Color(0xFFA5B4FC),
            onPressed: () => AppData.agregarProducto(p),
          ),
        ),
      );
  }

  void _verDetalle(Producto p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            Hero(
              tag: 'producto-${p.id}',
              child: ProductoImagen(
                url: p.imagenUrl,
                iconoRespaldo: p.icono,
                categoria: p.categoria,
                size: 170,
                radius: 32,
              ),
            ),
            const SizedBox(height: 18),
            if (p.marca.isNotEmpty)
              Text(p.marca.toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 12)),
            Text(p.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              p.descripcion.isEmpty ? 'Sin descripción' : p.descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textLight, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _Dato(icono: Icons.sell_rounded, titulo: 'Precio', valor: p.precioFormateado),
                const SizedBox(width: 12),
                _Dato(icono: Icons.inventory_rounded, titulo: 'Stock', valor: '${p.stock} und.'),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Editar producto',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onPressed: () {
                  Navigator.pop(ctx);
                  _irARegistrar(p);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // (No visto en clase) ValueListenableBuilder redibuja la
      // pantalla sola cuando se agrega/edita/elimina un producto.
      body: ValueListenableBuilder<List<Producto>>(
        valueListenable: AppData.productos,
        builder: (_, productos, __) {
          // Categorías existentes para los chips de filtro
          final categorias = ['Todos', ...{for (final p in productos) p.categoria}];
          if (!categorias.contains(_categoria)) _categoria = 'Todos';

          final lista = productos.where((p) {
            final coincideTexto = p.nombre.toLowerCase().contains(_filtro) ||
                p.marca.toLowerCase().contains(_filtro);
            final coincideCat = _categoria == 'Todos' || p.categoria == _categoria;
            return coincideTexto && coincideCat;
          }).toList();

          // (No visto en clase) CustomScrollView + Slivers permite
          // un AppBar que se encoge al hacer scroll (SliverAppBar).
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 190,
                backgroundColor: AppColors.primary,
                title: const Text('Productos'),
                actions: [
                  IconButton(
                    tooltip: 'Registrar producto',
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
                    onPressed: _irARegistrar,
                  ),
                  const SizedBox(width: 4),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(gradient: AppColors.headerGradient),
                    alignment: Alignment.topLeft,
                    // Debajo del título: alto de barra de estado + toolbar
                    padding: EdgeInsets.fromLTRB(
                        24, MediaQuery.of(context).padding.top + 58, 24, 0),
                    child: Text(
                      '${productos.length} productos · ${AppData.totalUnidades} unidades',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // Buscador fijo debajo del título
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(72),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: TextField(
                      controller: _buscarCtrl,
                      onChanged: (v) => setState(() => _filtro = v.toLowerCase()),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Buscar producto o marca...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        suffixIcon: _filtro.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _buscarCtrl.clear();
                                  setState(() => _filtro = '');
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              // Chips de categoría
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 62,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    itemCount: categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = categorias[i];
                      final activo = cat == _categoria;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: activo,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _categoria = cat),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: activo ? AppColors.primary : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        labelStyle: TextStyle(
                          color: activo ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Lista o estado vacío
              if (lista.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ListaVacia(
                    buscando: _filtro.isNotEmpty || _categoria != 'Todos',
                    onAgregar: _irARegistrar,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList.builder(
                    itemCount: lista.length,
                    itemBuilder: (_, i) {
                      final p = lista[i];
                      // (No visto en clase) Dismissible elimina
                      // deslizando la tarjeta hacia la izquierda.
                      return FadeSlideIn(
                        delay: i * 80,
                        child: Dismissible(
                          key: ValueKey(p.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 28),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFCA5A5), AppColors.danger],
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Eliminar',
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.w700)),
                                SizedBox(width: 8),
                                Icon(Icons.delete_rounded, color: Colors.white),
                              ],
                            ),
                          ),
                          onDismissed: (_) => _eliminar(p),
                          child: ProductoCard(
                            producto: p,
                            onTap: () => _verDetalle(p),
                            onEditar: () => _irARegistrar(p),
                            onEliminar: () => _eliminar(p),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _irARegistrar,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          highlightElevation: 0,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  const _Dato({required this.icono, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icono, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(valor,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaVacia extends StatelessWidget {
  final bool buscando;
  final VoidCallback onAgregar;
  const _ListaVacia({required this.buscando, required this.onAgregar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              buscando ? Icons.search_off_rounded : Icons.inventory_2_outlined,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            buscando ? 'No se encontraron productos' : 'Aún no hay productos',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            buscando ? 'Prueba con otro nombre o categoría' : 'Registra tu primer producto',
            style: const TextStyle(color: AppColors.textLight),
          ),
          if (!buscando) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAgregar,
              icon: const Icon(Icons.add),
              label: const Text('Registrar producto'),
            ),
          ],
        ],
      ),
    );
  }
}

// Widget reutilizable: tarjeta de producto para la lista
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import 'producto_imagen.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;
  final VoidCallback? onTap;

  /// Si es true no muestra el menú ⋮ (se usa en la vista previa)
  final bool soloLectura;

  const ProductoCard({
    super.key,
    required this.producto,
    this.onEditar,
    this.onEliminar,
    this.onTap,
    this.soloLectura = false,
  });

  @override
  Widget build(BuildContext context) {
    final degradado = AppColors.gradientFor(producto.categoria);
    final colorCategoria = degradado.colors.first;
    final stockBajo = producto.stock < 10;
    final colorStock = stockBajo ? AppColors.danger : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // (No visto en clase) Hero anima el ícono desde la
                // lista hasta la hoja de detalle usando el mismo "tag".
                Hero(
                  tag: soloLectura ? 'preview' : 'producto-${producto.id}',
                  child: ProductoImagen(
                    url: producto.imagenUrl,
                    iconoRespaldo: producto.icono,
                    categoria: producto.categoria,
                    size: 84,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Etiqueta de categoría
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorCategoria.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          producto.categoria.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: colorCategoria,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (producto.marca.isNotEmpty)
                        Text(
                          producto.marca,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Text(
                        producto.nombre.isEmpty ? 'Nombre del producto' : producto.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        producto.precioFormateado,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // (No visto en clase) LinearProgressIndicator
                      // como "barra de stock" (máximo referencial: 50 und.)
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: (producto.stock / 50).clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: AppColors.inputFill,
                                valueColor: AlwaysStoppedAnimation(colorStock),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${producto.stock} und.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorStock,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!soloLectura)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: AppColors.textLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: (opcion) {
                      if (opcion == 'editar') onEditar?.call();
                      if (opcion == 'eliminar') onEliminar?.call();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'editar',
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Editar'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: Row(children: [
                          Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.danger),
                          SizedBox(width: 12),
                          Text('Eliminar', style: TextStyle(color: AppColors.danger)),
                        ]),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PANTALLA 4: REGISTRAR PRODUCTO (también sirve para EDITAR)
// Foto desde galería o URL, formulario por secciones y vista previa.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/decorations.dart';
import '../widgets/primary_button.dart';
import '../widgets/producto_card.dart';
import '../widgets/producto_imagen.dart';

class RegistrarProductoScreen extends StatefulWidget {
  /// Si es null -> REGISTRAR. Si trae un producto -> EDITAR.
  final Producto? productoEditar;

  const RegistrarProductoScreen({super.key, this.productoEditar});

  @override
  State<RegistrarProductoScreen> createState() => _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;

  String? _imagenUrl;          // foto elegida
  String _categoria = 'Otro';  // categoría del producto
  bool _guardando = false;

  bool get _esEdicion => widget.productoEditar != null;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, llenamos los campos con los datos actuales
    final p = widget.productoEditar;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _marcaCtrl = TextEditingController(text: p?.marca ?? '');
    _descCtrl = TextEditingController(text: p?.descripcion ?? '');
    _precioCtrl = TextEditingController(text: p != null ? p.precio.toStringAsFixed(2) : '');
    _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');
    _imagenUrl = p?.imagenUrl;
    _categoria = p?.categoria ?? 'Otro';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _descCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  /// Arma un Producto con lo que hay escrito (para la vista previa y guardar)
  Producto _productoActual() {
    return Producto(
      id: widget.productoEditar?.id ?? AppData.nuevoId(),
      nombre: _nombreCtrl.text.trim(),
      marca: _marcaCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      precio: double.tryParse(_precioCtrl.text.replaceAll(',', '.')) ?? 0,
      stock: int.tryParse(_stockCtrl.text) ?? 0,
      categoria: _categoria,
      imagenUrl: _imagenUrl,
      icono: AppData.iconoDe(_categoria),
    );
  }

  /// Hoja para elegir la foto: galería del catálogo o pegar una URL
  Future<void> _seleccionarImagen() async {
    final resultado = await showModalBottomSheet<ImagenCatalogo>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _SelectorImagen(urlActual: _imagenUrl, categoriaActual: _categoria),
    );
    if (resultado != null) {
      setState(() {
        _imagenUrl = resultado.url.isEmpty ? null : resultado.url;
        _categoria = resultado.categoria;
        // Si el nombre está vacío, sugerimos el de la foto elegida
        if (_nombreCtrl.text.trim().isEmpty && resultado.nombre.isNotEmpty) {
          _nombreCtrl.text = resultado.nombre;
        }
      });
    }
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus(); // oculta el teclado
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    await Future.delayed(const Duration(milliseconds: 700)); // simula guardado
    if (!mounted) return;

    final datos = _productoActual();
    if (_esEdicion) {
      AppData.actualizarProducto(datos);
    } else {
      AppData.agregarProducto(datos);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_esEdicion
                ? 'Producto actualizado correctamente'
                : '"${datos.nombre}" registrado'),
          ),
        ]),
      ),
    );

    // Flujo: después de guardar SIEMPRE terminamos en la lista, con el
    // Menú debajo (Menú -> Lista), vengas de donde vengas.
    // (No visto en clase) pushNamedAndRemoveUntil + ModalRoute.withName
    // limpia la pila de navegación hasta una ruta concreta.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.listarProductos,
      ModalRoute.withName(AppRoutes.menu),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneFoto = _imagenUrl != null;

    return Scaffold(
      extendBodyBehindAppBar: true, // el cuerpo pasa detrás del AppBar
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Producto' : 'Registrar Producto'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Encabezado con selector de foto
              GradientHeader(
                height: 320,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _seleccionarImagen,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // (No visto en clase) AnimatedContainer
                            // anima los cambios de color y sombra.
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 150,
                              height: 150,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: tieneFoto
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: tieneFoto
                                  ? ProductoImagen(
                                      url: _imagenUrl,
                                      iconoRespaldo: AppData.iconoDe(_categoria),
                                      categoria: _categoria,
                                      size: 134,
                                      radius: 30,
                                    )
                                  : const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo_rounded,
                                            size: 46, color: Colors.white),
                                        SizedBox(height: 8),
                                        Text('Seleccionar\nimagen',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12)),
                                      ],
                                    ),
                            ),
                            Positioned(
                              right: -6,
                              bottom: -6,
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(Icons.photo_library_rounded,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppData.iconoDe(_categoria), color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Categoría: $_categoria',
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Datos generales
                    FadeSlideIn(
                      child: SectionCard(
                        titulo: 'Información del producto',
                        icono: Icons.info_outline_rounded,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nombreCtrl,
                              hint: 'Nombre del producto',
                              icon: Icons.label_outline_rounded,
                              validator: (v) => (v == null || v.trim().length < 2)
                                  ? 'Ingresa un nombre válido'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              controller: _marcaCtrl,
                              hint: 'Marca (Apple, Samsung...)',
                              icon: Icons.verified_outlined,
                            ),
                            const SizedBox(height: 14),
                            // Categoría con menú desplegable
                            DropdownButtonFormField<String>(
                              value: _categoria,
                              borderRadius: BorderRadius.circular(16),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.category_outlined,
                                    color: AppColors.primary.withValues(alpha: 0.75)),
                              ),
                              items: AppData.categorias.entries
                                  .map((e) => DropdownMenuItem(
                                        value: e.key,
                                        child: Row(children: [
                                          Icon(e.value, size: 18, color: AppColors.textLight),
                                          const SizedBox(width: 10),
                                          Text(e.key),
                                        ]),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _categoria = v ?? 'Otro'),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              controller: _descCtrl,
                              hint: 'Descripción',
                              icon: Icons.notes_rounded,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Precio y stock
                    FadeSlideIn(
                      delay: 150,
                      child: SectionCard(
                        titulo: 'Precio y stock',
                        icono: Icons.sell_outlined,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _precioCtrl,
                                hint: '0.00',
                                prefixText: 'S/ ',
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  // Solo números con hasta 2 decimales
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*[.,]?\d{0,2}')),
                                ],
                                validator: (v) {
                                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                                  if (n == null) return 'Precio requerido';
                                  if (n <= 0) return 'Mayor a 0';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: _stockCtrl,
                                hint: 'Stock',
                                icon: Icons.inventory_outlined,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (v) =>
                                    int.tryParse(v ?? '') == null ? 'Stock requerido' : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Vista previa en vivo
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'VISTA PREVIA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    // (No visto en clase) ListenableBuilder +
                    // Listenable.merge redibuja la tarjeta cada vez que
                    // cambia CUALQUIERA de los campos, sin usar setState.
                    ListenableBuilder(
                      listenable: Listenable.merge(
                          [_nombreCtrl, _marcaCtrl, _precioCtrl, _stockCtrl, _descCtrl]),
                      builder: (_, __) => ProductoCard(
                        producto: _productoActual(),
                        soloLectura: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    PrimaryButton(
                      text: _esEdicion ? 'ACTUALIZAR' : 'GUARDAR',
                      icon: Icons.save_rounded,
                      loading: _guardando,
                      onPressed: _guardar,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hoja inferior con la galería de fotos y la opción de pegar una URL
class _SelectorImagen extends StatefulWidget {
  final String? urlActual;
  final String categoriaActual;
  const _SelectorImagen({required this.urlActual, required this.categoriaActual});

  @override
  State<_SelectorImagen> createState() => _SelectorImagenState();
}

class _SelectorImagenState extends State<_SelectorImagen> {
  final _urlCtrl = TextEditingController();
  String _filtro = 'Todas';

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ['Todas', ...{for (final i in AppData.galeria) i.categoria}];
    final fotos = AppData.galeria
        .where((i) => _filtro == 'Todas' || i.categoria == _filtro)
        .toList();

    return Padding(
      // viewInsets.bottom = alto del teclado (para el campo URL)
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Elige una foto',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('De la galería o pegando una URL',
                style: TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 14),

            // Pegar URL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlCtrl,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        hintText: 'https://.../imagen.jpg',
                        prefixIcon: Icon(Icons.link_rounded),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      final url = _urlCtrl.text.trim();
                      if (!url.startsWith('http')) return;
                      Navigator.pop(
                          context, ImagenCatalogo('', widget.categoriaActual, url));
                    },
                    child: const Text('Usar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Filtro por categoría
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final activo = cats[i] == _filtro;
                  return ChoiceChip(
                    label: Text(cats[i]),
                    selected: activo,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: activo ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _filtro = cats[i]),
                  );
                },
              ),
            ),

            // Galería
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemCount: fotos.length,
                itemBuilder: (_, i) {
                  final foto = fotos[i];
                  final seleccionada = foto.url == widget.urlActual;
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.pop(context, foto),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: seleccionada ? AppColors.primary : AppColors.border,
                          width: seleccionada ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              // (No visto en clase) LayoutBuilder nos da
                              // el tamaño disponible para dimensionar la foto.
                              builder: (_, c) => ProductoImagen(
                                url: foto.url,
                                iconoRespaldo: AppData.iconoDe(foto.categoria),
                                categoria: foto.categoria,
                                size: c.biggest.shortestSide,
                                radius: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            foto.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quitar foto
            TextButton.icon(
              onPressed: () =>
                  Navigator.pop(context, ImagenCatalogo('', widget.categoriaActual, '')),
              icon: const Icon(Icons.hide_image_outlined),
              label: const Text('Sin foto (usar ícono)'),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

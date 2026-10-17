// TechStore App: versión en un solo archivo para probar en DartPad.
// Pega todo en https://dartpad.dev y presiona Run.
// Usuario de prueba: admin@techstore.com / 123456
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Archivo original: lib/main.dart
// TechStore App - Laboratorio Flutter (Sección B)
// Punto de entrada de la aplicación.


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

// Archivo original: lib/routes/app_routes.dart
// Rutas de la aplicación (navegación centralizada)


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

// Archivo original: lib/theme/app_theme.dart
// Tema global: colores, degradados, sombras y estilos

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

// Archivo original: lib/models/producto.dart
// Modelo: Producto

class Producto {
  final String id;
  final String nombre;
  final String marca;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;

  /// URL de la foto del producto (puede ser null si no tiene foto)
  final String? imagenUrl;

  /// Ícono de respaldo: se muestra si no hay foto o si no carga
  final IconData icono;

  const Producto({
    required this.id,
    required this.nombre,
    this.marca = '',
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    this.imagenUrl,
    required this.icono,
  });

  // (No visto en clase) copyWith crea una copia del objeto
  // cambiando solo algunos campos (útil para EDITAR sin mutar el original).
  Producto copyWith({
    String? nombre,
    String? marca,
    String? descripcion,
    double? precio,
    int? stock,
    String? categoria,
    String? imagenUrl,
    IconData? icono,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      icono: icono ?? this.icono,
    );
  }

  /// Precio con formato peruano: "S/ 3,500.00"
  String get precioFormateado {
    final partes = precio.toStringAsFixed(2).split('.');
    // (No visto en clase) expresión regular para poner comas de miles
    final entero = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return 'S/ $entero.${partes[1]}';
  }
}

// Archivo original: lib/models/usuario.dart
// Modelo: Usuario
class Usuario {
  final String nombre;
  final String email;
  final String telefono;
  final String rol;

  const Usuario({
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  /// Iniciales para el avatar (ej. "Juan Pérez" -> "JP")
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  Usuario copyWith({String? nombre, String? email, String? telefono, String? rol}) {
    return Usuario(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
    );
  }
}

// Archivo original: lib/data/app_data.dart
// Datos de la app (en memoria, sin base de datos)
// Productos reales con fotos del catálogo público DummyJSON
// (https://dummyjson.com). Precios referenciales en soles.


/// Imagen del catálogo que se puede elegir al registrar un producto
class ImagenCatalogo {
  final String nombre;
  final String categoria;
  final String url;
  const ImagenCatalogo(this.nombre, this.categoria, this.url);
}

/// (No visto en clase) ValueNotifier es una forma sencilla de
/// manejar ESTADO COMPARTIDO entre pantallas sin librerías externas.
/// Cuando cambia `.value`, todos los ValueListenableBuilder que lo
/// escuchan se redibujan automáticamente.
class AppData {
  AppData._(); // constructor privado: no se crean instancias

  // Credenciales de prueba para el login
  static const String demoEmail = 'admin@techstore.com';
  static const String demoPassword = '123456';

  // Base de las URLs de las fotos
  static const String _cdn = 'https://cdn.dummyjson.com/product-images';

  /// Usuario que inició sesión
  static final ValueNotifier<Usuario> usuario = ValueNotifier(
    const Usuario(
      nombre: 'Juan Pérez',
      email: 'juan.perez@correo.com',
      telefono: '987654321',
      rol: 'Administrador',
    ),
  );

  /// Categorías con su ícono de respaldo
  static const Map<String, IconData> categorias = {
    'Laptops': Icons.laptop_mac_rounded,
    'Celulares': Icons.smartphone_rounded,
    'Tablets': Icons.tablet_mac_rounded,
    'Audio': Icons.headphones_rounded,
    'Wearables': Icons.watch_rounded,
    'Accesorios': Icons.cable_rounded,
    'Otro': Icons.inventory_2_rounded,
  };

  static IconData iconoDe(String categoria) =>
      categorias[categoria] ?? Icons.inventory_2_rounded;

  /// Lista de productos inicial
  static final ValueNotifier<List<Producto>> productos = ValueNotifier([
    const Producto(
      id: '1',
      nombre: 'MacBook Pro 14"',
      marca: 'Apple',
      categoria: 'Laptops',
      descripcion: 'Chip M1 Pro, pantalla Liquid Retina XDR de 14", 16 GB RAM y 512 GB SSD. Color gris espacial.',
      precio: 7499,
      stock: 24,
      imagenUrl: '$_cdn/laptops/apple-macbook-pro-14-inch-space-grey/thumbnail.webp',
      icono: Icons.laptop_mac_rounded,
    ),
    const Producto(
      id: '2',
      nombre: 'XPS 13 9300',
      marca: 'Dell',
      categoria: 'Laptops',
      descripcion: 'Ultrabook de 13.4" con bordes mínimos, Intel Core i7 y 16 GB RAM. Ideal para llevar a clases.',
      precio: 5599,
      stock: 9,
      imagenUrl: '$_cdn/laptops/new-dell-xps-13-9300-laptop/thumbnail.webp',
      icono: Icons.laptop_mac_rounded,
    ),
    const Producto(
      id: '3',
      nombre: 'Yoga 920',
      marca: 'Lenovo',
      categoria: 'Laptops',
      descripcion: 'Convertible 2 en 1 con bisagra de 360°: úsala como laptop o como tablet táctil.',
      precio: 4099,
      stock: 40,
      imagenUrl: '$_cdn/laptops/lenovo-yoga-920/thumbnail.webp',
      icono: Icons.laptop_mac_rounded,
    ),
    const Producto(
      id: '4',
      nombre: 'Zenbook Pro Duo',
      marca: 'Asus',
      categoria: 'Laptops',
      descripcion: 'Laptop de doble pantalla para diseño, edición de video y multitarea intensa.',
      precio: 6699,
      stock: 6,
      imagenUrl: '$_cdn/laptops/asus-zenbook-pro-dual-screen-laptop/thumbnail.webp',
      icono: Icons.laptop_mac_rounded,
    ),
    const Producto(
      id: '5',
      nombre: 'iPhone 13 Pro',
      marca: 'Apple',
      categoria: 'Celulares',
      descripcion: 'Triple cámara de 12 MP, chip A15 Bionic y pantalla ProMotion de 120 Hz.',
      precio: 4099,
      stock: 18,
      imagenUrl: '$_cdn/smartphones/iphone-13-pro/thumbnail.webp',
      icono: Icons.smartphone_rounded,
    ),
    const Producto(
      id: '6',
      nombre: 'Galaxy S10',
      marca: 'Samsung',
      categoria: 'Celulares',
      descripcion: 'Pantalla Dynamic AMOLED de 6.1", triple cámara y lector de huella en pantalla.',
      precio: 2599,
      stock: 19,
      imagenUrl: '$_cdn/smartphones/samsung-galaxy-s10/thumbnail.webp',
      icono: Icons.smartphone_rounded,
    ),
    const Producto(
      id: '7',
      nombre: 'iPad Mini 2021',
      marca: 'Apple',
      categoria: 'Tablets',
      descripcion: 'Tablet compacta de 8.3" con chip A15, compatible con Apple Pencil. Color blanco estelar.',
      precio: 1899,
      stock: 47,
      imagenUrl: '$_cdn/tablets/ipad-mini-2021-starlight/thumbnail.webp',
      icono: Icons.tablet_mac_rounded,
    ),
    const Producto(
      id: '8',
      nombre: 'Galaxy Tab S8+',
      marca: 'Samsung',
      categoria: 'Tablets',
      descripcion: 'Pantalla Super AMOLED de 12.4" con S Pen incluido, ideal para tomar apuntes.',
      precio: 2249,
      stock: 12,
      imagenUrl: '$_cdn/tablets/samsung-galaxy-tab-s8-plus-grey/thumbnail.webp',
      icono: Icons.tablet_mac_rounded,
    ),
    const Producto(
      id: '9',
      nombre: 'AirPods',
      marca: 'Apple',
      categoria: 'Audio',
      descripcion: 'Audífonos inalámbricos con emparejamiento instantáneo y estuche de carga.',
      precio: 489,
      stock: 35,
      imagenUrl: '$_cdn/mobile-accessories/apple-airpods/thumbnail.webp',
      icono: Icons.headphones_rounded,
    ),
    const Producto(
      id: '10',
      nombre: 'AirPods Max',
      marca: 'Apple',
      categoria: 'Audio',
      descripcion: 'Audífonos over-ear con cancelación activa de ruido y audio espacial.',
      precio: 2059,
      stock: 4,
      imagenUrl: '$_cdn/mobile-accessories/apple-airpods-max-silver/thumbnail.webp',
      icono: Icons.headphones_rounded,
    ),
    const Producto(
      id: '11',
      nombre: 'Beats Flex',
      marca: 'Beats',
      categoria: 'Audio',
      descripcion: 'Audífonos inalámbricos con auriculares magnéticos y hasta 12 horas de batería.',
      precio: 189,
      stock: 50,
      imagenUrl: '$_cdn/mobile-accessories/beats-flex-wireless-earphones/thumbnail.webp',
      icono: Icons.headphones_rounded,
    ),
    const Producto(
      id: '12',
      nombre: 'Apple Watch Series 4',
      marca: 'Apple',
      categoria: 'Wearables',
      descripcion: 'Smartwatch dorado con monitor de ritmo cardiaco, GPS y seguimiento de actividad.',
      precio: 1299,
      stock: 8,
      imagenUrl: '$_cdn/mobile-accessories/apple-watch-series-4-gold/thumbnail.webp',
      icono: Icons.watch_rounded,
    ),
  ]);

  /// Galería de fotos para elegir al REGISTRAR un producto nuevo
  static const List<ImagenCatalogo> galeria = [
    ImagenCatalogo('MacBook Pro', 'Laptops', '$_cdn/laptops/apple-macbook-pro-14-inch-space-grey/thumbnail.webp'),
    ImagenCatalogo('Matebook X Pro', 'Laptops', '$_cdn/laptops/huawei-matebook-x-pro/thumbnail.webp'),
    ImagenCatalogo('Dell XPS 13', 'Laptops', '$_cdn/laptops/new-dell-xps-13-9300-laptop/thumbnail.webp'),
    ImagenCatalogo('Lenovo Yoga', 'Laptops', '$_cdn/laptops/lenovo-yoga-920/thumbnail.webp'),
    ImagenCatalogo('iPhone 13 Pro', 'Celulares', '$_cdn/smartphones/iphone-13-pro/thumbnail.webp'),
    ImagenCatalogo('iPhone X', 'Celulares', '$_cdn/smartphones/iphone-x/thumbnail.webp'),
    ImagenCatalogo('Galaxy S10', 'Celulares', '$_cdn/smartphones/samsung-galaxy-s10/thumbnail.webp'),
    ImagenCatalogo('Oppo F19 Pro+', 'Celulares', '$_cdn/smartphones/oppo-f19-pro-plus/thumbnail.webp'),
    ImagenCatalogo('iPad Mini', 'Tablets', '$_cdn/tablets/ipad-mini-2021-starlight/thumbnail.webp'),
    ImagenCatalogo('Galaxy Tab', 'Tablets', '$_cdn/tablets/samsung-galaxy-tab-white/thumbnail.webp'),
    ImagenCatalogo('AirPods', 'Audio', '$_cdn/mobile-accessories/apple-airpods/thumbnail.webp'),
    ImagenCatalogo('AirPods Max', 'Audio', '$_cdn/mobile-accessories/apple-airpods-max-silver/thumbnail.webp'),
    ImagenCatalogo('HomePod Mini', 'Audio', '$_cdn/mobile-accessories/apple-homepod-mini-cosmic-grey/thumbnail.webp'),
    ImagenCatalogo('Echo Plus', 'Audio', '$_cdn/mobile-accessories/amazon-echo-plus/thumbnail.webp'),
    ImagenCatalogo('Apple Watch', 'Wearables', '$_cdn/mobile-accessories/apple-watch-series-4-gold/thumbnail.webp'),
    ImagenCatalogo('MagSafe Battery', 'Accesorios', '$_cdn/mobile-accessories/apple-magsafe-battery-pack/thumbnail.webp'),
    ImagenCatalogo('Cargador iPhone', 'Accesorios', '$_cdn/mobile-accessories/apple-iphone-charger/thumbnail.webp'),
    ImagenCatalogo('Funda MagSafe', 'Accesorios', '$_cdn/mobile-accessories/iphone-12-silicone-case-with-magsafe-plum/thumbnail.webp'),
  ];

  // Operaciones CRUD

  /// Total de unidades en stock
  static int get totalUnidades =>
      productos.value.fold<int>(0, (suma, p) => suma + p.stock);

  /// Valor total del inventario (precio x stock)
  static double get valorInventario =>
      productos.value.fold<double>(0.0, (suma, p) => suma + p.precio * p.stock);

  static void agregarProducto(Producto p) {
    // Se crea una lista NUEVA para que el ValueNotifier detecte el cambio
    productos.value = [...productos.value, p];
  }

  static void actualizarProducto(Producto p) {
    productos.value = [
      for (final item in productos.value) item.id == p.id ? p : item,
    ];
  }

  static void eliminarProducto(String id) {
    productos.value = productos.value.where((p) => p.id != id).toList();
  }

  static String nuevoId() => DateTime.now().millisecondsSinceEpoch.toString();
}

// Archivo original: lib/widgets/decorations.dart
// Widgets decorativos reutilizables:
//  - GradientHeader: encabezado con degradado y borde curvo
//  - FadeSlideIn: animación de entrada (aparece y sube)
//  - SectionCard: tarjeta blanca con título


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

// Archivo original: lib/widgets/custom_text_field.dart
// Widget reutilizable: campo de texto con ícono y validación


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? prefixText;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixText,
    this.maxLines = 1,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _ocultar = true; // para el botón del "ojito"

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _ocultar,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      // (No visto en clase) inputFormatters restringe lo que el
      // usuario puede escribir (ej. solo números en el stock).
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      style: const TextStyle(fontSize: 15, color: AppColors.textDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w400),
        prefixText: widget.prefixText,
        prefixStyle: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: AppColors.primary.withValues(alpha: 0.75), size: 22)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _ocultar ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textLight,
                ),
                onPressed: () => setState(() => _ocultar = !_ocultar),
              )
            : null,
      ),
    );
  }
}

// Archivo original: lib/widgets/primary_button.dart
// Widget reutilizable: botón con degradado y botón con borde


class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = outlined ? AppColors.primary : Colors.white;

    final contenido = loading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20, color: color), const SizedBox(width: 10)],
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          );

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.primary, width: 1.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: contenido,
        ),
      );
    }

    // (No visto en clase) ElevatedButton no acepta degradados,
    // así que construimos el botón con DecoratedBox + Material + InkWell
    // para tener degradado, sombra de color y efecto "onda" al tocar.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.40),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: loading ? null : onPressed,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Center(child: contenido),
          ),
        ),
      ),
    );
  }
}

// Archivo original: lib/widgets/menu_option_tile.dart
// Widget reutilizable: acceso del menú en forma de tarjeta con degradado

class MenuOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const MenuOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorSombra = gradient.colors.first;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorSombra.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Stack(
            children: [
              // Ícono grande y transparente de fondo (decorativo)
              Positioned(
                right: -14,
                bottom: -14,
                child: Icon(icon, size: 96, color: Colors.white.withValues(alpha: 0.13)),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
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

// Archivo original: lib/widgets/producto_imagen.dart
// Widget reutilizable: foto del producto desde internet
// - Muestra un indicador mientras carga
// - Si falla (sin internet o URL mala) muestra el ícono de respaldo


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

// Archivo original: lib/widgets/producto_card.dart
// Widget reutilizable: tarjeta de producto para la lista


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

// Archivo original: lib/screens/login_screen.dart
// PANTALLA 1: LOGIN
// Valida email y contraseña y navega al Menú.


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // (No visto en clase) GlobalKey<FormState> permite validar
  // todos los campos del formulario con una sola llamada: validate().
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _cargando = false;
  bool _recordarme = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    await Future.delayed(const Duration(seconds: 1)); // simula el servidor

    // (No visto en clase) "mounted" evita usar el context si la
    // pantalla ya se cerró mientras esperábamos el Future.
    if (!mounted) return;
    setState(() => _cargando = false);

    final ok = _emailCtrl.text.trim() == AppData.demoEmail &&
        _passCtrl.text == AppData.demoPassword;

    if (ok) {
      // pushReplacementNamed: el botón "atrás" ya no vuelve al login
      Navigator.pushReplacementNamed(context, AppRoutes.menu);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Row(children: [
            Icon(Icons.error_outline_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Email o contraseña incorrectos'),
          ]),
        ),
      );
    }
  }

  void _olvideContrasena() {
    // (No visto en clase) showModalBottomSheet abre una hoja desde abajo
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_reset_rounded, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Usa la cuenta de prueba:\n${AppData.demoEmail}  ·  ${AppData.demoPassword}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight, height: 1.5),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'AUTOCOMPLETAR',
              icon: Icons.bolt_rounded,
              onPressed: () {
                _emailCtrl.text = AppData.demoEmail;
                _passCtrl.text = AppData.demoPassword;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: Stack(
          children: [
            // Círculos decorativos de fondo
            Positioned(top: -80, right: -60, child: _circulo(240, 0.10)),
            Positioned(top: 160, left: -90, child: _circulo(200, 0.06)),
            Positioned(bottom: -60, right: -40, child: _circulo(180, 0.08)),

            SafeArea(
              child: Center(
                // SingleChildScrollView evita el "overflow" cuando sale el teclado
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        // Logo y marca
                        FadeSlideIn(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(Icons.shopping_bag_rounded,
                                    color: Colors.white, size: 52),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'TechStore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Gestiona tu inventario fácilmente',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Tarjeta del formulario
                        FadeSlideIn(
                          delay: 200,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Ingresa tus credenciales para continuar',
                                    style: TextStyle(color: AppColors.textLight, fontSize: 14),
                                  ),
                                  const SizedBox(height: 26),
                                  CustomTextField(
                                    controller: _emailCtrl,
                                    hint: 'Email',
                                    icon: Icons.alternate_email_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Ingresa tu email';
                                      }
                                      // (No visto en clase) validar el
                                      // formato del correo con expresión regular
                                      final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.]+$');
                                      if (!regex.hasMatch(v.trim())) return 'Email no válido';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: _passCtrl,
                                    hint: 'Password',
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    textInputAction: TextInputAction.done,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                                      if (v.length < 6) return 'Mínimo 6 caracteres';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _recordarme,
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          onChanged: (v) =>
                                              setState(() => _recordarme = v ?? false),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Recordarme',
                                          style: TextStyle(color: AppColors.textLight)),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: _olvideContrasena,
                                        child: const Text(
                                          '¿Olvidaste tu contraseña?',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  PrimaryButton(
                                    text: 'LOGIN',
                                    icon: Icons.login_rounded,
                                    loading: _cargando,
                                    onPressed: _iniciarSesion,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeSlideIn(
                          delay: 400,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Demo: ${AppData.demoEmail} · ${AppData.demoPassword}',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

// Archivo original: lib/screens/menu_screen.dart
// PANTALLA 2: MENÚ PRINCIPAL
// Encabezado con saludo, estadísticas y accesos a cada pantalla.


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

// Archivo original: lib/screens/listar_productos_screen.dart
// PANTALLA 3: LISTAR PRODUCTOS
// Buscador, filtro por categoría, editar, eliminar (con deshacer)
// y botón "+" para registrar.


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

// Archivo original: lib/screens/registrar_producto_screen.dart
// PANTALLA 4: REGISTRAR PRODUCTO (también sirve para EDITAR)
// Foto desde galería o URL, formulario por secciones y vista previa.


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

// Archivo original: lib/screens/perfil_screen.dart
// PANTALLA 5: PERFIL
// Muestra los datos del usuario y permite editarlos.


class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  /// Abre un formulario en hoja inferior para editar el perfil
  void _editarPerfil(BuildContext context, Usuario actual) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // la hoja sube junto con el teclado
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _EditarPerfilSheet(usuario: actual),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Perfil')),
      body: ValueListenableBuilder<Usuario>(
        valueListenable: AppData.usuario,
        builder: (context, usuario, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Encabezado con avatar
                GradientHeader(
                  height: 350,
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        // (No visto en clase) Stack + Positioned para
                        // poner el botón de editar sobre el avatar.
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Text(
                                  usuario.iniciales,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: GestureDetector(
                                onTap: () => _editarPerfil(context, usuario),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientIndex(1),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: const Icon(Icons.edit_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          usuario.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          usuario.email,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(usuario.rol,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    children: [
                      // Resumen de actividad
                      FadeSlideIn(
                        child: ValueListenableBuilder<List<Producto>>(
                          valueListenable: AppData.productos,
                          builder: (_, lista, __) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Row(
                              children: [
                                _Resumen(valor: '${lista.length}', etiqueta: 'Productos'),
                                _separador(),
                                _Resumen(
                                    valor: '${AppData.totalUnidades}', etiqueta: 'Unidades'),
                                _separador(),
                                const _Resumen(valor: '100%', etiqueta: 'Activo'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Datos
                      FadeSlideIn(
                        delay: 150,
                        child: SectionCard(
                          titulo: 'Información personal',
                          icono: Icons.badge_outlined,
                          child: Column(
                            children: [
                              _FilaDato(
                                  icon: Icons.person_rounded,
                                  titulo: 'Nombre',
                                  valor: usuario.nombre,
                                  indice: 0),
                              _FilaDato(
                                  icon: Icons.mail_rounded,
                                  titulo: 'Email',
                                  valor: usuario.email,
                                  indice: 1),
                              _FilaDato(
                                  icon: Icons.phone_rounded,
                                  titulo: 'Teléfono',
                                  valor: usuario.telefono,
                                  indice: 3),
                              _FilaDato(
                                  icon: Icons.admin_panel_settings_rounded,
                                  titulo: 'Roles',
                                  valor: usuario.rol,
                                  indice: 2,
                                  ultimo: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                        delay: 300,
                        child: Column(
                          children: [
                            PrimaryButton(
                              text: 'EDITAR PERFIL',
                              icon: Icons.edit_rounded,
                              onPressed: () => _editarPerfil(context, usuario),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: () => MenuScreen.logout(context),
                              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                              label: const Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                    color: AppColors.danger, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _separador() => Container(width: 1, height: 36, color: AppColors.border);
}

class _Resumen extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Resumen({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(valor,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(etiqueta, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
        ],
      ),
    );
  }
}

/// Fila "ícono de color · título / valor"
class _FilaDato extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final int indice;
  final bool ultimo;

  const _FilaDato({
    required this.icon,
    required this.titulo,
    required this.valor,
    required this.indice,
    this.ultimo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ultimo ? 0 : 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.gradientIndex(indice),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                const SizedBox(height: 2),
                Text(
                  valor,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Formulario para editar el perfil
class _EditarPerfilSheet extends StatefulWidget {
  final Usuario usuario;
  const _EditarPerfilSheet({required this.usuario});

  @override
  State<_EditarPerfilSheet> createState() => _EditarPerfilSheetState();
}

class _EditarPerfilSheetState extends State<_EditarPerfilSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.usuario.nombre);
  late final _emailCtrl = TextEditingController(text: widget.usuario.email);
  late final _telCtrl = TextEditingController(text: widget.usuario.telefono);

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    // Al cambiar .value, el Perfil y el Menú se actualizan solos
    AppData.usuario.value = widget.usuario.copyWith(
      nombre: _nombreCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telefono: _telCtrl.text.trim(),
    );
    // Obtenemos el messenger ANTES de cerrar la hoja
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 10),
          Text('Perfil actualizado'),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // (No visto en clase) viewInsets.bottom = altura del teclado,
      // así el formulario no queda oculto detrás de él.
      padding: EdgeInsets.fromLTRB(24, 14, 24, MediaQuery.of(context).viewInsets.bottom + 28),
      child: Form(
        key: _formKey,
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
            const SizedBox(height: 18),
            const Text('Editar perfil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _nombreCtrl,
              hint: 'Nombre completo',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _emailCtrl,
              hint: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@')) ? 'Email no válido' : null,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _telCtrl,
              hint: 'Teléfono',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  (v == null || v.trim().length != 9) ? 'Debe tener 9 dígitos' : null,
            ),
            const SizedBox(height: 22),
            PrimaryButton(text: 'GUARDAR CAMBIOS', icon: Icons.check_rounded, onPressed: _guardar),
          ],
        ),
      ),
    );
  }
}

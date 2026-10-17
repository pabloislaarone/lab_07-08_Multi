// Datos de la app (en memoria, sin base de datos)
// Productos reales con fotos del catálogo público DummyJSON
// (https://dummyjson.com). Precios referenciales en soles.
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../models/usuario.dart';

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

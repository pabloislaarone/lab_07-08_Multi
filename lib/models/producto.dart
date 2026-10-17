// Modelo: Producto
import 'package:flutter/material.dart';

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

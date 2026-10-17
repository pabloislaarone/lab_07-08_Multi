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

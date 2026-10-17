// PANTALLA 5: PERFIL
// Muestra los datos del usuario y permite editarlos.
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/decorations.dart';
import '../widgets/primary_button.dart';
import 'menu_screen.dart';

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

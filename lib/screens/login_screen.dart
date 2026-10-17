// PANTALLA 1: LOGIN
// Valida email y contraseña y navega al Menú.
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/decorations.dart';
import '../widgets/primary_button.dart';

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

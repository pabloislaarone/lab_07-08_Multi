// Widget reutilizable: campo de texto con ícono y validación
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

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

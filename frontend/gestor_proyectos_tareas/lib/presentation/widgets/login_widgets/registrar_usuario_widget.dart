import 'package:flutter/material.dart';

class RegistrarseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegistrarseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        '¿No tienes cuenta? Regístrate aquí',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

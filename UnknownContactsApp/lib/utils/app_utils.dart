import 'package:flutter/material.dart';

// Función de utilidad para mostrar un SnackBar de forma segura.
void showAppSnackBar(BuildContext context, String message,
    {Color? backgroundColor}) {
  // Asegura que el widget sigue montado antes de intentar mostrar el SnackBar.
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:
          backgroundColor ?? Colors.red, // Color por defecto rojo para errores
    ),
  );
}

// Función de utilidad para normalizar números de teléfono, eliminando caracteres no numéricos.
String normalizePhoneNumber(String number) {
  return number.replaceAll(RegExp(r'[^\d]'), '');
}

// Función de utilidad para formatear la fecha de una llamada.
String formatCallDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  // Considera usar el paquete 'intl' para un formato de fecha más robusto y localizado.
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

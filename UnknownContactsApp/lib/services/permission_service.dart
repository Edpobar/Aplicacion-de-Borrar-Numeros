import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unknown_contacts_app/utils/app_utils.dart';

class PermissionService {
  // Solicita los permisos necesarios para la aplicación.
  static Future<bool> requestRequiredPermissions(BuildContext context) async {
    final permissions = [
      Permission.contacts,
      Permission.phone,
      // Para la exportación de archivos, el permiso de almacenamiento puede ser necesario
      // en versiones antiguas de Android. `path_provider` y `share_plus` suelen
      // manejar bien el almacenamiento específico de la aplicación en Android moderno.
      // Se añade `Permission.storage` para robustez, según la documentación.
      Permission.storage,
    ];

    bool allGranted = true;
    for (var permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        status = await permission.request();
        if (!status.isGranted) {
          allGranted = false;
          if (status.isPermanentlyDenied) {
            // Si el permiso es denegado permanentemente, guía al usuario a la configuración.
            _showPermissionDeniedDialog(context, permission);
            return false; // Detiene el proceso y espera la acción del usuario.
          } else {
            showAppSnackBar(context,
                "Permiso necesario denegado: ${permission.toString().split('.').last}");
          }
        }
      }
    }
    return allGranted;
  }

  // Muestra un diálogo si un permiso es denegado permanentemente.
  static void _showPermissionDeniedDialog(
      BuildContext context, Permission permission) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permiso Denegado Permanentemente"),
        content: Text(
            "La aplicación necesita el permiso de ${permission.toString().split('.').last} para funcionar correctamente. Por favor, habilítalo desde la configuración de la aplicación."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text("Abrir Configuración")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
        ],
      ),
    );
  }
}

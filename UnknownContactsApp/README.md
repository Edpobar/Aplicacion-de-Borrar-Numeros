# Unknown Contacts Manager

Una aplicación Flutter para gestionar y exportar contactos no guardados del historial de llamadas.

## Características

- 🔍 **Detección Automática**: Encuentra automáticamente números que no están en tus contactos
- 📊 **Filtros Avanzados**: Filtra por tipo de llamada (entrantes, salientes, perdidas)
- 📱 **Interfaz Moderna**: Diseño limpio y fácil de usar
- 📈 **Exportación Excel**: Exporta los datos a archivos Excel para análisis
- 🔒 **Seguro**: Solo lee datos locales, no envía información a servidores

## Funcionalidades

### 1. Detección de Contactos Desconocidos
- Analiza el historial de llamadas
- Compara con contactos guardados
- Identifica números no registrados

### 2. Filtros y Organización
- **Todos**: Muestra todos los contactos desconocidos
- **Entrantes**: Solo llamadas recibidas
- **Salientes**: Solo llamadas realizadas
- **Perdidas**: Solo llamadas perdidas

### 3. Exportación de Datos
- Exporta a formato Excel (.xlsx)
- Incluye número, fecha, tipo y duración
- Comparte archivos fácilmente

### 4. Detalles de Contacto
- Información completa de cada número
- Fecha y hora de última llamada
- Tipo de llamada y duración

## Instalación

### Requisitos
- Flutter SDK 2.17.0 o superior
- Android SDK 26 o superior
- Permisos de contactos y llamadas

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone [url-del-repositorio]
   cd UnknownContactsApp
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Uso

### 1. Inicio de Sesión
- Usuario: `admin`
- Contraseña: `1234`

### 2. Permisos
La aplicación solicitará permisos para:
- Leer contactos
- Acceder al historial de llamadas
- Almacenar archivos

### 3. Navegación
- **Actualizar**: Recarga la lista de contactos
- **Exportar Excel**: Genera y comparte archivo Excel
- **Filtrar**: Selecciona tipo de llamada a mostrar

## Permisos Requeridos

| Permiso | Propósito |
|---------|-----------|
| `READ_CONTACTS` | Leer contactos guardados |
| `READ_CALL_LOG` | Acceder al historial de llamadas |
| `WRITE_EXTERNAL_STORAGE` | Guardar archivos Excel |
| `READ_EXTERNAL_STORAGE` | Leer archivos guardados |

## Estructura del Proyecto

```
lib/
├── main.dart                 # Aplicación principal
├── models/                   # Modelos de datos
├── services/                 # Servicios de datos
└── widgets/                  # Componentes UI

android/
├── app/
│   └── src/main/
│       └── AndroidManifest.xml  # Configuración Android
└── build.gradle              # Dependencias Android
```

## Dependencias Principales

- **permission_handler**: Gestión de permisos
- **contacts_service**: Acceso a contactos
- **call_log**: Historial de llamadas
- **excel**: Exportación a Excel
- **share_plus**: Compartir archivos

## Solución de Problemas

### Error de Permisos
Si la aplicación no puede acceder a los datos:
1. Ve a Configuración > Aplicaciones
2. Selecciona "Unknown Contacts Manager"
3. Permisos > Activar todos los permisos

### No se Encuentran Contactos
- Verifica que tengas llamadas en el historial
- Asegúrate de que los permisos estén concedidos
- Reinicia la aplicación

### Error de Exportación
- Verifica el espacio de almacenamiento
- Asegúrate de tener permisos de escritura
- Intenta reiniciar la aplicación

## Contribuciones

Las contribuciones son bienvenidas. Para contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Contacto

Para preguntas o soporte, contacta a [tu-email@ejemplo.com]

---

**Nota**: Esta aplicación solo funciona en dispositivos Android y requiere permisos específicos para funcionar correctamente.



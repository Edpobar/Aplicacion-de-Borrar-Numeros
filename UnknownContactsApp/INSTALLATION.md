# Guía de Instalación y Ejecución

## 📱 Instalación Rápida

### Requisitos Previos
- Flutter SDK 2.17.0 o superior
- Android Studio o VS Code
- Dispositivo Android o Emulador
- Permisos de desarrollador habilitados

### Pasos de Instalación

#### 1. **Verificar Flutter**
```bash
flutter doctor
```
Asegúrate de que todos los componentes estén marcados con ✅

#### 2. **Instalar Dependencias**
```bash
flutter pub get
```

#### 3. **Ejecutar la Aplicación**
```bash
flutter run
```

## 🔧 Configuración Detallada

### Configuración de Android

#### 1. **Habilitar Depuración USB**
- Ve a Configuración > Acerca del teléfono
- Toca "Número de compilación" 7 veces
- Ve a Configuración > Opciones de desarrollador
- Activa "Depuración USB"

#### 2. **Permisos de la Aplicación**
La aplicación solicitará automáticamente:
- ✅ Leer contactos
- ✅ Acceder al historial de llamadas
- ✅ Almacenar archivos

### Configuración de Desarrollo

#### 1. **Estructura del Proyecto**
```
UnknownContactsApp/
├── lib/
│   └── main.dart              # Aplicación principal
├── android/
│   ├── app/
│   │   └── src/main/
│   │       └── AndroidManifest.xml
│   └── build.gradle
├── pubspec.yaml               # Dependencias
└── README.md
```

#### 2. **Dependencias Principales**
```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.0.1
  contacts_service: ^0.6.3
  call_log: ^4.0.0
  excel: ^4.0.6
  path_provider: ^2.1.1
  share_plus: ^7.2.1
```

## 🚀 Ejecución

### Modo Debug
```bash
flutter run --debug
```

### Modo Release
```bash
flutter run --release
```

### Compilar APK
```bash
flutter build apk --release
```

## 📊 Uso de la Aplicación

### 1. **Inicio de Sesión**
- Usuario: `admin`
- Contraseña: `1234`

### 2. **Funcionalidades Principales**
- **Actualizar**: Recarga la lista de contactos
- **Filtrar**: Selecciona tipo de llamada
- **Exportar**: Genera archivo Excel
- **Detalles**: Ver información completa

### 3. **Filtros Disponibles**
- **Todos**: Muestra todos los contactos
- **Entrantes**: Solo llamadas recibidas
- **Salientes**: Solo llamadas realizadas
- **Perdidas**: Solo llamadas perdidas

## 🔍 Solución de Problemas

### Error: "No se encontraron contactos"
**Solución:**
1. Verifica que tengas llamadas en el historial
2. Asegúrate de que los permisos estén concedidos
3. Reinicia la aplicación

### Error: "Permisos denegados"
**Solución:**
1. Ve a Configuración > Aplicaciones
2. Selecciona "Unknown Contacts Manager"
3. Permisos > Activar todos los permisos

### Error: "No se puede exportar"
**Solución:**
1. Verifica el espacio de almacenamiento
2. Asegúrate de tener permisos de escritura
3. Intenta reiniciar la aplicación

### Error: "Flutter no encontrado"
**Solución:**
1. Instala Flutter SDK
2. Agrega Flutter al PATH
3. Ejecuta `flutter doctor`

## 📱 Compatibilidad

### Dispositivos Soportados
- ✅ Android 5.0 (API 21) o superior
- ✅ Dispositivos con 2GB RAM mínimo
- ✅ Almacenamiento libre: 100MB

### Versiones de Flutter
- ✅ Flutter 2.17.0+
- ✅ Dart 2.17.0+

## 🔒 Seguridad

### Datos Protegidos
- ✅ Solo lectura local
- ✅ No se envían datos a servidores
- ✅ Permisos mínimos necesarios
- ✅ Validación de entrada

### Privacidad
- ✅ No recopila datos personales
- ✅ No rastrea ubicación
- ✅ No accede a internet
- ✅ Datos solo en el dispositivo

## 📈 Rendimiento

### Optimizaciones
- ✅ Carga asíncrona de datos
- ✅ Filtrado eficiente
- ✅ Memoria optimizada
- ✅ Interfaz responsive

### Límites
- 📊 Máximo 500 contactos por sesión
- 📊 Tiempo de carga: 2-5 segundos
- 📊 Tamaño de archivo Excel: < 1MB

## 🆘 Soporte

### Logs de Debug
```bash
flutter logs
```

### Información del Dispositivo
```bash
flutter devices
```

### Limpiar Cache
```bash
flutter clean
flutter pub get
```

## 📝 Notas Importantes

1. **Primera Ejecución**: La aplicación puede tardar más en cargar
2. **Permisos**: Acepta todos los permisos para funcionar correctamente
3. **Almacenamiento**: Asegúrate de tener espacio libre
4. **Actualizaciones**: Reinicia la app después de cambios importantes

---

**¿Necesitas ayuda?** Revisa la documentación completa en `README.md` o `ARCHITECTURE.md`



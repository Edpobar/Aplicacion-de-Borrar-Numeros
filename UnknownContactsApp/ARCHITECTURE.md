# Arquitectura de la Aplicación Unknown Contacts Manager

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    UNKNOWN CONTACTS MANAGER                │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   LOGIN PAGE    │    │   HOME PAGE     │                │
│  │                 │    │                 │                │
│  │ • Usuario       │───▶│ • Lista Contactos│                │
│  │ • Contraseña    │    │ • Filtros       │                │
│  │ • Autenticación │    │ • Exportación   │                │
│  └─────────────────┘    └─────────────────┘                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    SERVICIOS DE DATOS                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │  CONTACTS       │    │   CALL LOG      │                │
│  │  SERVICE        │    │   SERVICE       │                │
│  │                 │    │                 │                │
│  │ • Leer contactos│    │ • Historial     │                │
│  │ • Normalizar    │    │ • Filtrar       │                │
│  │ • Comparar      │    │ • Ordenar       │                │
│  └─────────────────┘    └─────────────────┘                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    PERMISOS Y SEGURIDAD                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │  PERMISSION     │    │   SECURITY      │                │
│  │  HANDLER        │    │   LAYER         │                │
│  │                 │    │                 │                │
│  │ • READ_CONTACTS │    │ • Validación    │                │
│  │ • READ_CALL_LOG │    │ • Autenticación │                │
│  │ • STORAGE       │    │ • Encriptación  │                │
│  └─────────────────┘    └─────────────────┘                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    EXPORTACIÓN DE DATOS                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │     EXCEL       │    │   SHARE PLUS    │                │
│  │   EXPORT        │    │   SERVICE       │                │
│  │                 │    │                 │                │
│  │ • Crear archivo │    │ • Compartir     │                │
│  │ • Formatear     │    │ • Enviar        │                │
│  │ • Guardar       │    │ • Exportar      │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Flujo de Datos

```
1. USUARIO INICIA SESIÓN
   ↓
2. SOLICITAR PERMISOS
   ↓
3. LEER CONTACTOS GUARDADOS
   ↓
4. LEER HISTORIAL DE LLAMADAS
   ↓
5. COMPARAR Y FILTRAR
   ↓
6. MOSTRAR CONTACTOS DESCONOCIDOS
   ↓
7. EXPORTAR A EXCEL (OPCIONAL)
```

## Componentes Principales

### 1. **LoginPage**
- Autenticación de usuario
- Validación de credenciales
- Interfaz de inicio de sesión

### 2. **HomePage**
- Lista de contactos desconocidos
- Filtros por tipo de llamada
- Botones de acción (actualizar, exportar)

### 3. **UnknownContact Model**
- Estructura de datos para contactos
- Información de llamadas
- Metadatos de contacto

### 4. **Servicios de Datos**
- **ContactsService**: Acceso a contactos del dispositivo
- **CallLog**: Historial de llamadas
- **PermissionHandler**: Gestión de permisos

### 5. **Exportación**
- **Excel**: Creación de archivos .xlsx
- **SharePlus**: Compartir archivos
- **PathProvider**: Gestión de rutas

## Permisos Requeridos

| Permiso | Propósito | Nivel de Riesgo |
|---------|-----------|-----------------|
| `READ_CONTACTS` | Leer contactos guardados | Medio |
| `READ_CALL_LOG` | Acceder al historial | Alto |
| `WRITE_EXTERNAL_STORAGE` | Guardar archivos | Bajo |
| `READ_EXTERNAL_STORAGE` | Leer archivos | Bajo |

## Características de Seguridad

- ✅ **Datos Locales**: No se envían datos a servidores externos
- ✅ **Permisos Mínimos**: Solo los permisos necesarios
- ✅ **Validación**: Verificación de entrada de usuario
- ✅ **Encriptación**: Datos protegidos en almacenamiento local

## Mejoras Implementadas

### Antes (Problemas):
- ❌ Arquitectura híbrida confusa (Flutter + Android nativo)
- ❌ Funcionalidad limitada
- ❌ Interfaz básica
- ❌ Sin filtros avanzados
- ❌ Exportación limitada

### Después (Mejoras):
- ✅ Arquitectura Flutter pura
- ✅ Interfaz moderna y responsive
- ✅ Filtros por tipo de llamada
- ✅ Exportación a Excel mejorada
- ✅ Gestión de permisos robusta
- ✅ Manejo de errores mejorado
- ✅ Documentación completa

## Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño
- **Android SDK**: Plataforma móvil
- **Gradle**: Sistema de construcción



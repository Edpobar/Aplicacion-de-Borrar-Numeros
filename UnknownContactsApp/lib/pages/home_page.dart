import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:call_log/call_log.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import 'package:unknown_contacts_app/models/unknown_contact.dart';
import 'package:unknown_contacts_app/services/permission_service.dart';
import 'package:unknown_contacts_app/utils/app_utils.dart';

// --- FUNCIÓN AISLADA PARA PROCESAMIENTO Y CARGA DE DATOS ---
// Esta función se ejecuta en un Isolate (thread) separado para no bloquear la UI.
// AHORA INCLUYE LA OBTENCIÓN DE DATOS DE LOS PLUGINS.
Future<List<UnknownContact>> _fetchAndProcessContactsInBackground() async {
  final Iterable<Contact> savedContacts = await ContactsService.getContacts();
  final Iterable<CallLogEntry> callLogs = await CallLog.get();

  final Set<String> savedNumbers = <String>{};
  for (var contact in savedContacts) {
    if (contact.phones != null) {
      for (var phone in contact.phones!) {
        if (phone.value != null) {
          savedNumbers.add(normalizePhoneNumber(phone.value!));
        }
      }
    }
  }

  final unknownNumbersMap = <String, UnknownContact>{};
  for (var call in callLogs) {
    if (call.number != null && call.number!.isNotEmpty) {
      final normalizedNumber = normalizePhoneNumber(call.number!);
      if (!savedNumbers.contains(normalizedNumber)) {
        if (!unknownNumbersMap.containsKey(normalizedNumber)) {
          unknownNumbersMap[normalizedNumber] = UnknownContact(
            number: call.number!,
            lastCallDate: call.timestamp,
            callType: call.callType,
            duration: call.duration,
          );
        } else {
          if (call.timestamp != null &&
              unknownNumbersMap[normalizedNumber]!.lastCallDate != null &&
              call.timestamp! > unknownNumbersMap[normalizedNumber]!.lastCallDate!) {
            unknownNumbersMap[normalizedNumber] = UnknownContact(
              number: call.number!,
              lastCallDate: call.timestamp,
              callType: call.callType,
              duration: call.duration,
            );
          }
        }
      }
    }
  }

  final unknownContacts = unknownNumbersMap.values.toList();
  unknownContacts.sort((a, b) {
    if (a.lastCallDate == null && b.lastCallDate == null) return 0;
    if (a.lastCallDate == null) return 1;
    if (b.lastCallDate == null) return -1;
    return b.lastCallDate!.compareTo(a.lastCallDate!);
  });

  return unknownContacts;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UnknownContact> _unknownContacts = [];
  bool _isLoading = true; // Inicia en true para mostrar el loading al entrar
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    // Lanza la carga de contactos después de que el primer frame se haya renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUnknownContacts());
  }

  Future<void> _loadUnknownContacts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // 1. Pedir permisos en el Main Thread
      final granted = await PermissionService.requestRequiredPermissions(context);
      if (!granted) {
        if (mounted) {
          showAppSnackBar(context, "Permisos necesarios no concedidos.", backgroundColor: Colors.orange);
        }
        setState(() => _isLoading = false);
        return;
      }

      // 2. Ejecutar TODA la carga y procesamiento en el Isolate
      final processedContacts = await compute(_fetchAndProcessContactsInBackground, null);

      // 3. Actualizar la UI con los resultados
      if (mounted) {
        setState(() {
          _unknownContacts = processedContacts;
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, "Error al cargar contactos: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _exportToExcel() async {
    if (_unknownContacts.isEmpty) {
      showAppSnackBar(context, "No hay contactos para exportar",
          backgroundColor: Colors.orange);
      return;
    }

    setState(() => _isLoading =
        true); // Muestra el indicador de carga durante la exportación

    try {
      final excel = Excel.createExcel();
      final sheet = excel['Contactos Desconocidos'];

      // Encabezados
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Número');
      sheet.cell(CellIndex.indexByString('B1')).value =
          TextCellValue('Última Llamada');
      sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Tipo');
      sheet.cell(CellIndex.indexByString('D1')).value =
          TextCellValue('Duración (seg)');

      // Datos
      for (int i = 0; i < _unknownContacts.length; i++) {
        final contact = _unknownContacts[i];
        final row = i +
            2; // Las filas de Excel son 1-indexadas, los encabezados ocupan la fila 1

        sheet.cell(CellIndex.indexByString('A$row')).value =
            TextCellValue(contact.number);
        sheet.cell(CellIndex.indexByString('B$row')).value = TextCellValue(
            contact.lastCallDate != null
                ? formatCallDate(contact.lastCallDate!)
                : 'N/A');
        sheet.cell(CellIndex.indexByString('C$row')).value =
            TextCellValue(_getCallTypeString(contact.callType));
        sheet.cell(CellIndex.indexByString('D$row')).value =
            TextCellValue(contact.duration?.toString() ?? '0');
      }

      // Guardar archivo
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/contactos_desconocidos.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      // Compartir archivo
      if (context.mounted) {
        await Share.shareXFiles([XFile(file.path)],
            text: 'Contactos desconocidos exportados');
        showAppSnackBar(context, "Archivo exportado exitosamente",
            backgroundColor: Colors.green);
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Error al exportar: $e");
      }
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getCallTypeString(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return 'Entrante';
      case CallType.outgoing:
        return 'Saliente';
      case CallType.missed:
        return 'Perdida';
      default:
        return 'Desconocido';
    }
  }

  List<UnknownContact> _getFilteredContacts() {
    switch (_selectedFilter) {
      case 'Entrantes':
        return _unknownContacts
            .where((c) => c.callType == CallType.incoming)
            .toList();
      case 'Salientes':
        return _unknownContacts
            .where((c) => c.callType == CallType.outgoing)
            .toList();
      case 'Perdidas':
        return _unknownContacts
            .where((c) => c.callType == CallType.missed)
            .toList();
      default:
        return _unknownContacts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _getFilteredContacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos Desconocidos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadUnknownContacts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Filtrar:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    items: ['Todos', 'Entrantes', 'Salientes', 'Perdidas']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadUnknownContacts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _unknownContacts.isEmpty || _isLoading
                        ? null
                        : _exportToExcel,
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar Excel'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de contactos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredContacts.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron contactos desconocidos',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _getCallTypeColor(contact.callType),
                                child: Icon(
                                  _getCallTypeIcon(contact.callType),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                contact.number,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Última llamada: ${contact.lastCallDate != null ? formatCallDate(contact.lastCallDate!) : 'N/A'}'
                              ),
                              trailing: Text(
                                '${contact.duration ?? 0}s',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              onTap: () {
                                _showContactDetails(contact);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Color _getCallTypeColor(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blue;
      case CallType.missed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCallTypeIcon(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      default:
        return Icons.call;
    }
  }

  void _showContactDetails(UnknownContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del Contacto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Número: ${contact.number}'),
            const SizedBox(height: 8),
            Text(
                'Última llamada: ${contact.lastCallDate != null ? formatCallDate(contact.lastCallDate!) : 'N/A'}'),
            const SizedBox(height: 8),
            Text('Tipo: ${_getCallTypeString(contact.callType)}'),
            const SizedBox(height: 8),
            Text('Duración: ${contact.duration ?? 0} segundos'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
        ],
      ),
    );
  }
}

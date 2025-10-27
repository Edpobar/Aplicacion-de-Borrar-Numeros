import 'package:flutter/material.dart';
import 'package:unknown_contacts_app/pages/home_page.dart';
import 'package:unknown_contacts_app/utils/app_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- MEJORA DE SEGURIDAD ---
  // Las credenciales no deberían estar hardcodeadas en una aplicación real.
  // Para esta aplicación local, se recomienda eliminar el login si no es estrictamente necesario,
  // o implementar un sistema de autenticación local más robusto (ej. PIN, biométrico).
  // Por ahora, se mantiene para demostración, pero se advierte sobre la seguridad.
  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showAppSnackBar(context, "Por favor, complete todos los campos");
      return;
    }

    setState(() => _isLoading = true);

    // Simular verificación de credenciales
    await Future.delayed(const Duration(seconds: 1));

    if (_usernameController.text == "admin" &&
        _passwordController.text == "1234") {
      if (context.mounted) {
        // Asegura que el widget sigue montado
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      showAppSnackBar(context, "Credenciales inválidas");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_android,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Unknown Contacts Manager',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: "Usuario",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: "Contraseña",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Entrar",
                                    style: TextStyle(fontSize: 16))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

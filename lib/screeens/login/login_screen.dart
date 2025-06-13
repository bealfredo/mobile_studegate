import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // Usamos Stack para sobrepor o formulário ao fundo
      body: Stack(
        children: [
          // 1. WIDGET DE FUNDO
          // Container para a imagem de fundo com sobreposição de cor
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Certifique-se de ter uma imagem em assets/background.jpg
                image: AssetImage('assets/background.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Container para o filtro de cor azul sobre o fundo
          Container(
            color: const Color(0xFF003366).withOpacity(0.85),
          ),

          // 2. WIDGET DO FORMULÁRIO DE LOGIN
          Center(
            // SingleChildScrollView evita erros de overflow quando o teclado aparece
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // A coluna ocupa o mínimo de espaço
                    children: [
                      // Logo da instituição
                      // Certifique-se de ter o logo em assets/unitins_logo.png
                      Image.asset(
                        'assets/unitins_logo.png',
                        height: 60,
                      ),
                      const SizedBox(height: 16),

                      // Título
                      const Text(
                        'Portal do Aluno',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      const Text(
                        'Acesse utilizando seu e-mail institucional:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Campo de E-mail
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail (@unitins.br)',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Campo de Senha
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),
                      
                      // Link "Esqueci minha senha"
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implementar lógica para recuperar senha
                          },
                          child: const Text('Esqueci minha senha'),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Links de Ajuda e AVA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           TextButton(
                            onPressed: () {
                              // TODO: Implementar lógica de "Preciso de Ajuda"
                            },
                            child: const Text('Preciso de Ajuda'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Implementar lógica do link AVA
                            },
                            icon: const Icon(Icons.school_outlined, size: 20),
                            label: const Text('AVA (Turmas 2001-2008)'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botão Entrar
                      SizedBox(
                        width: double.infinity, // Ocupa toda a largura
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366), // Cor de fundo do botão
                            foregroundColor: Colors.white, // Cor do texto e do ícone
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          // A lógica de login que você já tinha continua aqui
                          onPressed: authProvider.isLoading ? null : () async {
                            final success = await authProvider.login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (!success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage ?? 'Erro ao fazer login'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text('Entrar', style: TextStyle(fontSize: 16)),
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
    );
  }
}
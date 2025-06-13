import 'package:flutter/material.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:mobile_studegate/services/aluno_service.dart';
import 'package:provider/provider.dart';

class EditarAlunoScreen extends StatefulWidget {
  const EditarAlunoScreen({Key? key}) : super(key: key);

  @override
  _EditarAlunoScreenState createState() => _EditarAlunoScreenState();
}

class _EditarAlunoScreenState extends State<EditarAlunoScreen> {
  
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _corRacaController;
  late TextEditingController _ufController;
  late TextEditingController _cidadeController;
  late TextEditingController _bairroController;
  late TextEditingController _cepController;
  late TextEditingController _logradouroController;
  late TextEditingController _numeroController;
  late TextEditingController _complementoController;
  late TextEditingController _emailPessoalController;
  late TextEditingController _telefoneCelular1Controller;
  late TextEditingController _telefoneCelular2Controller;
  late TextEditingController _telefoneFixoController;
  bool _isLoading = false;

  // Cores para estilização
  final Color _fieldBgColor = Colors.grey[100]!;
  final Color _fieldBorderColor = Colors.grey[300]!;
  final TextStyle _labelStyle = TextStyle(
    color: Colors.blue[800], 
    fontWeight: FontWeight.w500
  );
  
  @override
  void initState() {
    super.initState();
    // Inicializa os controllers
    _corRacaController = TextEditingController();
    _ufController = TextEditingController();
    _cidadeController = TextEditingController();
    _bairroController = TextEditingController();
    _cepController = TextEditingController();
    _logradouroController = TextEditingController();
    _numeroController = TextEditingController();
    _complementoController = TextEditingController();
    _emailPessoalController = TextEditingController();
    _telefoneCelular1Controller = TextEditingController();
    _telefoneCelular2Controller = TextEditingController();
    _telefoneFixoController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosDoUsuario();
    });
  }

  void _carregarDadosDoUsuario() {
    final aluno = Provider.of<AuthProvider>(context, listen: false).user;
    print('Carregando dados do usuário: ${aluno?.id}');
    if (aluno != null) {
      _corRacaController.text = aluno.corRaca ?? '';
      _ufController.text = aluno.uf ?? '';
      _cidadeController.text = aluno.cidade ?? '';
      _bairroController.text = aluno.bairro ?? '';
      _cepController.text = aluno.cep ?? '';
      _logradouroController.text = aluno.logradouro ?? '';
      _numeroController.text = aluno.numero ?? '';
      _complementoController.text = aluno.complemento ?? '';
      _emailPessoalController.text = aluno.emailPessoal ?? '';
      _telefoneCelular1Controller.text = aluno.telefoneCelular1 ?? '';
      _telefoneCelular2Controller.text = aluno.telefoneCelular2 ?? '';
      _telefoneFixoController.text = aluno.telefoneFixo ?? '';
    }
  }

  @override
  void dispose() {
    _corRacaController.dispose();
    _ufController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _emailPessoalController.dispose();
    _telefoneCelular1Controller.dispose();
    _telefoneCelular2Controller.dispose();
    _telefoneFixoController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final aluno = Provider.of<AuthProvider>(context, listen: false).user;
      if (aluno == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado'))
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Preparar os dados para atualização
      Map<String, dynamic> dadosAtualizados = {
        "corRaca": _corRacaController.text,
        "uf": _ufController.text,
        "cidade": _cidadeController.text,
        "bairro": _bairroController.text,
        "cep": _cepController.text,
        "logradouro": _logradouroController.text,
        "numero": _numeroController.text,
        "complemento": _complementoController.text,
        "emailPessoal": _emailPessoalController.text,
        "telefoneCelular1": _telefoneCelular1Controller.text,
        "telefoneCelular2": _telefoneCelular2Controller.text,
        "telefoneFixo": _telefoneFixoController.text,
      };

      try {
        final response = await updateAluno(aluno.id.toString(), dadosAtualizados);
        
        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 204) {
          // Atualiza os dados do aluno no AuthProvider
          // await Provider.of<AuthProvider>(context, listen: false).atualizarDadosUser(dadosAtualizados);
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informações atualizadas com sucesso!'))
          );
          // Navigator.pop(context, true);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar: ${response.statusCode} - ${response.body}'))
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $e'))
        );
      }
    }
  }

  // Método para criar um campo de texto com estilo e validação
  Widget _buildTextField({
    required TextEditingController controller, 
    required String label, 
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? customValidator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _labelStyle,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _fieldBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _fieldBorderColor),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            validator: customValidator ?? (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o(a) ${label.toLowerCase()}';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // Método para criar uma seção com título
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blue[800]!, width: 2),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REMATRÍCULA - Atualizar dados Pessoais',
          style: TextStyle(color: fontColor),
        ),
        backgroundColor: primaryColor,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: fontColor),
        //   onPressed: () {
        //     // Navigator.pop(context, false);
        //   },
        // ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final aluno = authProvider.user;
          
          if (aluno == null) {
            return const Center(child: Text('Usuário não encontrado'));
          }
          
          return _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Seção de informações pessoais
                    _buildSection('Informações Pessoais', [
                      // Row com imagem e dados pessoais
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem do aluno
                          // Container(
                          //   width: 100,
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.grey[300]!),
                          //     image: DecorationImage(
                          //       image: aluno.imagemPrincipal.isNotEmpty
                          //           ? NetworkImage(aluno.imagemPrincipal) as ImageProvider
                          //           : const AssetImage('assets/images/profile_placeholder.png'),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(width: 16),
                          
                          // Informações do perfil (não editáveis)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${aluno.nome} ${aluno.sobrenome}',
                                  style: const TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Matrícula: ${aluno.matricula}'),
                                const SizedBox(height: 4),
                                Text('CPF: ${aluno.cpf}'),
                                const SizedBox(height: 4),
                                Text('Login: ${aluno.login}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Campo Cor/Raça
                      _buildTextField(
                        controller: _corRacaController,
                        label: 'Cor/Raça',
                        hintText: 'Ex: Branca, Preta, Parda, Amarela, Indígena',
                      ),
                    ]),
                    
                    // Seção de Endereço
                    _buildSection('Endereço', [
                      // CEP e UF
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _cepController, 
                              label: 'CEP',
                              hintText: 'Ex: 00000-000',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: _buildTextField(
                              controller: _ufController, 
                              label: 'UF',
                              hintText: 'Ex: SP',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Cidade e Bairro
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _cidadeController, 
                              label: 'Cidade',
                              hintText: 'Ex: São Paulo',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _bairroController, 
                              label: 'Bairro',
                              hintText: 'Ex: Centro',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Logradouro
                      _buildTextField(
                        controller: _logradouroController, 
                        label: 'Logradouro',
                        hintText: 'Ex: Av. Paulista',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Número e Complemento
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildTextField(
                              controller: _numeroController, 
                              label: 'Número',
                              hintText: 'Ex: 1500',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _complementoController, 
                              label: 'Complemento',
                              hintText: 'Ex: Apto 42, Bloco B',
                            ),
                          ),
                        ],
                      ),
                    ]),
                    
                    // Seção de Contatos
                    _buildSection('Informações de Contato', [
                      // Email
                      _buildTextField(
                        controller: _emailPessoalController, 
                        label: 'Email Pessoal',
                        hintText: 'Ex: meuemail@exemplo.com',
                        keyboardType: TextInputType.emailAddress,
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o email pessoal';
                          }
                          
                          // Validação de email com Regex
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Informe um email válido';
                          }
                          
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Telefone Celular 1
                      _buildTextField(
                        controller: _telefoneCelular1Controller, 
                        label: 'Telefone Celular Principal',
                        hintText: 'Ex: (00) 00000-0000',
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Telefone Celular 2
                      _buildTextField(
                        controller: _telefoneCelular2Controller, 
                        label: 'Telefone Celular (Alternativo)',
                        hintText: 'Ex: (00) 00000-0000',
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Telefone Fixo
                      _buildTextField(
                        controller: _telefoneFixoController, 
                        label: 'Telefone Fixo',
                        hintText: 'Ex: (00) 0000-0000',
                        keyboardType: TextInputType.phone,
                      ),
                    ]),
                    
                    const SizedBox(height: 32),
                    
                    // Botão Salvar
                    ElevatedButton(
                      onPressed: _isLoading ? null : salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: fontColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SALVAR ALTERAÇÕES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
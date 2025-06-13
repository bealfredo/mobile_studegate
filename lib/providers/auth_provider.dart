import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_studegate/models/aluno.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_studegate/services/aluno_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  Aluno? _user;
  bool _isLoading = false;
  final String _boxName = 'auth_box';
  String? _errorMessage;

  Aluno? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    checkLoginStatus(); // <- aqui é mais seguro
  }

  // Limpar mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Inicializar Hive na main.dart
  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  // Salvar dados do usuário
  Future<void> _saveUserData() async {
    final box = await Hive.openBox(_boxName);
    
    if (_user == null) {
      await box.delete('user_data');
      return;
    }
    
    final userData = {
      'id': _user!.id,
      'matricula': _user!.matricula,
      'periodoAtual': _user!.periodoAtual,
      'matriculaPendente': _user!.matriculaPendente,
      'nome': _user!.nome,
      'sobrenome': _user!.sobrenome,
      'imagens': _user!.imagens,
      'imagemPrincipal': _user!.imagemPrincipal,
      'login': _user!.login,
      'cpf': _user!.cpf,
      'dataNascimento': _user!.dataNascimento.toIso8601String(),
      'cursos': _user!.cursos.map((curso) => curso.toJson()).toList(),
      'corRaca': _user!.corRaca,
      'uf': _user!.uf,
      'cidade': _user!.cidade,
      'bairro': _user!.bairro,
      'cep': _user!.cep,
      'logradouro': _user!.logradouro,
      'numero': _user!.numero,
      'complemento': _user!.complemento,
      'emailPessoal': _user!.emailPessoal,
      'telefoneCelular1': _user!.telefoneCelular1,
      'telefoneCelular2': _user!.telefoneCelular2,
      'telefoneFixo': _user!.telefoneFixo,
    };

    // final userData = _user!.toJson();
    
    // print('Salvando usuário no Hive: $_user');

    await box.put('user_data', userData);
  }
  
  // Carregar dados do usuário
  Future<void> checkLoginStatus() async {
    final box = await Hive.openBox(_boxName);
    final userData = box.get('user_data');
    
    if (userData != null) {
      try {
        // print('Usuário carregado do Hive: ${userData}');
        _user = Aluno.fromJson(userData);
      } catch (e) {
        // print('Erro ao carregar usuário do Hive: $e');
        _user = null;
      }
    } else {
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }
  
  // Métodos login e logout
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; // Limpa a mensagem de erro anterior
    notifyListeners();

    try {
      // Chama o serviço de login com os parâmetros na ordem correta
      http.Response response = await loginStudent(email, password);

      // print('Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      // Se recebeu uma resposta com corpo
      if (response.body.isNotEmpty) {
        try {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          
          if (response.statusCode >= 400) {
            _isLoading = false;
            
            // Extrai a mensagem de erro específica do campo auth
            if (responseData.containsKey('errors') && 
                responseData['errors'] is List && 
                responseData['errors'].isNotEmpty) {
              
              for (final error in responseData['errors']) {
                if (error['fieldName'] == 'auth') {
                  _errorMessage = error['message']; // "Login ou senha inválidos"
                  break;
                }
              }
            }
            
            // Se não encontrou mensagem específica, usa a mensagem geral
            if (_errorMessage == null && responseData.containsKey('message')) {
              _errorMessage = responseData['message']; // "Erro de validação."
            }
            
            // Mensagem padrão se nenhuma mensagem foi encontrada
            _errorMessage ??= 'Erro ao fazer login. Tente novamente.';
            
            // print('Erro de autenticação: $_errorMessage');
            notifyListeners();
            return false;
          }
          
          // Login bem-sucedido - processa os dados do usuário
          try {
            _user = Aluno.fromJson(responseData);
            await _saveUserData();
            _isLoading = false;
            notifyListeners();
            return true;
          } catch (e) {
            _isLoading = false;
            _errorMessage = 'Erro ao processar dados do usuário: $e';
            notifyListeners();
            return false;
          }
          
        } catch (e) {
          // Erro ao processar o JSON
          _isLoading = false;
          _errorMessage = 'Erro ao processar resposta do servidor';
          // print('Erro ao processar JSON: $e');
          notifyListeners();
          return false;
        }
      } 
      // Resposta sem corpo
      else if (response.statusCode >= 400) {
        _isLoading = false;
        _errorMessage = 'Erro no servidor (${response.statusCode})';
        notifyListeners();
        return false;
      }
      
      // Chegou aqui, mas não deveria (caso inesperado)
      _isLoading = false;
      _errorMessage = 'Resposta inesperada do servidor';
      notifyListeners();
      return false;
      
    } catch (e) {
      // Erro de conexão ou outro erro inesperado
      _isLoading = false;
      _errorMessage = 'Erro de conexão: verifique sua internet';
      // print('Erro de conexão: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    await _saveUserData();
    notifyListeners();
  }
}
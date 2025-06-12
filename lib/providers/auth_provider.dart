import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_studegate/models/aluno.dart';

class AuthProvider extends ChangeNotifier {
  Aluno? _user;
  bool _isLoading = false;
  final String _boxName = 'auth_box';

  Aluno? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

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
      'login': _user!.login,
      'cpf': _user!.cpf,
      'dataNascimento': _user!.dataNascimento.toIso8601String(),


    };
    
    await box.put('user_data', userData);
  }
  
  // Carregar dados do usuário
  Future<void> checkLoginStatus() async {
    final box = await Hive.openBox(_boxName);
    final userData = box.get('user_data');
    
    if (userData != null) {
      _user = Aluno(
        id: userData['id'],
        matricula: userData['matricula'],
        periodoAtual: userData['periodoAtual'],
        matriculaPendente: userData['matriculaPendente'],
        nome: userData['nome'],
        sobrenome: userData['sobrenome'],
        login: userData['login'],
        cpf: userData['cpf'],
        dataNascimento: DateTime.parse(userData['dataNascimento']),
      );
      notifyListeners();
    }
  }
  
  // Métodos login e logout
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));
      
      _user = Aluno(
        id: '123',
        matricula: '2023001',
        periodoAtual: 1,
        matriculaPendente: false,
        nome: 'João',
        sobrenome: 'Silva',
        login: email,
        cpf: '12345678901',
        dataNascimento: DateTime(2000, 1, 1),
      );
      
      await _saveUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
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
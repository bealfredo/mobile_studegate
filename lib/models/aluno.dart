import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/curso.dart';

class Aluno {
  int id;
  // DateTime createdAt;
  // String title; 
  // String creator;
  // String type;
  // List<dynamic> genre;
  // String synopsis;
  // DateTime releaseDate;
  // IconData icon;
  // double averageRating;
  // int reviewCount = 0;
  int periodoAtual;
  String matricula;
  bool matriculaPendente;
  String nome;
  String sobrenome;
  List<String> imagens;
  String imagemPrincipal;
  String login;
  String cpf;
  DateTime dataNascimento;
  List<Curso> cursos = [];
  
  Aluno({

    required this.id,
    required this.periodoAtual,
    required this.matricula,
    required this.matriculaPendente,
    required this.nome,
    required this.sobrenome,
    required this.imagens,
    required this.imagemPrincipal,
    required this.login,
    required this.cpf,
    required this.dataNascimento,
    required this.cursos,
  });

  factory Aluno.fromJson(dynamic jsonData) {
  // Garantir que estamos trabalhando com um Map
  final json = jsonData as Map;
  
  return Aluno(
    id: json['id'],
    periodoAtual: json['periodoAtual'],
    matricula: json['matricula'],
    matriculaPendente: json['matriculaPendente'] ?? false,
    nome: json['nome'],
    sobrenome: json['sobrenome'],
    imagens: List<String>.from(json['imagens'] ?? []),
    imagemPrincipal: json['imagemPrincipal'] ?? '',
    login: json['login'],
    cpf: json['cpf'],
    dataNascimento: json['dataNascimento'] is DateTime 
        ? json['dataNascimento'] 
        : DateTime.parse(json['dataNascimento']),
    cursos: json['cursos'] != null 
        ? (json['cursos'] as List).map((c) => Curso.fromJson(c)).toList() 
        : [],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'periodoAtual': periodoAtual,
      'matricula': matricula,
      'matriculaPendente': matriculaPendente,
      'nome': nome,
      'sobrenome': sobrenome,
      'imagens': imagens,
      'imagemPrincipal': imagemPrincipal,
      'login': login,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'cursos': cursos.map((curso) => curso.toJson()).toList(),
    };
  }
}
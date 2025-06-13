import 'package:flutter/material.dart';

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
    required this.dataNascimento
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'],
      periodoAtual: json['periodoAtual'],
      matricula: json['matricula'],
      matriculaPendente: json['matriculaPendente'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      imagens: List<String>.from(json['imagens'] ?? []),
      imagemPrincipal: json['imagemPrincipal'] ?? '',
      login: json['login'],
      cpf: json['cpf'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
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
    };
  }
}
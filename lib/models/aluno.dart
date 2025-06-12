import 'package:flutter/material.dart';

class Aluno {
  String id;
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
  String login;
  String cpf;
  DateTime dataNascimento;
  
  Aluno({
    // required this.id,
    // required this.createdAt,
    // required this.title,
    // required this.creator,
    // required this.type,
    // required this.genre,
    // required this.synopsis,
    // required this.releaseDate,
    // this.averageRating = 0.0,
    // this.reviewCount = 0,
    required this.id,
    required this.periodoAtual,
    required this.matricula,
    required this.matriculaPendente,
    required this.nome,
    required this.sobrenome,
    required this.login,
    required this.cpf,
    required this.dataNascimento
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      // id: json['id'],
      // createdAt: DateTime.parse(json['createdAt']),
      // title: json['title'],
      // creator: json['creator'],
      // type: json['type'],
      // genre: json['genre'],
      // synopsis: json['synopsis'],
      // releaseDate: DateTime.parse(json['releaseDate']),
      id: json['id'],
      periodoAtual: json['periodoAtual'],
      matricula: json['matricula'],
      matriculaPendente: json['matriculaPendente'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      login: json['login'],
      cpf: json['cpf'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'createdAt': createdAt.toIso8601String(),
      // 'title': title,
      // 'creator': creator,
      // 'type': type,
      // 'genre': genre,
      // 'synopsis': synopsis,
      // 'releaseDate': releaseDate.toIso8601String(),
      'id': id,
      'periodoAtual': periodoAtual,
      'matricula': matricula,
      'matriculaPendente': matriculaPendente,
      'nome': nome,
      'sobrenome': sobrenome,
      'login': login,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
    };
  }
}
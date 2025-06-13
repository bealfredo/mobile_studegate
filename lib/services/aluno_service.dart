import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_studegate/main.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;


// Future<dynamic> getMedias() async {
//   var url = Uri.parse('$baseUrlApi/media');

//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     var data = json.decode(utf8.decode(response.bodyBytes));
//     List<Media> medias = (data as List).map((item) => Media.fromJson(item)).toList();
//     return medias;
//   } else {
//     print("Erro ao fazer a requisição: ${response.statusCode}");
//     return [];
//   }
// }

// Future<http.Response> postMedia(Map<String, dynamic> media) async {
//   var url = Uri.parse('$baseUrlApi/media');
//   var response = await http.post(
//     url,
//     body: json.encode(media),
//     headers: {'Content-Type': 'application/json'},
//   );
//   return response;
// }

// Future<http.Response> deleteMedia(String id) async {
//   var url = Uri.parse('$baseUrlApi/media/$id');
//   var response = await http.delete(url);
//   return response;
// }

// Future<http.Response> updateMedia(String id, Map<String, dynamic> media) async {
//   var url = Uri.parse('$baseUrlApi/media/$id');
//   var response = await http.put(
//     url,
//     body: json.encode(media),
//     headers: {'Content-Type': 'application/json'},
//   );
//   return response;
// }

Future<http.Response> loginStudent(String login, String senha) async {
  final url = Uri.parse('$baseUrlApi/auth');
  
  // Corpo da requisição conforme o formato mostrado no curl
  final requestBody = jsonEncode({
    'login': login,
    'senha': senha,
    'idTipoPerfil': 5  // Valor fixo para perfil de aluno
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: requestBody,
    );

    return response;
  } catch (e) {
    // Repassando a exceção para ser tratada no AuthProvider
    rethrow;
  }
}

// Exemplo específico com os campos da chamada CURL
// Future<bool> atualizarInformacoesContato(int alunoId) async {
Future<http.Response> updateAluno(String id, Map<String, dynamic> alunoContato) async {


  // Validar e processar os dados do aluno
  // Os campos são baseados no modelo necessário para atualizar informações de contato
  // O mapa alunoContato será sobrescrito com os dados para a atualização
  alunoContato = {
    "corRaca": alunoContato["corRaca"] ?? alunoContato["corRaca"],
    "uf": alunoContato["uf"] ?? alunoContato["uf"],
    "cidade": alunoContato["cidade"] ?? alunoContato["cidade"],
    "bairro": alunoContato["bairro"] ?? alunoContato["bairro"],
    "cep": alunoContato["cep"] ?? alunoContato["cep"],
    "logradouro": alunoContato["logradouro"] ?? alunoContato["logradouro"],
    "numero": alunoContato["numero"] ?? alunoContato["numero"],
    "complemento": alunoContato["complemento"] ?? alunoContato["complemento"],
    "emailPessoal": alunoContato["emailPessoal"] ?? alunoContato["emailPessoal"],
    "telefoneCelular1": alunoContato["telefoneCelular1"] ?? alunoContato["telefoneCelular1"],
    "telefoneCelular2": alunoContato["telefoneCelular2"] ?? alunoContato["telefoneCelular2"],
    "telefoneFixo": alunoContato["telefoneFixo"] ?? alunoContato["telefoneFixo"]
  };
  

  final url = Uri.parse('$baseUrlApi/alunos/$id');
  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'accept': '*/*',
    },
    body: jsonEncode(alunoContato),
  );

  return response;

}


Future<http.Response> uploadImagemAluno(String userId, XFile imagem) async {
  final uri = Uri.parse('$baseUrlApi/alunos/$userId/upload/imagem');

  var request = http.MultipartRequest('PATCH', uri); // Corrigido de POST para PATCH

  if (kIsWeb) {
    // Web: lê os bytes do arquivo e envia como multipart com nome do campo "imagem"
    var byteData = await imagem.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'imagem', // nome do campo conforme Swagger
      byteData,
      filename: imagem.name,
      contentType: MediaType('image', 'png'), // ajuste o tipo se necessário
    );
    request.files.add(multipartFile);
  } else {
    // Android/iOS: usa fromPath com nome do campo correto
    var multipartFile = await http.MultipartFile.fromPath(
      'imagem', // nome do campo conforme Swagger
      imagem.path,
      filename: imagem.name,
    );
    request.files.add(multipartFile);
  }

  final streamedResponse = await request.send();
  return http.Response.fromStream(streamedResponse);
}

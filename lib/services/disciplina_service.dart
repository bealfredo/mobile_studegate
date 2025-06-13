import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/models/disciplina.dart';

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

// Future<http.Response> findByCurso(int idCurso) async {
//   final url = Uri.parse('$baseUrlApi/alunos/disciplinas/findByCurso/$idCurso');
  
//   try {
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'accept': '*/*',
//       },
//     );

//     return response;
//   } catch (e) {
//     // Repassando a exceção para ser tratada no AuthProvider
//     rethrow;
//   }
// }


Future<List<Disciplina>> getDisciplinasByCurso(int cursoId) async {
  var url = Uri.parse('http://localhost:8080/alunos/disciplinas/findByCurso/$cursoId');
  
  try {
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      List<Disciplina> disciplinas = (data as List).map((item) => Disciplina.fromJson(item)).toList();
      return disciplinas;
    } else {
      print("Erro ao fazer a requisição: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print('Erro no serviço de disciplinas: $e');
    return [];
  }
}

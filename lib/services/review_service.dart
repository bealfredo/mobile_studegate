
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reviewall_mobile/models/review_model.dart';

import 'package:reviewall_mobile/main.dart';


Future<dynamic> getReviews() async {
  var url = Uri.parse('$baseUrlApi/review');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(utf8.decode(response.bodyBytes));
    List<Review> reviews = (data as List).map((item) => Review.fromJson(item)).toList();
    return reviews;
  } else {
    print("Erro ao fazer a requisição: ${response.statusCode}");
  }
}

Future<http.Response> deleteReview(String id) async {
  var url = Uri.parse('$baseUrlApi/review/$id');
  var response = await http.delete(url);
  return response;
}

Future<http.Response> postReview(Map<String, dynamic> review) async {
  var url = Uri.parse('$baseUrlApi/review');
  var response = await http.post(
    url,
    body: json.encode(review),
    headers: {'Content-Type': 'application/json'},
  );
  return response;
}

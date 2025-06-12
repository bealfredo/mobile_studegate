import 'package:flutter/material.dart';

class Media {
  String id;
  DateTime createdAt;
  String title; 
  String creator;
  String type;
  List<dynamic> genre;
  String synopsis;
  DateTime releaseDate;
  IconData icon;
  double averageRating;
  int reviewCount = 0;
  
  Media({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.creator,
    required this.type,
    required this.genre,
    required this.synopsis,
    required this.releaseDate,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  }) : icon = _getIconForType(type);

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      creator: json['creator'],
      type: json['type'],
      genre: json['genre'],
      synopsis: json['synopsis'],
      releaseDate: DateTime.parse(json['releaseDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'creator': creator,
      'type': type,
      'genre': genre,
      'synopsis': synopsis,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }

  static IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'filme':
        return Icons.movie;
      case 'série':
        return Icons.live_tv;
      case 'documentário':
        return Icons.videocam;
      case 'anime':
        return Icons.animation;
      case 'desenho animado':
        return Icons.smart_toy;
      case 'game':
        return Icons.videogame_asset;
      case 'livro':
        return Icons.menu_book;
      case 'podcast':
        return Icons.podcasts;
      case 'música':
        return Icons.music_note;
      case 'outro':
        return Icons.category;
      default:
        return Icons.device_unknown;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/review_model.dart';
import 'package:mobile_studegate/models/media_model.dart';
import 'package:mobile_studegate/screeens/media/media_details_screen.dart';
import 'package:mobile_studegate/services/media_service.dart';
import 'package:mobile_studegate/services/review_service.dart';


class MediaList extends StatefulWidget {
  const MediaList({super.key});

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  late Future<List<Media>> _mediasFuture;

  @override
  void initState() {
    super.initState();
    _mediasFuture = fetchMedias();
  }

  Future<List<Media>> fetchMedias() async {
    try {
      List<Media> medias = await getMedias();

      List<Review> allReviews = await getReviews();

      for (var media in medias) {
      var mediaReviews = allReviews.where((review) => review.mediaId == media.id).toList();

      if (mediaReviews.isNotEmpty) {
        // Calcular a média
        double sum = mediaReviews.fold(0.0, (sum, review) => sum + review.rating);
        media.averageRating = sum / mediaReviews.length;
      } else {
        media.averageRating = 0.0;
      }

      // Salvar a quantidade de resenhas
      media.reviewCount = mediaReviews.length;
      }

      // Ordenar por data de criação
      medias.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return medias;
    } catch (e) {
      print("Erro ao buscar mídias e calcular médias: $e");
      return [];
    }
  }

  void _reloadMediaList() {
    setState(() {
      _mediasFuture = fetchMedias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botão de recarregar no topo
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: _reloadMediaList,
            icon: const Icon(Icons.refresh),
            label: const Text('Recarregar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Media>>(
            future: _mediasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar mídias'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhuma mídia encontrada'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    return MediaListItem(
                      snapshot.data![index],
                      onMediaUpdated: _reloadMediaList,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class MediaListItem extends StatelessWidget {
  final Media media;
  final VoidCallback onMediaUpdated;

  const MediaListItem(this.media, {required this.onMediaUpdated, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: media.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: ' #${media.id}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black54),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${media.type}'),
            // Text('Ano de Lançamento: ${media.releaseDate.year}'),
            Text('Resenhas: ${media.reviewCount}'),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: media.genre.map<Widget>((genre) {
                return Chip(
                  label: Text(genre),
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
          ],
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(media.icon, size: 30),
            Text(
              media.averageRating > 0 ? media.averageRating.toStringAsFixed(1) : "N/A",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => MediaDetailScaffold(media.id),
              ),
            );

            if (result == true) {
              onMediaUpdated();
            }
          },
        ),
      ),
    );
  }
}


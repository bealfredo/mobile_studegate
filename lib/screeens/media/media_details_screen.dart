import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/review_model.dart';
import 'package:mobile_studegate/widgets/review_list.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/models/media_model.dart';
import 'package:mobile_studegate/screeens/media/media_add_screen.dart';
import 'package:mobile_studegate/screeens/review/review_add_screen.dart';
import 'package:mobile_studegate/services/media_service.dart';
import 'package:mobile_studegate/services/review_service.dart';

// Visualizar mídia
class MediaDetailScaffold extends StatefulWidget {
  final String mediaId;

  const MediaDetailScaffold(this.mediaId, {super.key});

  @override
  State<MediaDetailScaffold> createState() => _MediaDetailScaffoldState();
}

class _MediaDetailScaffoldState extends State<MediaDetailScaffold> {
  Key _reviewListKey = UniqueKey();
  late Future<Media> _mediaFuture;
  late List<Review> _filteredReviews;
  bool _isLoading = true;
  late Media _media;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _fetchMediaDetails();
  }

  // Função para buscar os detalhes da mídia pelo ID
  Future<Media> _fetchMediaDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar todas as mídias
      List<Media> allMedias = await getMedias();

      // Encontrar a mídia com o ID correspondente
      Media media = allMedias.firstWhere(
        (m) => m.id == widget.mediaId,
        orElse: () => throw Exception('Mídia não encontrada'),
      );

      // Buscar todas as resenhas
      List<Review> allReviews = await getReviews();

      // Filtrar as resenhas para esta mídia
      _filteredReviews = allReviews.where((review) => review.mediaId == media.id).toList();

      // Calcular a média das avaliações para esta mídia
      if (_filteredReviews.isNotEmpty) {
        double sum = _filteredReviews.fold(0.0, (sum, review) => sum + review.rating);
        media.averageRating = sum / _filteredReviews.length;
      } else {
        media.averageRating = 0.0;
      }

      // Atualizar estado
      if (mounted) {
        setState(() {
          _isLoading = false;
          _media = media;
        });
      }

      return media;
    } catch (e) {
      print("Erro ao buscar detalhes da mídia: $e");

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      throw e;
    }
  }

  // Função para atualizar os dados da mídia
  Future<void> _refreshMediaDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _mediaFuture = _fetchMediaDetails();
      _media = await _mediaFuture;
      _reviewListKey = UniqueKey();
    } catch (e) {
      print("Erro ao atualizar detalhes da mídia: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading ? Text('Carregando...') : Text(_media.title),
        backgroundColor: primaryColor,
        foregroundColor: fontColor,
        iconTheme: IconThemeData(color: fontColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<Media>(
            future: _mediaFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar a mídia: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text(''));
                // return Center(child: Text('Mídia não encontrada'));
              } else {
                _media = snapshot.data!;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CurrentMedia(
                          media: _media,
                          filteredReviews: _filteredReviews,
                          onMediaUpdated: _refreshMediaDetails,
                          onDeleted: () {
                            // navigate back to the previous screen
                            Navigator.pop(context, true);
                          }
                        ),
                        const SizedBox(height: 16),

                        // Título da seção de resenhas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Resenhas (${_filteredReviews.length})',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Lista de reviews
                        ReviewListWidget(
                          key: _reviewListKey,
                          reviews: _filteredReviews,
                          onReviewDeleted: _refreshMediaDetails,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),

      // Botão flutuante para adicionar resenha
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormAddReviewScaffold(media: _media),
                  ),
                );

                if (result == true) {
                  await _refreshMediaDetails();
                }
              },
                backgroundColor: primaryColorLight,
                foregroundColor: fontColor,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Resenha'),
            ),
    );
  }
}

class CurrentMedia extends StatelessWidget {
  final Media media;
  final List<Review> filteredReviews;
  final VoidCallback? onMediaUpdated;
  final VoidCallback? onDeleted;
  

  const CurrentMedia({required this.media, required this.filteredReviews, this.onMediaUpdated, this.onDeleted, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(
            media.icon,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),


        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: media.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: ' #${media.id}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        
        // Média de avaliações
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 4),
            Text(
              media.averageRating > 0 
                ? "${media.averageRating.toStringAsFixed(1)}/10"
                : "Sem avaliações",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: media.averageRating >= 7 ? Colors.green : 
                      media.averageRating >= 4 ? Colors.amber : 
                      media.averageRating > 0 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row of buttons
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormAddMediaScaffold(media: media),
                  ),
                );

                if (result == true) {
                  if (onMediaUpdated != null) {
                    onMediaUpdated!();
                  }
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
            ),

            const SizedBox(width: 8),

            ElevatedButton.icon(
              onPressed: () async {
                // Verificação de resenhas existente
                if (filteredReviews.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Não é possível deletar a mídia com resenhas associadas')),
                  );
                  return;
                }

                final currentContext = context;
                
                final shouldDelete = await showDialog<bool>(
                  context: currentContext,
                  builder: (dialogContext) => AlertDialog(
                    title: Text('Confirmar exclusão'),
                    content: Text('Deseja realmente excluir "${media.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                );
              
                if (!currentContext.mounted) return;
                if (shouldDelete != true) return;

                try {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    SnackBar(content: Text('Excluindo mídia...'), duration: Duration(seconds: 1)),
                  );
                  
                  final response = await deleteMedia(media.id);
                  
                  if (!currentContext.mounted) return;
                  
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      SnackBar(content: Text('Mídia deletada com sucesso!')),
                    );
                    
                    Navigator.of(currentContext).pop(true);
                  } else {
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      SnackBar(content: Text('Erro ao deletar mídia: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  if (!currentContext.mounted) return;
                  
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    SnackBar(content: Text('Erro ao deletar mídia: $e')),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text('Deletar'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Informações detalhadas
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Synopsis
                  Text(
                    'Sinopse:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media.synopsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Genre
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
                  const SizedBox(height: 16), 
                  
                  // Type
                  Text(
                    'Tipo: ${media.type}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Creator
                  Text(
                    'Criador: ${media.creator}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                
                  // Release Date
                  Text(
                    'Data de Lançamento: ${media.releaseDate.day.toString().padLeft(2, '0')}/'
                    '${media.releaseDate.month.toString().padLeft(2, '0')}/'
                    '${media.releaseDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
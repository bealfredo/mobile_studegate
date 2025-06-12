import 'package:flutter/material.dart';

import 'package:reviewall_mobile/models/review_model.dart';

import 'package:reviewall_mobile/services/review_service.dart';

class ReviewListWidget extends StatelessWidget {
  final List<Review> reviews;
  final VoidCallback? onReviewDeleted;

  const ReviewListWidget({super.key, required this.reviews, this.onReviewDeleted});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Center(child: Text('Nenhuma resenha encontrada para esta mídia'));
    } else {
      // Ordena as resenhas em ordem decrescente pela data de criação
      List<Review> sortedReviews = List.from(reviews)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return ReviewList(reviews: sortedReviews, onReviewDeleted: onReviewDeleted);
    }
  }
}

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final VoidCallback? onReviewDeleted;

  const ReviewList({required this.reviews, this.onReviewDeleted, super.key});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Column(
        children: [
          Center(child: Text('Nenhuma resenha encontrada')),
          SizedBox(height: 80),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 80),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ReviewListItem(
            reviews[index],
            onReviewDeleted: onReviewDeleted,
          );
        },
      );
    }
  }
}

class ReviewListItem extends StatelessWidget {
  final Review review;
  final VoidCallback? onReviewDeleted;

  const ReviewListItem(this.review, {this.onReviewDeleted, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(review.comment),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('${review.createdAt.day.toString().padLeft(2, '0')}/${review.createdAt.month.toString().padLeft(2, '0')}/${review.createdAt.year} às ${review.createdAt.hour.toString().padLeft(2, '0')}:${review.createdAt.minute.toString().padLeft(2, '0')} - Por ${review.user}'),
          ],
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message),
            SizedBox(height: 4),
            Text(
              review.rating.toStringAsFixed(1),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            final currentContext = context;
            
            // Mostrar diálogo de confirmação
            final shouldDelete = await showDialog<bool>(
              context: currentContext,
              builder: (dialogContext) => AlertDialog(
                title: Text('Confirmar exclusão'),
                content: Text('Deseja realmente excluir esta resenha?'),
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
            
            if (!currentContext.mounted || shouldDelete != true) return;
            
            try {
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(content: Text('Excluindo resenha...'), duration: Duration(seconds: 1)),
              );
              
              await deleteReview(review.id);
              
              if (!currentContext.mounted) return;
              
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(content: Text('Resenha excluída com sucesso!')),
              );
              
              if (onReviewDeleted != null) {
                onReviewDeleted!();
              }
            } catch (e) {
              if (!currentContext.mounted) return;
              
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(
                  content: Text('Erro ao excluir resenha: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}


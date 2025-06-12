import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_studegate/models/media_model.dart';

import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/services/review_service.dart';

class FormAddReviewScaffold extends StatefulWidget {
  final Media media;
  
  const FormAddReviewScaffold({super.key, required this.media});

  @override
  State<FormAddReviewScaffold> createState() => _FormAddReviewScaffoldState();
}

class _FormAddReviewScaffoldState extends State<FormAddReviewScaffold> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para os campos de texto
  final _userController = TextEditingController();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    // Liberar recursos dos controladores
    _userController.dispose();
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _salvarResenha() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final review = {
          'mediaId': widget.media!.id,
          'user': _userController.text,
          'rating': double.parse(_ratingController.text),
          'comment': _commentController.text,
          'createdAt': DateTime.now().toIso8601String(), // Gera a data atual automaticamente
        };

        var response = await postReview(review);

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Resenha adicionada com sucesso!')),
            );
            Navigator.pop(context, true); // Retorna true para indicar sucesso
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao salvar resenha: ${response.statusCode}')),
            );

            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar resenha: $e')),
          );

          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Resenha', style: TextStyle(color: fontColor)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Exibição da mídia no topo
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(widget.media.icon, size: 50),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.media.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Tipo: ${widget.media.type}'),
                                Wrap(
                                  spacing: 4,
                                  children: widget.media.genre.map((genre) => 
                                    Chip(
                                      label: Text(genre),
                                      labelStyle: TextStyle(fontSize: 12),
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    )
                                  ).toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Formulário
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Autor',
                            hintText: 'Informe o nome do autor da resenha',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o nome do autor';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _ratingController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Nota',
                            hintText: 'Informe a nota (máximo 10)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a nota';
                            }
                            final nota = double.tryParse(value);
                            if (nota == null) {
                              return 'Valor inválido';
                            }
                            if (nota > 10) {
                              return 'A nota deve ser no máximo 10';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: 'Comentário',
                            hintText: 'Informe sua opinião sobre a mídia',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe um comentário';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        
                        ElevatedButton(
                          onPressed: _salvarResenha,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: fontColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: secondaryColor,
                          ),
                          child: Text(
                            'SALVAR',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/models/media_model.dart';
import 'package:mobile_studegate/services/media_service.dart';

// Lista de gêneros
final List<String> sugestGeneros = [
  'Ação',
  'Anime',
  'Asiáticos',
  'Aventura',
  'Brasileiros',
  'Britânicos',
  'Ciência e natureza',
  'Comédia',
  'Drama',
  'Esportes',
  'EUA',
  'Ficção científica e fantasia',
  'Mistério',
  'Mulheres em ação',
  'Novelas',
  'Para as crianças',
  'Policiais',
  'Reality e talk shows',
  'Romance',
  'Séries documentais',
  'Suspense',
  'Teen',
  'Terror',
  'Histórico',
  'Biografia',
  'Musical',
  'Guerra',
  'Outro'
];

// Lista de tipos de mídia
final List<String> sugestTypes = [
  'Filme',
  'Série',
  'Documentário',
  'Anime',
  'Desenho animado',
  'Game',
  'Livro',
  'Podcast',
  'Música',
  'Outro'
];

// Formulário para adicionar uma nova mídia
class FormAddMediaScaffold extends StatefulWidget {
  final Media? media; // Media opcional para edição
  
  const FormAddMediaScaffold({this.media, super.key});

  @override
  State<FormAddMediaScaffold> createState() => _FormAddMediaScaffoldState();
}

class _FormAddMediaScaffoldState extends State<FormAddMediaScaffold> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para os campos de texto
  final _titleController = TextEditingController();
  final _creatorController = TextEditingController();
  final _typeController = TextEditingController();
  final _genreController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _releaseDateController = TextEditingController();
  
  final List<String> _generosSelecionados = [];
  DateTime? _dataLancamento;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    
    // Verificar se é modo de edição e preencher os campos
    if (widget.media != null) {
      _isEditMode = true;
      _titleController.text = widget.media!.title;
      _creatorController.text = widget.media!.creator;
      _typeController.text = widget.media!.type;
      _synopsisController.text = widget.media!.synopsis;
      
      // Preencher a data
      _dataLancamento = widget.media!.releaseDate;
      _releaseDateController.text = 
        "${_dataLancamento!.day.toString().padLeft(2, '0')}/"
        "${_dataLancamento!.month.toString().padLeft(2, '0')}/"
        "${_dataLancamento!.year}";
      
      // Preencher os gêneros
      _generosSelecionados.addAll(widget.media!.genre.map((g) => g.toString()));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _creatorController.dispose();
    _typeController.dispose();
    _genreController.dispose();
    _synopsisController.dispose();
    _releaseDateController.dispose();
    super.dispose();
  }

  Future<void> _salvarMidia() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final mediaDados = {
          'title': _titleController.text,
          'creator': _creatorController.text,
          'type': _typeController.text,
          'genre': _generosSelecionados,
          'synopsis': _synopsisController.text,
          'releaseDate': _dataLancamento!.toIso8601String(),
        };
        
        http.Response response;
        
        if (_isEditMode) {
          // Adicionar ID e createdAt para atualização
          mediaDados['id'] = widget.media!.id;
          mediaDados['createdAt'] = widget.media!.createdAt.toIso8601String();
          response = await updateMedia(widget.media!.id, mediaDados);
        } else {
          // Para nova mídia adicionar createdAt
          mediaDados['createdAt'] = DateTime.now().toIso8601String();
          response = await postMedia(mediaDados);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isEditMode ? 'Mídia atualizada com sucesso!' : 'Mídia adicionada com sucesso!')),
            );
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao salvar mídia: ${response.statusCode}')),
            );
            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar mídia: $e')),
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
        title: Text(
          _isEditMode ? 'Editar Mídia' : 'Adicionar Mídia',
          style: TextStyle(color: fontColor),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fontColor),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        hintText: 'Ex: Interestelar',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o título';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _creatorController,
                      decoration: InputDecoration(
                        labelText: 'Criador',
                        hintText: 'Ex: Christopher Nolan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o criador';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      value: _typeController.text.isEmpty ? null : _typeController.text,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Selecione o tipo',
                        border: OutlineInputBorder(),
                      ),
                      items: sugestTypes.map((String tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(tipo),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _typeController.text = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o tipo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return AlertDialog(
                                      title: Text('Selecione os Gêneros'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: sugestGeneros.map((String genero) {
                                            return CheckboxListTile(
                                              title: Text(genero),
                                              value: _generosSelecionados.contains(genero),
                                              onChanged: (bool? value) {
                                                setDialogState(() {
                                                  if (value == true) {
                                                    _generosSelecionados.add(genero);
                                                  } else {
                                                    _generosSelecionados.remove(genero);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            setState(() {}); 
                          },
                          icon: Icon(Icons.category),
                          label: Text('Selecionar Gêneros'),
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        
                        SizedBox(height: 8),
                        
                        _generosSelecionados.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Selecione pelo menos um gênero',
                                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                                ),
                              )
                            : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _generosSelecionados.map((genero) {
                                  return Chip(
                                    label: Text(genero),
                                    backgroundColor: Colors.grey[200],
                                    deleteIcon: Icon(Icons.cancel, size: 18),
                                    onDeleted: () {
                                      setState(() {
                                        _generosSelecionados.remove(genero);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                        
                        // Campo oculto para validação
                        Opacity(
                          opacity: 0,
                          child: TextFormField(
                            controller: _genreController,
                            validator: (value) {
                              if (_generosSelecionados.isEmpty) {
                                return 'Selecione pelo menos um gênero';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _synopsisController,
                      decoration: InputDecoration(
                        labelText: 'Sinopse',
                        hintText: 'Informe a sinopse do filme',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a sinopse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _dataLancamento ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        
                        if (selectedDate != null) {
                          setState(() {
                            _dataLancamento = selectedDate;
                            _releaseDateController.text = 
                                "${selectedDate.day.toString().padLeft(2, '0')}/"
                                "${selectedDate.month.toString().padLeft(2, '0')}/"
                                "${selectedDate.year}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _releaseDateController,
                          decoration: InputDecoration(
                            labelText: 'Data de Lançamento',
                            hintText: 'Selecione a data',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Selecione a data de lançamento';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: _salvarMidia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: fontColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _isEditMode ? 'ATUALIZAR' : 'SALVAR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
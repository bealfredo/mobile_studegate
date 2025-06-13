// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:mobile_studegate/services/aluno_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class UploadFotoScreen extends StatefulWidget {
  const UploadFotoScreen({Key? key}) : super(key: key);

  @override
  State<UploadFotoScreen> createState() => _UploadFotoScreenState();
}

class _UploadFotoScreenState extends State<UploadFotoScreen> {
  XFile? _imagem;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  
  // URL base para exibir a imagem atual do usuário
  String? _imageUrl;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentImage();
  }
  
  void _loadCurrentImage() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null && user.imagemPrincipal.isNotEmpty) {
      setState(() {
        _imageUrl = '$baseUrlApi/alunos/${user.id}/download/imagem/${user.imagemPrincipal}';
      });
    }
  }

  Future<void> _selecionarImagem(ImageSource source) async {
    try {
      final XFile? imagemSelecionada = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (imagemSelecionada != null) {
        setState(() {
          _imagem = XFile(imagemSelecionada.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
      );
    }
  }
  
  Future<void> _fazerUpload() async {
    if (_imagem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma imagem primeiro')),
      );
      return;
    }
    
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await uploadImagemAluno(user.id.toString(), _imagem!);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Atualizar dados do usuário para obter a nova imagem
        // await Provider.of<AuthProvider>(context, listen: false).refreshUserData();
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem enviada com sucesso!')),
        );
        
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar imagem: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
//   Widget _buildImagePreview() {
//   if (_imagem != null) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: kIsWeb
//           ? Image.network(
//               _imagem!.path,
//               width: double.infinity,
//               height: 300,
//               fit: BoxFit.cover,
//             )
//           : Image.file(
//               XFile(_imagem!.path),
//               width: double.infinity,
//               height: 300,
//               fit: BoxFit.cover,
//             ),
//     );
//   } else if (_imageUrl != null) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Image.network(
//         _imageUrl!,
//         width: double.infinity,
//         height: 300,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           final user = Provider.of<AuthProvider>(context).user;
//           // return _buildAvatarPlaceholder(user);
//         },
//       ),
//     );
//   } else {
//     // return _buildPlaceholderImage();
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOTO DO PERFIL',
          style: TextStyle(color: fontColor),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: fontColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seção de preview da imagem
              // _buildImagePreview(),
              
              const SizedBox(height: 24),
              
              // Botões para selecionar imagem
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selecionarImagem(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selecionarImagem(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Botão de upload
              ElevatedButton(
                onPressed: _imagem == null ? null : _fazerUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: fontColor,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'ENVIAR FOTO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Informações sobre os requisitos da foto
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Requisitos da foto:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRequirementItem('Formato 3x4 padrão de documento'),
                      _buildRequirementItem('Fundo branco ou claro'),
                      _buildRequirementItem('Rosto claramente visível'),
                      _buildRequirementItem('Sem acessórios que cubram o rosto'),
                      _buildRequirementItem('Boa iluminação e foco nítido'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
  
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700], size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_studegate/models/curso.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:mobile_studegate/main.dart';

class SituacaoAcademicaViewScreen extends StatelessWidget {
  final Curso curso;

  const SituacaoAcademicaViewScreen({Key? key, required this.curso}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final userImage =
        '$baseUrlApi/alunos/${user?.id}/download/imagem/${user?.imagemPrincipal}';


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${curso.nome} (Matriculado)',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Situação Acadêmica",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  userImage,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo("Nº de Matrícula", user?.matricula ?? ''),
                    _buildInfo("Nome", "${user?.nome ?? ''} ${user?.sobrenome ?? ''}"),
                    _buildInfo("Curso", curso.nome),
                    _buildInfo("Situação", "Matriculado"),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Documentação Acadêmica',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: const [
                  DocumentoCard(titulo: "Foto", obrigatorio: true, entregue: false),
                  DocumentoCard(titulo: "Carteira de Identidade/RG", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Certidão de Nascimento/Casamento", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Histórico Escolar - Ensino Médio", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Certificado Militar/Reservista", obrigatorio: false, entregue: true),
                  DocumentoCard(titulo: "CPF (CIC)", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Diploma/Certificado Registrado", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Comprovante de Vacina", obrigatorio: false, entregue: true),
                  DocumentoCard(titulo: "Título de Eleitor", obrigatorio: true, entregue: true),
                  DocumentoCard(titulo: "Comprovante de Votação", obrigatorio: true, entregue: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfo(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title = ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

class DocumentoCard extends StatelessWidget {
  final String titulo;
  final bool obrigatorio;
  final bool entregue;

  const DocumentoCard({
    Key? key,
    required this.titulo,
    required this.obrigatorio,
    required this.entregue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color statusColor = entregue ? Colors.green : Colors.red;
    final String statusText = entregue ? "Entregue" : "Pendente";
    final String obrigatorioText = obrigatorio ? "(Obrigatório)" : "";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entregue ? Colors.green[50] : Colors.red[50],
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Icon(
                entregue ? Icons.check : Icons.close,
                color: statusColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (obrigatorio)
                    Text(
                      obrigatorioText,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

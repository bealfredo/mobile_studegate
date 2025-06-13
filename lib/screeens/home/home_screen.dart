import 'package:flutter/material.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
    final Function(int)? onNavigate;

  const HomeScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final userImage =
        '$baseUrlApi/alunos/${user?.id}/download/imagem/${user?.imagemPrincipal}';

    // print('User Image URL: $userImage');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('PORTAL DO ALUNO'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Mostra um diálogo de confirmação antes de fazer logout
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Logout'),
                      content: Text('Tem certeza que deseja sair?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Executa o logout e fecha o diálogo
                            authProvider.logout();
                            Navigator.pop(context);
                          },
                          child: Text('Sair'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, primaryColor],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              ClipOval(
                child: Image.network(
                  userImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child; // Imagem carregada completamente
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person,
                        size: 100,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Bem-vindo(a), ${user?.nome ?? 'Usuário'}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Text(
              //   '',
              //   style: TextStyle(fontSize: 18, color: Colors.white70),
              // ),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text above the card
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Secretaria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  InfoCard(
                    title: 'BOLETIM (SEMESTRE ATUAL)',
                    description: 'Desempenho nas disciplinas do semestre atual',
                    actionLink: 'ACESSAR',
                    onPressed: () {
                      onNavigate?.call(1); // Mesmo índice
                    },
                  ),

                  InfoCard(
                    title: 'GRADE CURRICULAR',
                    description: 'Selecione um curso e veja as disciplinas distribuídas por período',
                    actionLink: 'ACESSAR',
                    onPressed: () {
                      onNavigate?.call(2); // Mesmo índice
                    },
                  ),

                  InfoCard(
                    title: 'REMATRÍCULA ONLINE',
                    description: 'Fazer a rematrícula nos semestres posteriores, conforme calendário acadêmico. Emissão da declaração de vínculo',
                    actionLink: 'ACESSAR',
                    isWarning: user?.matriculaPendente ?? false, // Passa o status para o card
                    onPressed: () {
                      onNavigate?.call(3); // Mesmo índice
                    },
                  ),

                  InfoCard(
                    title: 'ANÁLISE CURRICULAR',
                    description: 'Análise curricular completa',
                    actionLink: 'ACESSAR',
                    onPressed: () {
                      onNavigate?.call(4); // Mesmo índice
                    },
                  ),

                  InfoCard(
                    title: 'SITUAÇÃO ACADÊMICA',
                    description: 'Veja a sua situação junto a secretaria e demais departamentos da unitins',
                    actionLink: 'ACESSAR',
                    onPressed: () {
                      onNavigate?.call(5); // Mesmo índice
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLink;
  final Function()? onPressed;
  final bool isWarning; // Nova propriedade

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLink,
    this.onPressed,
    this.isWarning = false, // Falso por padrão
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: isWarning ? Colors.red[100] : Colors.white, // Cor condicional
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWarning) // Mostrar aviso se necessário
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Atenção: Ação pendente!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (isWarning) SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: isWarning ? Colors.red[900] : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isWarning ? Colors.red[800] : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onPressed,
                child: Text(
                  actionLink,
                  style: TextStyle(
                    color: isWarning ? Colors.red : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
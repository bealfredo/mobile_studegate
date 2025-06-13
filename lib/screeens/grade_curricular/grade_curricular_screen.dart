
import 'package:flutter/material.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:mobile_studegate/screeens/boletim/boletim_view.dart';
import 'package:mobile_studegate/screeens/grade_curricular/grade_curricular_view_screen.dart';
import 'package:provider/provider.dart';

class GradeCurricularScaffold extends StatefulWidget {
  const GradeCurricularScaffold({super.key});

  @override
  State<GradeCurricularScaffold> createState() => _GradeCurricularScaffoldState();
}

class _GradeCurricularScaffoldState extends State<GradeCurricularScaffold> {
  Key _listKey = UniqueKey();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GRADE CURRICULAR',
          style: TextStyle(color: fontColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(child: Text('Usuário não encontrado'));
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selecione o Curso',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              
              Expanded(
                child: user.cursos.isEmpty
                    ? const Center(child: Text('Nenhum curso encontrado'))
                    : ListView.separated(
                        itemCount: user.cursos.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final curso = user.cursos[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0 
                                ? Colors.grey[100] 
                                : Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ListTile(
                              title: Text(
                                '${curso.nome}/${curso.codigo} (Matriculado)',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  // Navegar para detalhes do curso quando "Acessar" for clicado
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GradeCurricularViewScreen(curso: curso),
                                    ),
                                  );
                                },
                                child: Text(
                                  'ACESSAR',
                                  style: TextStyle(
                                    color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, 
                                vertical: 8
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

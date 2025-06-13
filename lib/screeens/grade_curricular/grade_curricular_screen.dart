
import 'package:flutter/material.dart';
import 'package:mobile_studegate/widgets/media_list.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/screeens/media/media_add_screen.dart';

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
      body: MediaList(key: _listKey), 
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormAddMediaScaffold()),
          );

          if (result == true) {
            // Atualiza a tela após adicionar uma nova mídia
            setState(() {
              _listKey = UniqueKey();
            });
          }
        },
        backgroundColor: primaryColorLight,
        foregroundColor: fontColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

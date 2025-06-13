
import 'package:flutter/material.dart';
import 'package:mobile_studegate/widgets/media_list.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/screeens/media/media_add_screen.dart';

class BoletimScaffold extends StatefulWidget {
  const BoletimScaffold({super.key});

  @override
  State<BoletimScaffold> createState() => _BoletimScaffoldState();
}

class _BoletimScaffoldState extends State<BoletimScaffold> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BOLETIM (SEMESTRE ATUAL)',
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

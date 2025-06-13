
import 'package:flutter/material.dart';
import 'package:mobile_studegate/widgets/media_list.dart';
import 'package:mobile_studegate/main.dart';
import 'package:mobile_studegate/screeens/media/media_add_screen.dart';

class RematriculaOnlineScaffold extends StatefulWidget {
  const RematriculaOnlineScaffold({super.key});

  @override
  State<RematriculaOnlineScaffold> createState() => _RematriculaOnlineScaffoldState();
}

class _RematriculaOnlineScaffoldState extends State<RematriculaOnlineScaffold> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REMATRÍCULA ONLINE',
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

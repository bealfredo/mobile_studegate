
import 'package:flutter/material.dart';
import 'package:mobile_studegate/main.dart';

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
      body: Center(
        child: Text(
          'Em desenvolvimento',
          style: TextStyle(fontSize: 20, color: Colors.blue[900]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const FormAddMediaScaffold()),
          // );

          // if (result == true) {
          //   // Atualiza a tela após adicionar uma nova mídia
          //   setState(() {
          //     _listKey = UniqueKey();
          //   });
          // }
        },
        backgroundColor: primaryColorLight,
        foregroundColor: fontColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

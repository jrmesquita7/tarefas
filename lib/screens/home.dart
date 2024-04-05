import 'package:flutter/material.dart';

import '../componets/task.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool opacidade = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas"),
      ),
      body: AnimatedOpacity(
        opacity: opacidade ? 1 : 0,
        duration: const Duration(milliseconds: 800),
        child: ListView(
          children: [
            Task('Aprender Flutter', 5),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.remove_red_eye),
              label: 'Ocultar',
              onTap: () {
                setState(() {
                  opacidade = !opacidade;
                });
              }),
          SpeedDialChild(child: const Icon(Icons.add), label: 'Nova Tarefa')
        ],
      ),
    );
  }
}

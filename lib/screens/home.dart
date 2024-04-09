import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tarefas/componets/task.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/screens/erro_page.dart';
import 'package:tarefas/screens/form_screen.dart';
import 'package:tarefas/screens/loading_page.dart';

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
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text("Tarefas"),
      ),
      body: AnimatedOpacity(
          opacity: opacidade ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 70),
            child: FutureBuilder<List<Task>>(
              future: TaskDao().findAll(),
              builder: (context, snapshot) {
                List<Task>? items = snapshot.data;

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const LoadingPage();
                    break;
                  case ConnectionState.waiting:
                    return const LoadingPage();
                    break;
                  case ConnectionState.active:
                    return const LoadingPage();
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData && items != null) {
                      if (items.isNotEmpty) {
                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Task tarefa = items[index];
                              return tarefa;
                            });
                      }
                    }
                    return const TaskNull();
                }
              },
            ),
          )),
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
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Nova Tarefa',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contextNew) => FormScreen(
                            taskContext: context,
                          ))).then((value) => setState(() {}));
            },
          )
        ],
      ),
    );
  }
}

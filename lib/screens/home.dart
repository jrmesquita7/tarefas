import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/componets/task.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool opacidade = true;
  final TextEditingController _tarefaController = TextEditingController();
  final TextEditingController _dificuldadeController = TextEditingController();
  final List<String> _tarefas = [];
  final List<int> _tarefaDificuldades = [];

  void _savetask() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tarefas', _tarefas);
  }

  void _addtask() {
    setState(() {
      String newtask = _tarefaController.text;
      int newdifficult = int.tryParse(_dificuldadeController.text) ?? 1;
      if (newtask.isNotEmpty) {
        _tarefas.add(newtask);
        _tarefaDificuldades.add(newdifficult);
        _dificuldadeController.clear();
        _tarefaController.clear();
        _savetask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Tarefas"),
      ),
      body: AnimatedOpacity(
          opacity: opacidade ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          child: ListView.builder(
            itemCount: _tarefas.length,
            itemBuilder: (context, index) {
              // Crie uma instância de Task para cada tarefa na lista _tarefas
              return Task(
                _tarefas[index], // Nome da tarefa
                _tarefaDificuldades[
                    index], // Nível de dificuldade correspondente
                key:
                    Key('task_$index'), // Defina uma chave única para cada Task
              );
            },
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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Adiconar Tarefas"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _tarefaController,
                          decoration:
                              const InputDecoration(labelText: 'Tarefa'),
                        ),
                        TextField(
                          controller: _dificuldadeController,
                          decoration:
                              const InputDecoration(labelText: 'Dificuldade'),
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: const Text('Adicionar'),
                          onPressed: () {
                            setState(() {
                              _addtask();
                              Navigator.pop(context);
                            });
                          })
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}

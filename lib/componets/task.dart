import 'package:flutter/material.dart';
import 'package:tarefas/data/task_dao.dart';
import 'dart:math';
import 'difficuty.dart';

class Task extends StatefulWidget {
  final String nome;
  final String foto;
  final int dificuldade;

  Task(this.nome, this.foto, this.dificuldade, {super.key});

  int nivel = 0;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  double progress = 0.0;
  Color colorContainer = Colors.blue;
  Random random = Random();

  bool assetOrNetwork() {
    if (widget.foto.contains('http')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
                color: colorContainer, borderRadius: BorderRadius.circular(4)),
          ),
          Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4)),
                        width: 72,
                        height: 100,
                        child: ClipRRect(
                          child: assetOrNetwork()
                              ? Image.asset(
                                  widget.foto,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(widget.foto, fit: BoxFit.cover),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.nome,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Difficuty(
                          dificultyLevel: widget.dificuldade,
                        )
                      ],
                    ),
                    ElevatedButton(
                        onLongPress: () {
                          TaskDao().delete(widget.nome);
                        },
                        onPressed: () {
                          setState(() {
                            widget.nivel++;
                            progress = (widget.dificuldade > 0)
                                ? (widget.nivel / widget.dificuldade) / 10
                                : 1;
                            //Mudar para cores aleatorias
                            if (progress >= 1.0) {
                              colorContainer = Color.fromRGBO(
                                random.nextInt(256),
                                random.nextInt(256),
                                random.nextInt(256),
                                1.0,
                              );
                            }
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        value: progress,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Nivel: ${widget.nivel}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

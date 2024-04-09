import 'package:flutter/material.dart';

class TaskNull extends StatelessWidget {
  const TaskNull({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 128,
          ),
          Text(
            'Não há nenhuma Tarefa',
            style: TextStyle(fontSize: 32),
          )
        ],
      ),
    );
  }
}

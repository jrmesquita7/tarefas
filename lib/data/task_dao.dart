import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tarefas/data/task_const.dart';

import '../componets/task.dart';

class TaskDao {
  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) async {
        await db.execute(CREATE_TABLE_SCRIPT);
      },
      version: DATABASEVERSION,
    );
  }

  save(Task tarefa) async {
    print('Iniciando o save: ');
    final Database bancoDeDados = await getDatabase();
    print('Verificando existencia da task');
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      print('a Tarefa não Existia.');
      return await bancoDeDados.insert(TASK_TABLE_NAME, taskMap);
    } else {
      print('a Tarefa existia!');
      return await bancoDeDados.update(
        TASK_TABLE_NAME,
        taskMap,
        where: '$NAME = ?',
        whereArgs: [tarefa.nome],
      );
    }

  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('Convertendo to Map: ');
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[NAME] = tarefa.nome;
    mapaDeTarefas[DIFFICULTY] = tarefa.dificuldade;
    mapaDeTarefas[IMAGE] = tarefa.foto;
    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll: ');
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result =
    await bancoDeDados.query(TASK_TABLE_NAME);
    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    print('Convertendo to List:');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa = Task(
        linha[NAME],
        linha[IMAGE],
        linha[DIFFICULTY],
      );
      tarefas.add(tarefa);
    }
    print('Lista de Tarefas: ${tarefas.toString()}');
    return tarefas;
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando find: ');
    final Database bancoDeDados = await getDatabase();
    print('Procurando tarefa com o nome: ${nomeDaTarefa}');
    final List<Map<String, dynamic>> result = await bancoDeDados
        .query(TASK_TABLE_NAME, where: '$NAME = ?', whereArgs: [nomeDaTarefa]);
    print('Tarefa encontrada: ${toList(result)}');

    return toList(result);
  }

  delete(String nomeDaTarefa) async {
    print('Deletando tarefa: $nomeDaTarefa');
    final Database bancoDeDados = await getDatabase();
    return await bancoDeDados.delete(
      TASK_TABLE_NAME,
      where: '$NAME = ?',
      whereArgs: [nomeDaTarefa],
    );
  }
}

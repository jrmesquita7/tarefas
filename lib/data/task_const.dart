const String DATABASE_NAME = 'jr_task_db';

const String TASK_TABLE_NAME = 'tasktable';
const String NAME = 'name';
const String DIFFICULTY = 'difficulty';
const String IMAGE = 'image';

const String CREATE_TABLE_SCRIPT = '''
  CREATE TABLE $TASK_TABLE_NAME
  ( 
    $NAME TEX,
    $DIFFICULTY INTEGER,
    $IMAGE TEXT
    )
    ''';

const int DATABASEVERSION = 1;

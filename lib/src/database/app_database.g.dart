// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao _todoDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `task` TEXT, `time` TEXT, `scheduleTime` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, dynamic>{
                  'id': item.id,
                  'task': item.task,
                  'time': item.time,
                  'scheduleTime': item.scheduleTime
                },
            changeListener),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, dynamic>{
                  'id': item.id,
                  'task': item.task,
                  'time': item.time,
                  'scheduleTime': item.scheduleTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _todoMapper = (Map<String, dynamic> row) => Todo(
      row['id'] as int,
      row['task'] as String,
      row['time'] as String,
      row['scheduleTime'] as String);

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> findAllTodo() async {
    return _queryAdapter.queryList('SELECT * FROM todo', mapper: _todoMapper);
  }

  @override
  Future<Todo> getMaxTodo() async {
    return _queryAdapter.query('Select * from todo order by id desc limit 1',
        mapper: _todoMapper);
  }

  @override
  Stream<List<Todo>> fetchStreamData() {
    return _queryAdapter.queryListStream('SELECT * FROM todo order by id desc',
        tableName: 'Todo', mapper: _todoMapper);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await _queryAdapter.queryNoReturn('delete from todo where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<List<int>> insertAllTodo(List<Todo> todo) {
    return _todoInsertionAdapter.insertListAndReturnIds(
        todo, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteAll(List<Todo> list) {
    return _todoDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

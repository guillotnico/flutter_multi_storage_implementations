import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('TodoRow')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'drift_multi_storage.db'));
    debugPrint('Drift DB path: ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<TodoRow>> getAllTodos() => select(todos).get();

  Future<int> insertTodo(String title) {
    return into(todos).insert(TodosCompanion.insert(title: title));
  }

  Future<void> toggleTodo(int id, bool newValue) {
    return (update(todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(isDone: Value(newValue)),
    );
  }
}

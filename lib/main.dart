import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_model.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  
  Hive.registerAdapter(TaskModelAdapter());

  final container = ProviderContainer();

  await container.read(authRepositoryProvider).initialize();
  await container.read(taskRepositoryProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TodoApp(),
    ),
  );
}

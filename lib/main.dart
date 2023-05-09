import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

import 'src/app.dart';
import 'src/services/services_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ProviderContainer container = ProviderContainer();
  await container.read(servicesInitializerProvider).init();


  runZonedGuarded<Future<void>>(() async {
    runApp(UncontrolledProviderScope(container: container, child: const App()));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    debugPrint(error.toString());
  });
}

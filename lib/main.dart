import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_size/window_size.dart';

import 'constants/app_constants.dart';
import 'game_board/presentation/core/routing/game_route_information_parser.dart';
import 'game_board/presentation/core/routing/games_router_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.environment.containsKey('FLUTTER_TEST') &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowMinSize(const Size(350, 350));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = ref.watch(gamesRouterDelegateProvider);
    final routeInformationParser =
        ref.watch(gameRouteInformationParserProvider);

    return MaterialApp.router(
      title: appName,
      routerDelegate: routerDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
      routeInformationParser: routeInformationParser,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color.fromRGBO(76, 176, 86, 1)),
          errorColor: Colors.redAccent.shade400,
          textTheme: const TextTheme(
            headline5: TextStyle(fontSize: 20),
            headline4: TextStyle(fontSize: 28, color: Colors.black),
          )),
    );
  }
}

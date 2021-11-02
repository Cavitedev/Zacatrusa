import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/zacatrus_scrapper.dart';
import 'zacatrus_browser_state.dart';

final zacatrusBrowserNotifierProvider =
    StateNotifierProvider<ZacatrusBrowserNotifier, ZacatrusBrowserState>(
        (ref) => ZacatrusBrowserNotifier(
            scrapper: ref.read(zacatrusScrapperProvider)));

class ZacatrusBrowserNotifier extends StateNotifier<ZacatrusBrowserState> {
  ZacatrusBrowserNotifier({
    required this.scrapper,
  }) : super(ZacatrusBrowserState.init()) {
    loadGames();
  }

  final ZacatrusScapper scrapper;
  StreamSubscription? subscription;

  void loadGames() {
    subscription ??=
        scrapper.getGamesOverviews(state.urlComposer).listen((event) {
      event.when((left) {
        state = state.copyWith(loadingFeedback: event.getLeft()!);
      }, (right) {
        state = state
            .copyWith(urlComposer: state.urlComposer.nextPage())
            .addGames(event.getRight()!.games);
      });
    })
          ..onDone(() {
            subscription = null;
          });
  }

  /// Retrieves next page if it is not loading any page
  void nextPageIfNotLoading() {
    if (subscription == null) {
      loadGames();
    }
  }

  void clear() {
    state = ZacatrusBrowserState.init();
    loadGames();
  }
}
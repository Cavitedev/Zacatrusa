import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/browser/browser_notifier.dart';
import '../../game_details/game_details.dart';
import '../../games_browse/games_browse.dart';
import '../../settings/settings_page.dart';
import '../widgets/slide_page.dart';
import 'games_routing_configuration.dart';

final gamesRouterDelegateProvider = Provider((ref) => GamesRouterDelegate(ref));
final isSearchingProvider = StateProvider<bool>((ref) => false);

class GamesRouterDelegate extends RouterDelegate<GamesRoutingConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<GamesRoutingConfiguration> {
  GamesRouterDelegate(this.ref)
      : navigatorKey = GlobalKey<NavigatorState>(),
        _currentConf = GamesRoutingConfiguration.home();

  @override
  GlobalKey<NavigatorState> navigatorKey;

  final ProviderRef ref;

  GamesRoutingConfiguration _currentConf;

  GamesRoutingConfiguration get currentConf => _currentConf;

  final HeroController heroC = HeroController();

  set currentConf(GamesRoutingConfiguration conf) {
    if (conf.filterComposer != null) {
      ref
          .read(browserNotifierProvider.notifier)
          .changeFilters(conf.filterComposer!);
    }
    _currentConf = conf;
    notifyListeners();
  }

  void updateIsSearching(bool newIsSearching) {
    _currentConf = currentConf.copyWith(isSearching: newIsSearching);
    ref.read(isSearchingProvider.notifier).state = newIsSearching;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(key: const ValueKey("Games Browse"), child: GamesBrowse()),
        if (_currentConf.detailsGameUrl != null)
          MaterialPage(
              key: ValueKey(_currentConf.detailsGameUrl),
              child: GameDetails(
                url: _currentConf.detailsGameUrl!,
              )),
        if (_currentConf.settings)
          const MaterialPage(key: ValueKey("Settings"), child: SettingsPage()),
        if (_currentConf.imageLoaded != null)
          MaterialPage(
              key: ValueKey("Image ${_currentConf.imageLoaded}"),
              child: SlidePage(
                url: _currentConf.imageLoaded,
              ))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return onPopRoute();
      },
    );
  }

  bool onPopRoute() {
    if (_currentConf.imageLoaded != null) {
      _currentConf.imageLoaded = null;
      notifyListeners();
      return true;
    } else if (_currentConf.settings == true) {
      _currentConf.settings = false;
      notifyListeners();
      return true;
    } else if (_currentConf.detailsGameUrl != null) {
      _currentConf.detailsGameUrl = null;
      notifyListeners();
      return true;
    } else if (_currentConf.isSearching) {
      updateIsSearching(false);
      return true;
    }
    return false;
  }

  @override
  Future<bool> popRoute() {
    return Future.value(onPopRoute());
  }

  @override
  Future<void> setNewRoutePath(
    GamesRoutingConfiguration configuration,
  ) async {
    currentConf = configuration;
    notifyListeners();
    return Future.value(null);
  }
}

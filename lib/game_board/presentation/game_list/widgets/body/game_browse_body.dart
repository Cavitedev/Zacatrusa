import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zacatrusa/constants/app_margins.dart';
import 'package:zacatrusa/game_board/domain/game_overview.dart';
import 'package:zacatrusa/game_board/infrastructure/core/web_exceptions.dart';
import 'package:zacatrusa/game_board/infrastructure/scrapper.dart';
import 'package:zacatrusa/game_board/presentation/game_list/game_browse.dart';
import 'package:zacatrusa/game_board/presentation/game_list/widgets/sort_list_grid_switcher_row/list_grid_switcher.dart';

import 'game_browse_sliver_grid.dart';
import 'game_browse_sliver_list.dart';

final fetchPageProvider = StreamProvider.autoDispose((ref) {
  final scrapper = ref.watch(scrapperProvider);

  final cancelToken = CancelToken();
  ref.onDispose(() {
    cancelToken.cancel();
  });

  return scrapper.accessUrl(
      url: "https://zacatrus.es/juegos-de-mesa.html", cancelToken: cancelToken);
});

class GameBrowseBody extends ConsumerWidget {
  const GameBrowseBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final listOrGridView = ref.watch(gameOverviewListGrid);
    return ref.watch(fetchPageProvider).when(
          data: (either) => either.when((error) => _onErrorEither(error),
              (success) => _sucessBody(listOrGridView)),
          error: (obj, trace, data) =>
              SliverToBoxAdapter(child: Text("Error ${obj}")),
          loading: (_) => _loading(),
        );
  }

  SliverToBoxAdapter _onErrorEither(InternetFeedback error) {
    if (error is InternetLoading) {
      return _loading(error.msg);
    }
    return SliverToBoxAdapter(child: Text("Error left ${error.msg}"));
  }

  SliverToBoxAdapter _loading([String msg = "Loading..."]) {
    return SliverToBoxAdapter(
        child: Center(
      child: Column(
        children: [
          const SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
          Text(msg, textAlign: TextAlign.center,),
        ],
      ),
    ));
  }

  SliverPadding _sucessBody(StateController<ListGrid> listOrGridView) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: listPadding),
        sliver: _gamesOverviewBody(listOrGridView.state));
  }

  Widget _gamesOverviewBody(ListGrid listGrid) {
    if (listGrid == ListGrid.list) {
      return GameBrowseSliverList(
        games: _getGames(),
      );
    } else {
      return GameBrowseSliverGrid(
        games: _getGames(),
      );
    }
  }

  List<GameOverview> _getGames() {
    return List.generate(
        36,
        (index) => const GameOverview(
              name: "Unánimo",
              imageUrl:
                  "https://media.zacatrus.es/catalog/product/cache/5c1c4c2791f7788f78d4202f3db7adfa/u/n/unanimo_enviogratis.jpg",
              price: 9.95,
              numberOfComments: 12,
              stars: 4.85,
            ));
  }
}

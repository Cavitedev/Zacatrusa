import 'package:flutter_test/flutter_test.dart';
import 'package:zacatrusa/game_board/zacatrus/domain/url/zacatrus_page_query_parameter.dart';
import 'package:zacatrusa/game_board/zacatrus/domain/url/zacatrus_url_composer.dart';

void main() {
  group("Build urls", () {
    test("Initial class returns default page with 24 elements", () {
      final urlComposer = ZacatrusUrlBrowserComposer.init();

      final output = urlComposer.buildUrl();

      expect(output, "https://zacatrus.es/juegos-de-mesa.html");
    });

    test("Initial class with next page returns default page with 24 elements",
        () {
      var urlComposer = ZacatrusUrlBrowserComposer.init();
      urlComposer = urlComposer.nextPage();

      final output = urlComposer.buildUrl();

      expect(output, "https://zacatrus.es/juegos-de-mesa.html?p=2");
    });

    test("Initial class with 36 elements returns basic browser", () {
      final urlComposer = ZacatrusUrlBrowserComposer.init()
          .copyWith(productsPerPage: const ZacatrusProductsPerPage(36));

      final output = urlComposer.buildUrl();

      expect(output,
          "https://zacatrus.es/juegos-de-mesa.html?product_list_limit=36");
    });
  });
}

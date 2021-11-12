import '../../../../core/optional.dart';
import '../../../zacatrus/domain/url/zacatrus_url_composer.dart';

class GamesRoutingConfiguration {
  ZacatrusUrlBrowserComposer? filterComposer;
  bool settings;
  String? detailsGameUrl;
  String? imageLoaded;

  GamesRoutingConfiguration.home({
    this.filterComposer,
  })  : settings = false,
        detailsGameUrl = null;

  GamesRoutingConfiguration.details({this.detailsGameUrl})
      : filterComposer = null,
        settings = false;

  GamesRoutingConfiguration.settings() : settings = true;

  // ZacatrusUrlBrowserComposer? get filterComposer => _filterComposer;

  bool isHome() => settings == false && detailsGameUrl == null;

  @override
  String toString() {
    return 'GamesRoutingConfiguration{filterComposer: $filterComposer, settings: $settings, detailsGame: $detailsGameUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamesRoutingConfiguration &&
          runtimeType == other.runtimeType &&
          filterComposer == other.filterComposer &&
          settings == other.settings &&
          detailsGameUrl == other.detailsGameUrl;

  @override
  int get hashCode =>
      filterComposer.hashCode ^ settings.hashCode ^ detailsGameUrl.hashCode;

  GamesRoutingConfiguration copyWith({
    Optional<ZacatrusUrlBrowserComposer?>? filterComposer,
    bool? settings,
    Optional<String?>? detailsGameUrl,
    Optional<String?>? imageLoaded,
  }) {
    return GamesRoutingConfiguration._(
      filterComposer:
          filterComposer == null ? this.filterComposer : filterComposer.value,
      settings: settings ?? this.settings,
      detailsGameUrl:
          detailsGameUrl == null ? this.detailsGameUrl : detailsGameUrl.value,
      imageLoaded: imageLoaded == null ? this.imageLoaded : imageLoaded.value,
    );
  }

  GamesRoutingConfiguration._(
      {this.filterComposer,
      required this.settings,
      this.detailsGameUrl,
      this.imageLoaded});
}

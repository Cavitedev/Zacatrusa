import 'game_data_sheet.dart';
import 'game_overview_details.dart';
import 'images_carousel.dart';
import 'review_url/review_url.dart';

class ZacatrusDetailsPageData {
  ZacatrusDetailsPageData({
    this.imagesCarousel,
    required this.gameOverview,
    this.gameDescription,
    this.gameDataSheet,
    this.reviewsUrl,
  });

  ImagesCarousel? imagesCarousel;
  GameOverviewDetails gameOverview;
  String? gameDescription;
  String? overviewDescription;
  GameDataSheet? gameDataSheet;
  ReviewUrl? reviewsUrl;
}

import 'dart:async';
import 'news_api.dart';
import 'news_db.dart';
import '../models/item_model.dart';

abstract class NewsSource {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class NewsCache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

class NewsRepository {
  List<NewsSource> sourceList = <NewsSource>[
    newsDbProvider,
    newsApiProvider,
  ];

  List<NewsCache> cacheList = <NewsCache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async => await sourceList[1].fetchTopIds();

  // Future<ItemModel?> fetchItem(int id) async {
  //   ItemModel? item;
  //   var source;

  //   for (source in sourceList) {
  //     item = await source.fetchItem(id);
  //     if (item != null) {
  //       break;
  //     }
  //   }

  //   for (var cache in cacheList) {
  //     if (cache != source) {
  //       if (item != null) {
  //         cache.addItem(item);
  //       }
  //     }
  //   }

  //   return item;
  // }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    NewsSource source;

    for (source in sourceList) {
      item = await source.fetchItem(id);

      if (item != null) {
        for (var cache in cacheList) {
          cache.addItem(item);
        }
        break;
      }
    }
    return item;
  }

  void clearCache() async {
    for (var cache in cacheList) {
      await cache.clear();
    }
  }
}

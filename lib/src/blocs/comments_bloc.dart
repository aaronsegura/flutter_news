import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();
  final _repository = NewsRepository();

  // Streams
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  // Constructor
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  StreamTransformer<int, Map<int, Future<ItemModel?>>> _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
      (cache, int id, int index) {
        cache[id] = _repository.fetchItem(id).then((ItemModel? item) {
          for (var kidid in item!.kids) {
            fetchItemWithComments(kidid);
          }
          return item;
        });
        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}

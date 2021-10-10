import 'dart:async';
import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  const NewsDetail(this.itemId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommentsBloc commentsBloc = CommentsProvider.of(context);
    final StoriesBloc storiesBloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Details'),
      ),
      body: Container(
        child: buildBody(commentsBloc),
      ),
    );
  }

  Widget buildBody(CommentsBloc commentsBloc) {
    return StreamBuilder(
      stream: commentsBloc.itemWithComments,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading...");
        } else {
          final itemFuture = snapshot.data?[itemId];

          return FutureBuilder(
              future: itemFuture,
              builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return const Text("Still Loading");
                } else {
                  return buildList(itemSnapshot.data, snapshot.data);
                }
              });
        }
      },
    );
  }

  Widget buildList(ItemModel? item, Map<int, Future<ItemModel?>>? itemMap) {
    final commentsList = item!.kids.map((kidid) {
      return Comment(kidid, itemMap, 0);
    }).toList();
    final children = <Widget>[];
    children.add(buildTitle(item));
    children.addAll(commentsList);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: children,
    );
  }

  Widget buildTitle(ItemModel? item) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10.0),
      child: Text(item!.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

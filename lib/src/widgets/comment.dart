import 'dart:async';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import './loading_news_list_tile.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>>? itemMap;
  final int depth;

  const Comment(this.itemId, this.itemMap, this.depth, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTile();
        }

        final children = <Widget>[
          ListTile(
              contentPadding: EdgeInsets.only(
                left: depth * 16.0,
                right: 16.0,
              ),
              title: buildText(snapshot.data),
              subtitle: Text(
                  snapshot.data!.by == '' ? '[Deleted]' : snapshot.data!.by)),
          const Divider(thickness: 5.0),
        ];
        for (var kidId in snapshot.data!.kids) {
          children.add(Comment(kidId, itemMap, depth + 1));
        }
        return Column(children: children);
      },
      future: itemMap?[itemId],
    );
  }

  Widget buildText(ItemModel? item) {
    var unescape = HtmlUnescape();
    return Text(unescape.convert(item!.text));
  }
}

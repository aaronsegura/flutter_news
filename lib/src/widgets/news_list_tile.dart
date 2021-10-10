import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'loading_news_list_tile.dart';

class NewsListTile extends StatelessWidget {
  const NewsListTile(this.itemId, {Key? key}) : super(key: key);

  final int itemId;

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
        stream: bloc.items,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
                margin: const EdgeInsets.only(top: 100.0),
                child: const LoadingListTile());
          }
          return FutureBuilder(
              future: snapshot.data[itemId],
              builder:
                  (BuildContext context, AsyncSnapshot<ItemModel?> iSnapshot) {
                if (!iSnapshot.hasData) {
                  return const LoadingListTile();
                }
                return buildTile(context, iSnapshot.data);
              });
        });
  }

  Widget buildTile(BuildContext context, ItemModel? item) {
    return Column(
      children: [
        ListTile(
            title: Text(item!.title),
            subtitle: Text("${item.score} votes"),
            trailing: Column(
              children: [
                const Icon(Icons.comment),
                Text("${item.descendants}"),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/${item.id}');
            }),
        const Divider(height: 8.0, thickness: 2.0),
      ],
    );
  }
}

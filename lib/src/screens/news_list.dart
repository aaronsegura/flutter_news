import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh_news_list.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) => StreamBuilder(
        stream: bloc.topIds,
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                    child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: null,
                    ),
                    const Text('Loading Top News Stories'),
                  ],
                )));
          }

          return RefreshNewsList(ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              bloc.fetchItem(snapshot.data![index]);
              return NewsListTile(snapshot.data![index]);
            },
          ));
        },
      );
}

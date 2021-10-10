import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
        child: StoriesProvider(
      child: MaterialApp(
        title: 'News!',
        onGenerateRoute: routes,
      ),
    ));
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return newsListRoute();
    } else {
      return newsItemRoute(int.parse(
        settings.name!.replaceFirst('/', ''),
      ));
    }
  }

  Route newsListRoute() {
    return MaterialPageRoute(
      builder: (context) {
        final storiesBloc = StoriesProvider.of(context);
        storiesBloc.fetchTopIds();

        return const NewsList();
      },
    );
  }

  Route newsItemRoute(int itemId) {
    return MaterialPageRoute(builder: (context) {
      final CommentsBloc commentsBloc = CommentsProvider.of(context);
      commentsBloc.fetchItemWithComments(itemId);
      return NewsDetail(itemId);
    });
  }
}

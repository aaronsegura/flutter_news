import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class RefreshNewsList extends StatelessWidget {
  const RefreshNewsList(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final storiesBloc = StoriesProvider.of(context);
    return RefreshIndicator(
        child: child,
        onRefresh: () {
          storiesBloc.clearCache();
          return storiesBloc.fetchTopIds();
        });
  }
}

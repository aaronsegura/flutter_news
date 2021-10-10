import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:news/src/resources/news_api.dart';

void main() {
  test('Fetch Top Stories', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(jsonEncode([1, 2, 3, 4]), 200);
    });
    final ids = await newsApi.fetchTopIds();
    expect(ids, [1, 2, 3, 4]);
  });

  test('Fetch an item', () async {
    final response = {
      'id': 0,
      'deleted': false,
      'type': 'thing',
      'by': 'person',
      'time': 0,
      'text': 'Body text',
      'dead': false,
      'parent': 1,
      'kids': [4, 2, 3],
      'url': 'https://something.com/yourmom.jpg',
      'score': 100,
      'title': 'The thing about things.',
      'descendants': 250
    };
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode(response), 200);
    });
    final item = await newsApi.fetchItem(999);

    expect(item.id, 0);
  });
}

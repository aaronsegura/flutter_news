import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        deleted = j['deleted'] ?? false,
        type = j['type'],
        by = j['by'] ?? "",
        time = j['time'],
        text = j['text'] ?? "",
        dead = j['dead'] ?? false,
        parent = j['parent'] ?? 0,
        kids = j['kids'] ?? [],
        url = j['url'] ?? "",
        score = j['score'] ?? 0,
        title = j['title'] ?? "",
        descendants = j['descendants'] ?? 0;

  ItemModel.fromDb(Map<String, dynamic> d)
      : id = d['id'],
        deleted = d['deleted'] == 1,
        type = d['type'],
        by = d['by'],
        time = d['time'],
        text = d['text'],
        dead = d['dead'] == 1,
        parent = d['parent'],
        kids = jsonDecode(d['kids']),
        url = d['url'],
        score = d['score'],
        title = d['title'],
        descendants = d['descendants'];

  Map<String, dynamic> toDbMap() => <String, dynamic>{
        'id': id,
        'deleted': deleted ? 1 : 0,
        'type': type,
        'by': by,
        'time': time,
        'text': text,
        'dead': dead ? 1 : 0,
        'parent': parent,
        'kids': jsonEncode(kids),
        'url': url,
        'score': score,
        'title': title,
        'descendants': descendants
      };
}

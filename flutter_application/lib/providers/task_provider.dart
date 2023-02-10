import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/article_model.dart';
import 'package:http/http.dart' as http;

class ArticleProvider extends ChangeNotifier {
  ArticleProvider() {
    fetchArticles();
  }
  List<Ariticle> _articles = [];

  UnmodifiableListView<Ariticle> get allArticles =>
      UnmodifiableListView(_articles);

  void deleteArticle(Ariticle ariticle) async {
    final response = await http.delete(
      'http://127.0.0.1/articles/${ariticle.id}' as Uri,
    );
    if (response.statusCode == 204) {
      _articles.remove(ariticle);
      notifyListeners();
    }
  }

  fetchArticles() async {
    final response = await http.get('http://127.0.0.1/api' as Uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      _articles =
          data.map<Ariticle>((json) => Ariticle.fromJason(json)).toList();
      notifyListeners();
    }
  }
}

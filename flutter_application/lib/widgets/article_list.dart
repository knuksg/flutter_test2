import 'package:flutter/material.dart';
import 'package:flutter_application/model/article_model.dart';
import 'package:flutter_application/widgets/article_list_item.dart';

class ArticleList extends StatelessWidget {
  final List<Ariticle> articles;

  const ArticleList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenArticles(),
    );
  }

  List<Widget> getChildrenArticles() {
    return articles
        .map((article) => ArticleListItem(ariticle: article))
        .toList();
  }
}

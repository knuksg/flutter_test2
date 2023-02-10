import 'package:flutter/material.dart';
import 'package:flutter_application/model/article_model.dart';
import 'package:flutter_application/providers/task_provider.dart';
import 'package:provider/provider.dart';

class ArticleListItem extends StatelessWidget {
  final Ariticle ariticle;
  const ArticleListItem({super.key, required this.ariticle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ariticle.title),
      trailing: IconButton(
          onPressed: () {
            Provider.of<ArticleProvider>(context).deleteArticle(ariticle);
          },
          icon: const Icon(Icons.delete)),
    );
  }
}

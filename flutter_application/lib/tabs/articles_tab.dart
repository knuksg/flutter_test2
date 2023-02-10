import 'package:flutter/material.dart';
import 'package:flutter_application/providers/task_provider.dart';
import 'package:flutter_application/widgets/article_list.dart';
import 'package:provider/provider.dart';

class AllArticleTab extends StatelessWidget {
  const AllArticleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ArticleProvider>(
        builder: (context, value, child) => ArticleList(
          articles: value.allArticles,
        ),
      ),
    );
  }
}

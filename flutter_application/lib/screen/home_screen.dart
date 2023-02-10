import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/model/article_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Ariticle>> articles;
  final articleListKey = GlobalKey<_HomeScreenState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    articles = getArticleList();
  }

  Future<List<Ariticle>> getArticleList() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/api"));

    final items = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();

    List<Ariticle> articles = items.map<Ariticle>((json) {
      return Ariticle.fromJason(json);
    }).toList();

    return articles;
  }

  Future<http.Response> createArticle(String title, String content) async {
    final responce = await http.post(Uri.parse("http://10.0.2.2:8000/api"),
        headers: {"Content-Type": "application/json"},
        body: '{"title": "$title", "content": "$content"}');
    setState(() {
      articles = getArticleList();
    });
    return responce;
  }

  Future<void> updateArticle(String id, String title, String content) async {
    final response = await http.put(Uri.parse("http://10.0.2.2:8000/api/$id"),
        headers: {"Content-Type": "application/json"},
        body: '{"title": "$title", "content": "$content"}');

    setState(() {
      articles = getArticleList();
    });
  }

  Future<void> deleteArticle(String id) async {
    final response =
        await http.delete(Uri.parse("http://10.0.2.2:8000/api/$id"));

    if (response.statusCode == 200 | 204) {
      print('success');
      setState(() {
        articles = getArticleList();
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to delete article');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: articleListKey,
        appBar: AppBar(
          title: const Text('Flutter-DRF Test'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: 300.0,
                          child: Column(children: [
                            const ListTile(
                              title: Text('create'),
                            ),
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Title'),
                                    controller: titleController,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Content'),
                                    controller: contentController,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      String title = titleController.text;
                                      String content = contentController.text;
                                      createArticle(title, content);
                                      titleController.clear();
                                      contentController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.create),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: ElevatedButton(
                              child: const Text('Close Modal'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ))
                          ]),
                        ),
                      );
                    });
              },
            )
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Ariticle>>(
            future: articles,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.title),
                        title: Text(
                          data.title,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          data.content,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.create),
                              onPressed: () async {
                                titleController.text = data.title;
                                contentController.text = data.content;
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SizedBox(
                                          height: 300.0,
                                          child: Column(children: [
                                            const ListTile(
                                              title: Text('update'),
                                            ),
                                            Form(
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText: 'Title'),
                                                    controller: titleController,
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Content'),
                                                    controller:
                                                        contentController,
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      String title =
                                                          titleController.text;
                                                      String content =
                                                          contentController
                                                              .text;
                                                      updateArticle(
                                                          data.id.toString(),
                                                          title,
                                                          content);
                                                      titleController.clear();
                                                      contentController.clear();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.create),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child: ElevatedButton(
                                              child: const Text('Close Modal'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ))
                                          ]),
                                        ),
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                deleteArticle(data.id.toString());
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'Post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String urlBase = "https://jsonplaceholder.typicode.com/";

  Post post = Post(0, 1, "", "");

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse(urlBase + "/posts"));
    var dadosJson = json.decode(response.body);

    List<Post> postagens = [];

    for (var post in dadosJson) {
      print("post: " + post["title "]);
      Post p = Post(
        post["userId"],
        post["id"],
        post["title"],
        post["body"],
      );
      postagens.add(p);
    }

    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo Serviço Avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // print("Conexao none");
            // break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            // print("Conexao active");
            // break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("Lista: Erro ao carregar");
              } else {
                print("Lista: Carregou!!");

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List<Post>? lista = snapshot.data;
                    Post post = lista![index];

                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.id.toString()),
                    );
                  },
                );
              }
              break;
          }

        },
      ),
    );
  }
}

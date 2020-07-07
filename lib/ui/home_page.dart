import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;

  Future<Map> _getGifis() async {
    http.Response response;
    if (_search == null) {
      print("------search null ok");
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=h1GBl4kHXBOqKc7fMcKdhGGLv9ZUI9n4&limit=25&rating=g");
    } else {
      print("------search not null ok");
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=h1GBl4kHXBOqKc7fMcKdhGGLv9ZUI9n4&q=$_search&limit=25&offset=$_offset&rating=g&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    print("------Iniciou ok");
    _getGifis().then((map) {
      print(map);
    });
  } //https://api.giphy.com/v1/gifs/search?api_key=h1GBl4kHXBOqKc7fMcKdhGGLv9ZUI9n4&q$_search=&limit=25&offset=25&rating=g&lang=pt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: ("Pesquise Aqui!"),
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifis(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_width"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        });
  }
}

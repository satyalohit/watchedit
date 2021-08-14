import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moviesapp/modal/movie.dart';
import 'package:moviesapp/screens/loginScreen.dart';
import 'package:moviesapp/screens/movieListScreen.dart';
import '../screens/modalbottomsheet.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';

class HomeScreen extends StatefulWidget {
  Function signOut;
  HomeScreen(this.signOut);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MoviesProvider>(
      create: (context) => MoviesProvider(),
      builder: (ctx, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Watched Movies'),
          actions: [
            IconButton(
                onPressed: () async {
                  await widget.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: MovieListScreen(),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moviesapp/modal/movie.dart';
import 'package:moviesapp/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import 'modalbottomsheet.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  void showAddMovieSheet(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return ChangeNotifierProvider<MoviesProvider>(
            create: (context) => MoviesProvider(),
            builder: (ctx, child) => MovieDetailsSheet(0, "", "", "", 1),
          );
        }).then((_) {
      Provider.of<MoviesProvider>(context, listen: false).getData();
    });
  }

  void showEditMovieSheet(BuildContext ctx, Movie movie) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return ChangeNotifierProvider<MoviesProvider>(
              create: (context) => MoviesProvider(),
              builder: (ctx, child) => MovieDetailsSheet(
                  int.parse(movie.id.toString()),
                  movie.name.toString(),
                  movie.director.toString(),
                  movie.posterurl.toString(),
                  2));
        }).then((_) {
      Provider.of<MoviesProvider>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    MoviesProvider movieprovider = Provider.of<MoviesProvider>(context);
    List<Movie> movieDetails = movieprovider.movielist;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => showAddMovieSheet(context),
        child: Icon(Icons.add),
      ),
      body: !movieprovider.moviesLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : movieDetails.isEmpty
              ? Center(
                  child: Text(
                    'Add Movies that you have watched...',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: movieDetails.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Divider(
                          height: 0.5,
                        ),
                        Container(
                          height: 150,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Image.file(
                                  File(
                                      movieDetails[index].posterurl.toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieDetails[index].name.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                          movieDetails[index]
                                              .director
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              showEditMovieSheet(
                                                  ctx, movieDetails[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                            'Delete Movie'),
                                                        content: Text(
                                                            'Are you sure you want to delete movie.'),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text('No')),
                                                          FlatButton(
                                                              onPressed: () {
                                                                Provider.of<MoviesProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deleteMovie(
                                                                        movieDetails[index]
                                                                            .id
                                                                            .toString());
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text('Yes')),
                                                        ],
                                                      ));
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
    );
  }
}

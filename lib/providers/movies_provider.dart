import 'package:flutter/material.dart';
import 'package:moviesapp/db/db.dart';
import 'package:moviesapp/modal/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesProvider with ChangeNotifier {
  List<Movie> _movielist = [];
  bool moviesLoading = false;
  MoviesProvider() {
    getData();
  }
  getData() async {
    _movielist.clear();
    _movielist = [];
    moviesLoading = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email").toString();

    await DBHelper.getData("movies", email).then((value) {
      print(value);
      value.forEach((element) {
        _movielist.add(Movie(
            id: element["id"],
            name: element["name"],
            director: element["director"],
            posterurl: element["posterurl"],
            email: element["email"]));
      });
    });
    moviesLoading = true;
    notifyListeners();
  }

  List<Movie> get movielist {
    return _movielist;
  }

  void addMovie(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email").toString();
    await DBHelper.insert("movies", {
      "name": movie.name.toString(),
      "director": movie.director.toString(),
      "posterurl": movie.posterurl.toString(),
      "email": email,
    }).then((value) {
      getData();
    });

    notifyListeners();
  }

  void deleteMovie(String id) async {
    DBHelper.delete("movies", id).then((_) {
      _movielist.removeWhere((movie) => movie.id == int.parse(id));
    });

    notifyListeners();
  }

  void updateMovie(Movie movie) async {
    print(movie.id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email").toString();
    await DBHelper.update("movies", movie.id.toString(), {
      "name": movie.name.toString(),
      "director": movie.director.toString(),
      "posterurl": movie.posterurl.toString(),
      "email": email,
    }).then((_) {
      _movielist[_movielist.indexWhere((element) => element.id == movie.id)] =
          movie;
    });
    ;
    notifyListeners();
  }
}

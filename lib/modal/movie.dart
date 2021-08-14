import 'package:flutter/material.dart';

class Movie {
  int? id;
  String? name;
  String? director;
  String? posterurl;
  String? email;
  Movie(
      {this.id,
      @required this.name,
      @required this.director,
      @required this.posterurl,
      @required this.email});
}

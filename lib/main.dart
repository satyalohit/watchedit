import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviesapp/providers/movies_provider.dart';
import 'package:moviesapp/screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/homeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromRGBO(229, 9, 20, 1),
          backgroundColor: Colors.black,
          buttonColor: Color.fromRGBO(229, 9, 20, 1),
          fontFamily: GoogleFonts.bebasNeue().fontFamily),
      title: "MovieApp",
      home: LoginScreen(),
    );
  }
}

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviesapp/modal/movie.dart';
import 'package:moviesapp/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

class MovieDetailsSheet extends StatefulWidget {
  int id;
  String title;
  String director;
  String poster;
  int mode;
  MovieDetailsSheet(this.id, this.title, this.director, this.poster, this.mode);

  @override
  _MovieDetailsSheetState createState() => _MovieDetailsSheetState();
}

class _MovieDetailsSheetState extends State<MovieDetailsSheet> {
  String _path = "";
  final _nameController = TextEditingController()..text = "";
  final _directorController = TextEditingController()..text = "";
  final _nameFocus = FocusNode();
  final _directorFocus = FocusNode();
  bool _textloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController..text = widget.title;
    _directorController..text = widget.director;
    _path = widget.poster;
  }

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        if (image != null) {
          if (image.path != null) {
            _path = image.path.toString();
          }
        }
      });
    }).catchError((err) {
      print(err);
      Navigator.of(context).pop();
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var movieData = Provider.of<MoviesProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 3),
                    child: Text(
                      widget.mode == 1 ? 'Add Movie' : 'Edit Movie',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Movie name',
                      hintText: 'Enter Movie name',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter movie name';
                      }
                    },
                  ),
                  TextFormField(
                    controller: _directorController,
                    focusNode: _directorFocus,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Director',
                      hintText: 'Enter movie director name',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter director name';
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _path != ""
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Image Preview (click on image to change)",
                                          style: TextStyle(fontSize: 16)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                getImage();
                                              },
                                              child: Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 2,
                                                    ),
                                                    color: Colors.grey[600],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                0))),
                                                child: Image.file(
                                                  File(_path),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: DottedBorder(
                                        dashPattern: [8],
                                        color: Colors.grey,
                                        strokeWidth: 2,
                                        child: Container(
                                          height: 125,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Center(
                                            child: FlatButton(
                                              child: Text(
                                                "Choose Poster Image",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .buttonColor),
                                              ),
                                              onPressed: () {
                                                getImage();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_textloading)
                                    Text(
                                      'Please pick a poster image',
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor,
                                          fontSize: 10),
                                    )
                                ],
                              ),
                      ),
                    ],
                  ),
                  widget.mode == 1
                      ? FlatButton(
                          height: 50,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            if (_path == '' || _path.isEmpty) {
                              _textloading = true;

                              return;
                            }
                            movieData.addMovie(Movie(
                              id: 1,
                              name: _nameController.text,
                              director: _directorController.text,
                              posterurl: _path,
                            ));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Add Movie',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : FlatButton(
                          height: 50,
                          onPressed: () {
                   
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            movieData.updateMovie(Movie(
                              id: widget.id,
                              name: _nameController.text,
                              director: _directorController.text,
                              posterurl: _path,
                            ));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Edit Movie',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

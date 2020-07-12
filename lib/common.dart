import 'package:flutter/material.dart';

var textFieldDecoration = InputDecoration(
  hintText: 'Enter the title',
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  prefixIcon: Icon(Icons.title),
  filled: true,
  fillColor: Colors.grey[300],
);

var textDecoration2 = InputDecoration(
  hintText: 'Enter the title',
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  prefixIcon: Icon(Icons.title),
  filled: true,
  fillColor: Colors.grey[300],
);

var whiteBold =
    TextStyle(color: Colors.white, fontFamily: 'Galada', fontSize: 30.0);

var blackBold = TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0);

var whiteSmall = TextStyle(color: Colors.white, fontSize: 15.0);

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

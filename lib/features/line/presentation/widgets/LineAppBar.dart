
import 'package:flutter/material.dart';

AppBar LineAppBar({required String description}){
  return AppBar(
    backgroundColor: Colors.deepPurple,
    title: Text(
      "$description ",
      style: const TextStyle(color: Colors.white),
    ),
  );
}
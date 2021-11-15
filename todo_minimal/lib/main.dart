import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_minimal/Models/TaskProvider.dart';
import 'package:todo_minimal/Screens/TaskScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>TaskProvider(),
      child: MaterialApp(
        title: 'MinimalTodo',
        theme: ThemeData(
          canvasColor: Colors.white,
        ),
        home: TaskScreen(),
        debugShowCheckedModeBanner:false,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ralali_bakery/bloc/cake_bloc.dart';
import 'package:ralali_bakery/ui/ui_cake_list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => CakeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove debug banner
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CakeListScreen(),
      ),
    );
  }
}



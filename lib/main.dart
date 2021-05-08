import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class NumeroAleatorio {
  final StreamController _controller = StreamController<int>();
  int _contador = Math.Random().nextInt(1000);
  int numeroVezes = 0;

  NumeroAleatorio() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _controller.sink.add(_contador);
      _contador = Math.Random().nextInt(1000);
      numeroVezes += 1;

      if (numeroVezes > 7) {
        timer.cancel();
        _controller.sink.close();
      }
    });
  }
  Stream<int> get stream => _controller.stream;
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<int>(
            stream: NumeroAleatorio().stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error ${snapshot.error.toString()}"),
                );
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text("None"),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: Text("Waiting"),
                    );
                    break;
                  case ConnectionState.active:
                    return Center(
                      child: Text("Running - ${snapshot.data}"),
                    );
                    break;
                  case ConnectionState.done:
                    return Center(
                      child: Text("Done - ${snapshot.data}"),
                    );
                    break;
                }
              }
            }));
  }
}

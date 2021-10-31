import 'package:election_exit_poll_07610605/pages/exit_poll.dart';
import 'package:election_exit_poll_07610605/pages/result.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        ExitPoll.routeName : (context) => const ExitPoll(),
        ResultPage.routeName: (context) => const ResultPage(),
      },
      initialRoute: ExitPoll.routeName,
    );
  }
}

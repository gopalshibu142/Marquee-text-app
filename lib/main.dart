import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(const MyApp());
}

class Ui {
  Color white = Colors.white;
  Color black = Colors.black;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Ui ui;
  late TextEditingController control;
  @override
  void initState() {
    ui = Ui();
    control = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              color: ui.black,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      //expands: true,
                      // minLines: null,
                      controller: control,
                      maxLines: null,
                      style: TextStyle(color: ui.white),
                      decoration: InputDecoration(
                          fillColor: ui.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                OpenContainer(
                  closedBuilder: (context, _) => GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      width: 100,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Submit"),
                    ),
                  ),
                  openBuilder: (context, _) => maarquee(),
                  closedColor: Colors.transparent,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container maarquee() {
    var txt;
    txt =" "*20 + control.text;
    return Container(
      color: ui.black,
      child: RotatedBox(
        quarterTurns: 1,
        
        child: Center(
          child: Marquee(
            velocity: 200,
            blankSpace: 300,
            style: TextStyle(fontSize: 200),
            textDirection: TextDirection.ltr,
            text: txt,
          ),
        ),
      ),
    );
  }
}

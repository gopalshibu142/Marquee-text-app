import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:animations/animations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(App());
}

class Ui {
  Color white = Color(0xffFFE3D8);
  Color black = Color(0xff0A043C);
  Color mid = Color(0xff03506F);
  Color bg = Colors.black;
  Color font = Colors.white;
  Color grad1 = Color(0xff051937);
  Color grad2 = Color(0xffA8EB12);
  LinearGradient getGrad() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 1),
      colors: <Color>[
        grad1,
        grad2
      ], // Gradient from https://learnui.design/tools/gradient-generator.html
      tileMode: TileMode.mirror,
    );
  }
}

class App extends StatelessWidget {
  App({super.key});
  Ui uit = Ui();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: uit.black,
        textTheme: TextTheme(
          headline1: TextStyle(color: uit.white),
          headline2: TextStyle(color: uit.white),
          bodyText2: TextStyle(color: uit.white),
          subtitle1: TextStyle(color: uit.white),
        ),
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Ui ui;

  late TextEditingController control;
  var fontsize = 200.0;
  var val = 0.5;
  var speed = 0.5;
  late SpeechToText stt;
  late bool rec = false;
  bool grad = false;
  bool _speechEnabled = false;
  @override
  void initState() {
    ui = Ui();
    stt = SpeechToText();
    _initSpeech();
    control = TextEditingController();
    control.text = "";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ui.black,
        title: Text("Marquee Maker"),
        centerTitle: true,
      ),
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
              Text("Enter Your Message Below"),
              SizedBox(
                height: 10,
              ),
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
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (stt.isNotListening) {
                                if (_speechEnabled) {
                                  _startListening();
                                  setState(() {
                                    control.text = "Listening...";
                                  });
                                } else {
                                  setState(() {
                                    rec = false;
                                  });
                                  var a = SnackBar(
                                      content: Text("Permission Denied"));
                                  ScaffoldMessenger.of(context).showSnackBar(a);
                                }
                              } else {
                                _stopListening();

                                setState(() {
                                  control.text = "";
                                });
                              }
                              Future.delayed(Duration(seconds: 6), () {
                                 while (stt.isListening);

                              if (stt.isNotListening &&
                                  control.text == "Listening...") {
                                setState(() {
                                  control.text = "";
                                });
                              }
                              });
                             
                            },
                            icon: Icon(rec ? Icons.stop_circle : Icons.mic)),
                        fillColor: ui.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ui.white, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ui.mid, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        suffixIconColor: ui.white,
                        focusColor: ui.mid,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: ui.white, width: 2),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Font Color  :  "),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ui.font,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: ui.font.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                  width: 1))),
                      onPressed: () async {
                        showAppDialog(context, 1);
                      },
                      child: Text("Pick Color",
                          style: TextStyle(
                            color: ui.font.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Background Color  :  "),
                    grad
                        ? Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ui.grad1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                                color:
                                                    ui.bg.computeLuminance() >
                                                            0.5
                                                        ? Colors.black
                                                        : Colors.white,
                                                width: 1))),
                                    onPressed: () async {
                                      showAppDialog(context, 2);
                                    },
                                    child: null),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ui.grad2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                                color:
                                                    ui.bg.computeLuminance() >
                                                            0.5
                                                        ? Colors.black
                                                        : Colors.white,
                                                width: 1))),
                                    onPressed: () async {
                                      showAppDialog(context, 3);
                                    },
                                    child: null),
                              )
                            ],
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ui.bg,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: ui.bg.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                        width: 1))),
                            onPressed: () async {
                              showAppDialog(context, 0);
                            },
                            child: Text("Pick Color",
                                style: TextStyle(
                                  color: ui.bg.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                )),
                          )
                  ],
                ),
              ),

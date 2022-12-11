import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:animations/animations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const App());
}

class Ui {
  Color white = Colors.white;
  Color black = Colors.black;
  Color bg = Colors.black;
  Color font = Colors.white;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
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
  late bool rec = true;
  bool _speechEnabled = false;
  @override
  void initState() {
    ui = Ui();
    stt = SpeechToText();
    _initSpeech();
    control = TextEditingController();
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
                              if (!rec) {
                                setState(() {
                                  rec = true;
                                });
                                
                                if (_speechEnabled) {
                                  _startListening();
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
                                  rec = false;
                                });
                              }
                            },
                            icon: rec
                                ? Icon(Icons.square)
                                : Icon(Icons.play_arrow)),
                        fillColor: ui.white,
                        border: OutlineInputBorder(
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
                              side: BorderSide(color: Colors.white))),
                      onPressed: () async {
                        showAppDialog(context, 1);
                      },
                      child: Text("Pick Color"),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ui.bg,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.white))),
                      onPressed: () async {
                        showAppDialog(context, 0);
                      },
                      child: Text("Pick Color"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Font Size   : "),
                    Slider(
                        value: val,
                        onChanged: (v) {
                          setState(() {
                            val = v;
                            fontsize = 100 + v * 200;
                          });
                        }),
                    Text('${fontsize.round()}')
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("speed   : "),
                    Slider(
                        value: speed,
                        onChanged: (v) {
                          setState(() {
                            speed = v;
                          });
                        }),
                    Text('${speed.toStringAsPrecision(1)}')
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OpenContainer(
                closedBuilder: (context, _) => GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(10)),
                    width: 100,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("Submit"),
                  ),
                ),
                openBuilder: (context, _) => maarquee(),
                closedColor: Colors.transparent,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rotate_90_degrees_ccw),
                  Text("Tilt your phone to the left after submitting"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  
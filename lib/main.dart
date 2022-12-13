import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:animations/animations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const App());
}

class Ui {
  Color white = Color(0xffE5B8F4);
  Color black = Color(0xff2D033B);
  Color mid = Color(0xff810CA8);
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
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff2D033B),
        textTheme: TextTheme(
          headline1: TextStyle(color: Color(0xffE5B8F4)),
          headline2: TextStyle(color: Color(0xffE5B8F4)),
          bodyText2: TextStyle(color: Color(0xffE5B8F4)),
          subtitle1: TextStyle(color: Colors.pinkAccent),
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
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Gradient  :"),
                  Switch(
                      activeColor: ui.white,
                      value: grad,
                      onChanged: (b) {
                        setState(() {
                          grad = b;
                        });
                      })
                ],
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
                        activeColor: ui.white,
                        inactiveColor: ui.mid,
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
                        activeColor: ui.white,
                        inactiveColor: ui.mid,
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
                        border: Border.all(width: 2, color: ui.white),
                        color: ui.mid,
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
                  Icon(Icons.rotate_90_degrees_ccw, color: ui.white),
                  Text(" Tilt your phone to the left after submitting"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container maarquee() {
    var txt;
    print(control.text.length);
    control.text == null
        ? "404 No Message found"
        : txt = " " * 20 + control.text;
    return Container(
     decoration: BoxDecoration(
      color: ui.bg,
      gradient: grad?ui.getGrad():null
     ),
      
      child: RotatedBox(
        quarterTurns: 1,
        child: Center(
          child: Marquee(
            velocity: 100 + speed * 400,
            blankSpace: 300,
            style: TextStyle(fontSize: fontsize, color: ui.font),
            textDirection: TextDirection.ltr,
            text: txt,
          ),
        ),
      ),
    );
  }

  showAppDialog(BuildContext context, chk) {
    print("Showing app dialog");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff111111),
            scrollable: true,

            content: Container(
              color: Colors.black,
              height: 358,
              //width: 300,
              child: ColorPicker(
                  labelTypes: [],
                  colorPickerWidth: 248,
                  pickerColor: chk == 1 ? ui.font : 
                  chk==0?ui.bg:chk==2?ui.grad1:ui.grad2,
                  onColorChanged: (color) {
                    setState(() {
                      if (chk == 1)
                        ui.font = color;
                      else if (chk == 0)
                        ui.bg = color;
                      else if (chk == 2) ui.grad1 = color;
                      else if (chk == 3) ui.grad2 = color;
                    });
                  }),
            ),
            //icon: const Icon(Icons.delete),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  void _initSpeech() async {
    _speechEnabled = await stt.initialize();
    setState(() {});
  }

  void _startListening() async {
    await stt.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await stt.stop();
    setState(() {});
  }

  void _onSpeechResult(var result) {
    setState(() {
      rec = false;
      control.text = result.recognizedWords;
    });
  }
}

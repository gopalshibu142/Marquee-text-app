import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:animations/animations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:quickalert/quickalert.dart';

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
  @override
  void initState() {
    ui = Ui();
    control = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

  Container maarquee() {
    var txt;
    txt = " " * 20 + control.text;
    return Container(
      color: ui.bg,
      child: RotatedBox(
        quarterTurns: 1,
        child: Center(
          child: Marquee(
            velocity: 200,
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
                  pickerColor: chk == 1 ? ui.font : ui.bg,
                  onColorChanged: (color) {
                    setState(() {
                      if (chk == 1)
                        ui.font = color;
                      else
                        ui.bg = color;
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
}

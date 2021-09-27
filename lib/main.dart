// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Transmitter",
    home: SafeArea(child: Transmiter()),
  ));
}

class Transmiter extends StatelessWidget {
  const Transmiter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: TransmitterApp()),
    );
  }
}

class TransmitterApp extends StatefulWidget {
  const TransmitterApp({Key? key}) : super(key: key);

  @override
  _TransmitterAppState createState() => _TransmitterAppState();
}

class _TransmitterAppState extends State<TransmitterApp> {
  num xDeltaLeftAnalog = 0;
  num yDeltaLeftAnalog = 0;

  num powerMaju = 0;
  num powerMundur = 0;
  num powerLeft = 0;
  num powerRight = 0;

  double _currentSliderValue = 40.0;

  void setDetailAnalog(_analog, details) {
    xDeltaLeftAnalog = details.delta.dx.round();
    yDeltaLeftAnalog = details.delta.dy.round();

    powerMaju = yDeltaLeftAnalog < 0 ? powerMaju += 1 : powerMaju;
    powerMundur = yDeltaLeftAnalog > 0 ? powerMundur += 1 : powerMundur;

    while (powerMaju > 100) {
      powerMaju = 100;
      break;
    }

    while (powerMundur > 100) {
      powerMundur = 100;
      break;
    }

    while (_analog == 'right'){
      powerMaju = powerMundur > 0 && powerMaju > 0 && yDeltaLeftAnalog > 0 ? powerMaju -=1 : powerMaju;
      powerMundur = powerMaju > 0 && powerMundur > 0 && yDeltaLeftAnalog < 0 ? powerMundur -=1 : powerMundur;
      break;
    }
  }

  void stopAnalog() {
    powerMaju = 0;
    powerMundur = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Draggable(
            child: Analog(),
            feedback: AnalogPin(),
            childWhenDragging: AnalogBackside(),
            onDragUpdate: (details) {
              setState(() {
                setDetailAnalog('left',details);
              });
            },
            onDragEnd: (details) => stopAnalog(),
          ),
        ),
        Flexible(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Delta Positon   : (" +
                xDeltaLeftAnalog.toString() +
                "," +
                yDeltaLeftAnalog.toString() +
                ')'),
            Text(" "),
            Text("Power Maju : " +
                powerMaju.toString() +
                " Power Mundur : " +
                powerMundur.toString()),
            Slider(value: powerMaju.toDouble(), min: 0, max: 100, onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
                print(value.round());
              });
            },)
          ],
        ),
        ),
        
        Align(
            alignment: Alignment.bottomLeft,
            child: Draggable<int>(
              data: 0,
              child: Analog(),
              feedback: AnalogPin(),
              childWhenDragging: AnalogBackside(),
              onDragUpdate: (details) {
                setState(() {
                  setDetailAnalog('right',details);
                });
              },
            )),
      ],
    );
  }
}

// Analog
class Analog extends StatelessWidget {
  const Analog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Analog kiri
      child: Container(
        // padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.all(20.0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
      ),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
      width: 150,
      height: 150,
    );
  }
}

class AnalogBackside extends StatelessWidget {
  const AnalogBackside({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Analog kiri
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
      width: 150,
      height: 150,
    );
  }
}

class AnalogPin extends StatelessWidget {
  const AnalogPin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Analog kiri
      child: Container(
        // padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.all(20.0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
      ),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(shape: BoxShape.circle),
      width: 150,
      height: 150,
    );
  }
}

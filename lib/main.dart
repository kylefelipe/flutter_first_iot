import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter + IoT :):):)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int luz = 0;
  int temperatura = 0;

  static const subscriber = const MethodChannel('flutter.native/subscriber');

  _MyHomePageState() {
    subscriber.setMethodCallHandler(myUtilsHandler);
  }

  Future myUtilsHandler(MethodCall call) {
    Map<String, dynamic> data = jsonDecode(call.arguments);
        setState(() {
          this.luz = data["luz"];
          this.temperatura = data["temperatura"];
        });
  }

  Future<String> getData(int action) async {
    print(Uri.encodeFull("https://ps.pndsn.com/publish/pub.../sub.../0/flutter_iot_lamp/0/{\"action\":$action}?uuid=db9c5e39-7c95-40f5-8d71-125765b6f561"));
    http.Response response = await http.get(
        Uri.encodeFull("https://ps.pndsn.com/publish/pub.../sub.../0/flutter_iot_lamp/0/{\"action\":$action}?uuid=db9c5e39-7c95-40f5-8d71-125765b6f561"),
    );

    print(response.body);
  }

  void _turnOn() {
    getData(1);
  }

  void _turnOff() {
    getData(0);
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SizedBox(
                height: 100,
                child: Card(
                  elevation: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _turnOn,
                        child: Text(
                            'ON',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                      RaisedButton(
                        onPressed: _turnOff,
                        child: Text(
                            'OFF',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            SizedBox(
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Sensor de Luz',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('$luz'),
                      leading: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue[500],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Sensor de Temperatura:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('$temperatura C'),
                      leading: Icon(
                        Icons.toys,
                        color: Colors.blue[500],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

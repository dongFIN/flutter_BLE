import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // flutterBlue.startScan(timeout: Duration(seconds: 2));
    // flutterBlue.stopScan();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'BLE test Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String ble_text = "ble rssi show";
  String temp_text = "";
  int cnt_scan = 0;

  void _incrementCounter() async {
    print("================================================");
    // Start scanning

    await flutterBlue.startScan(timeout: Duration(seconds: 1));
    cnt_scan = 0;
    temp_text = "";
    // Listen to scan results
    dynamic subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      cnt_scan++;
      print('===> ${cnt_scan}');
      for (ScanResult r in results) {
        if(r.device.name != ""){
          print('${r.device.name} found! rssi: ${r.rssi}');
          temp_text += '${r.device.name}: ${r.rssi}\n';
        }
      }
    });

    // Stop scanning
    await flutterBlue.stopScan();
    setState(() {
      ble_text = temp_text;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '按下按鈕以重新量測：',
            ),
            Text(
              '$ble_text',
              style: Theme.of(context).textTheme.headline6, 
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

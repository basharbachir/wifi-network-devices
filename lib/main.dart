import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'dart:async';
import 'package:ping_discover_network/ping_discover_network.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

void devicesList()async{

  final String ip = await Wifi.ip;
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  final int port = 80;

  final stream = NetworkAnalyzer.discover(subnet, port);
  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print('Found device: ${addr.ip}');
    }
  });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '80');

  void devicesList()async{

    setState(() {
      isDiscovering = true;
      devices.clear();
      found = 0;
    });

    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final int port = 80;

    setState(() {
      localIp = ip;
    });

    final stream = NetworkAnalyzer.discover(subnet, port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        found += 1;
        print(found);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Discover Local Network', style: TextStyle(color: Color(0xFF5B16D0))),
          backgroundColor: Color(0xFFCCFF90),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    Color(0xFFCCFF90),
                    Color(0xFFB2FF59),
                    Color(0xFF43A047),
                    Color(0xFF388E3C),
                  ],
                ),
              ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: portController,
                  style: TextStyle(fontSize: 16, color: Color(0xFF5B16D0)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    hintText: 'Port',
                  ),
                ),
                SizedBox(height: 10),
                Text('Local ip: $localIp', style: TextStyle(fontSize: 20, color: Color(0xFF5B16D0))),
                SizedBox(height: 15),
                RaisedButton(
                  elevation: 1,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
                    color: Color(0xFF5B16D0),
                    child: Text(
                        '${isDiscovering ? 'Discovering...' : 'Discover'}',
                        style: TextStyle(fontSize: 16, color: Colors.white)),

                    onPressed: isDiscovering ? null : () => devicesList()),
                SizedBox(height: 15),
                found >= 0
                    ? Text('Found device(s)',
                    style: TextStyle(fontSize: 16))
                    : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: found,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.devices),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${devices[index]}:${portController.text}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

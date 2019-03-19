import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/constants/AppContstant.dart';
import 'package:flutter_app_challenge/customUi/Shimmer.dart';
import 'package:flutter_app_challenge/ui/view/SettingsView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Center(
          child: InkWell(
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                ),
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.red,
                  child: Text(
                    welcomeTextLabel,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

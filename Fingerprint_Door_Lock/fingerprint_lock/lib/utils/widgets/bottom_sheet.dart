import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  _CustomBottomSheet createState() => _CustomBottomSheet();
}

class _CustomBottomSheet extends State<CustomBottomSheet> {
  bool _showSecond = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        Navigator.of(context).pop();
      },
      builder: (BuildContext context) => AnimatedContainer(
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: AnimatedCrossFade(
            firstChild: Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height - 350),
//remove constraint and add your widget hierarchy as a child for first view
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: () => setState(() => _showSecond = true),
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Suivant"),
                    ],
                  ),
                ),
              ),
            ),
            secondChild: Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height / 3),
//remove constraint and add your widget hierarchy as a child for second view
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: () => setState(() => _showSecond = false),
                  color: Colors.green,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("ok"),
                    ],
                  ),
                ),
              ),
            ),
            crossFadeState: _showSecond
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 400)),
        duration: Duration(milliseconds: 400),
      ),
    );
  }
}

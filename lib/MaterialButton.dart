import 'package:flutter/material.dart';


class CalcButton extends StatelessWidget {
  final String text;
  final Function callback;


  const CalcButton({
     Key? key,
    required this.text,
    required this.callback,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Container(
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0,2.0),
                  blurRadius: 8.0,
                  spreadRadius: 1.0
              ),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2.0,-2.0),
                  blurRadius: 8.0,
                  spreadRadius: 1.0
              ),
            ],
          ),
          child: MaterialButton(
            padding: EdgeInsets.all(21.0),
            onPressed: () { callback(text);},
            child: Text(text, style: TextStyle(
                fontSize: 22.0,
            ),),

          ),
        )
    );
  }
}

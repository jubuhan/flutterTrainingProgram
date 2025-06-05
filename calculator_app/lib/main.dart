import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
      ),
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '=') {
        try {
          result = calculateResult(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  String calculateResult(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    final parsedExpression = expression.replaceAllMapped(
      RegExp(r'(\d+\.?\d*)([\+\-\*/])(\d+\.?\d*)'),
      (match) {
        double num1 = double.parse(match.group(1)!);
        double num2 = double.parse(match.group(3)!);
        String op = match.group(2)!;
        double res = 0;
        switch (op) {
          case '+':
            res = num1 + num2;
            break;
          case '-':
            res = num1 - num2;
            break;
          case '*':
            res = num1 * num2;
            break;
          case '/':
            if (num2 == 0) throw Exception("Divide by zero");
            res = num1 / num2;
            break;
        }
        return res.toString();
      },
    );
    return parsedExpression;
  }

  Widget buildButton(String text, {Color? color}) {
    return ElevatedButton(
      onPressed: () => buttonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[850],
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 32, color: Colors.white70)),
                  SizedBox(height: 10),
                  Text(result, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          ...buttons.map(
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((text) {
                Color color = ['÷', '×', '-', '+', '='].contains(text)
                    ? Colors.deepPurple
                    : (text == 'C' ? Colors.red : Colors.grey[800]!);
                return buildButton(text, color: color);
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

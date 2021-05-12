import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
        scaffoldBackgroundColor: Color(0xff000002),
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int genderStatus = -1;
  int weight = 0;
  int height = 0;
  int age = 0;

  void setGender(int status) {
    setState(() {
      genderStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'BMI Calculator',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text('Gender'),
            SizedBox(height: 8),
            Row(
              children: [
                genderView(0, genderStatus == 0),
                SizedBox(width: 16),
                genderView(1, genderStatus == 1),
              ],
            ),
            SizedBox(height: 24),
            Text('Weight'),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: numberField(0)),
                SizedBox(width: 12),
                unitField(0)
              ],
            ),
            SizedBox(height: 24),
            Text('Height'),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: numberField(1)),
                SizedBox(width: 12),
                unitField(1)
              ],
            ),
            SizedBox(height: 24),
            Text('Age'),
            SizedBox(height: 12),
            numberField(2),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Detail(
                    bmi: weight / pow(height / 100, 2),
                  );
                }));
              },
              child: Text('Calculate'),
            )
          ],
        ),
      ),
    );
  }

  Container unitField(int status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton(
        value: status == 0 ? 'Kg' : 'cm',
        items: [status == 0 ? 'Kg' : 'cm', status == 0 ? 'Ons' : 'mm'].map(
          (value) {
            return DropdownMenuItem(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              value: value,
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget numberField(int status) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(
              'minus.png',
              width: 16,
            ),
            onPressed: () {
              setState(() {
                switch (status) {
                  case 0:
                    weight = max(weight - 1, 0);
                    break;
                  case 1:
                    height = max(height - 1, 0);
                    break;
                  case 2:
                    age = max(age - 1, 0);
                    break;
                }
              });
            },
          ),
          Expanded(
            child: Text(
              '${(status == 0) ? weight : (status == 1) ? height : age}',
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Image.asset(
              'plus.png',
              width: 16,
            ),
            onPressed: () {
              setState(() {
                switch (status) {
                  case 0:
                    weight++;
                    break;
                  case 1:
                    height++;
                    break;
                  case 2:
                    age++;
                    break;
                }
              });
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget genderView(int status, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            genderStatus = status;
          });
        },
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      status == 0 ? 'male.png' : 'female.png',
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      status == 0 ? 'Male' : 'Female',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Image.asset(
                  'check_mark.png',
                  color: isSelected ? Color(0xff1AC46A) : Color(0xff262529),
                ),
                top: 8,
                right: 8,
                height: 16,
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xff333335),
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: Color(0xff1AC46A),
                    width: 2,
                  )
                : Border.all(width: 2),
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  Detail({required bmi});
  late Float bmi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Text(
          'Result',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          bmi.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    ));
  }
}

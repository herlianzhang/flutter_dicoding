import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int genderStatus = 0;

  var weight = TextEditingController();
  var height = TextEditingController();
  var age = TextEditingController();

  var weightUnit = ['Kg', 'Ons'];
  var heightUnit = ['cm', 'mm'];
  var weightValue = 'Kg';
  var heightValue = 'cm';

  @override
  void initState() {
    super.initState();
    weight.text = '0';
    height.text = '0';
    age.text = '0';
  }

  void setGender(int status) {
    setState(() {
      genderStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
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
              SizedBox(height: 52),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    var currWeight = double.parse(weight.text) /
                        (weightValue == weightUnit.first ? 1 : 10);
                    var currHeight = double.parse(height.text) /
                        (heightValue == heightUnit.first ? 100 : 1000);
                    var bmi = currWeight / pow(currHeight, 2);
                    print('bmi = $bmi');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Detail(
                        bmi: bmi,
                      );
                    }));
                  },
                  style: ElevatedButton.styleFrom(primary: Color(0xff1AC46A)),
                  child: Text(
                    'Calculate',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container unitField(int status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton(
        value: status == 0 ? weightValue : heightValue,
        items: (status == 0 ? weightUnit : heightUnit).map(
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
        onChanged: (value) {
          setState(() {
            if (status == 0) {
              weightValue = value.toString();
            } else {
              heightValue = value.toString();
            }
          });
        },
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
                    setText(
                        weight, max(int.parse(weight.text) - 1, 0).toString());
                    break;
                  case 1:
                    setText(
                        height, max(int.parse(height.text) - 1, 0).toString());
                    break;
                  case 2:
                    setText(age, max(int.parse(age.text) - 1, 0).toString());
                    break;
                }
              });
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              controller: (status == 0)
                  ? weight
                  : (status == 1)
                      ? height
                      : age,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              cursorColor: Color(0xff1AC46A),
              onChanged: (value) {
                setState(() {
                  String y;
                  try {
                    y = max(int.parse(value), 0).toString();
                  } catch (e) {
                    y = 0.toString();
                  }
                  switch (status) {
                    case 0:
                      setText(weight, y);
                      break;
                    case 1:
                      setText(height, y);
                      break;
                    case 2:
                      setText(age, y);
                      break;
                  }
                });
              },
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
                    setText(weight, '${int.parse(weight.text) + 1}');
                    break;
                  case 1:
                    setText(height, '${int.parse(height.text) + 1}');
                    break;
                  case 2:
                    setText(age, '${int.parse(age.text) + 1}');
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

  void setText(TextEditingController controller, String text) {
    controller.text = text;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
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
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'check_mark.png',
                    color: isSelected ? Color(0xff1AC46A) : Color(0xff262529),
                  ),
                ),
                top: 8,
                right: 8,
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
  Detail({required this.bmi});
  final double bmi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          SizedBox(height: 32),
          Text(
            'Result',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Your current BMI',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  bmi.toStringAsFixed(2),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xff333335),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 32),
          Text(
            'For your bmi, a normal bmi range would be from 18.5 to 24.9',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: 'Your BMI ',
              style: TextStyle(fontSize: 18),
              children: [
                TextSpan(
                  text: bmi.toStringAsFixed(2),
                  style: TextStyle(
                    color: Color(0xff1AC46A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ', indicating your weight is in the '),
                TextSpan(
                  text: bmi < 18.5
                      ? 'Underweight'
                      : bmi <= 24.9
                          ? 'Normal'
                          : bmi <= 29.9
                              ? 'Overweight'
                              : 'Obese',
                  style: TextStyle(
                    color: Color(0xff1AC46A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' category for adults of your height.'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Maintaining a healthy weight may reduce the risk of chronic diseases associated with overweight and obesity.',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const AbacusCalculatorApp());
}

class AbacusCalculatorApp extends StatelessWidget {
  const AbacusCalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abacus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const AbacusHome(),
    );
  }
}

class AbacusHome extends StatefulWidget {
  const AbacusHome({super.key});

  @override
  State<AbacusHome> createState() => _AbacusHomeState();
}

class _AbacusHomeState extends State<AbacusHome> {
  TextEditingController controller = TextEditingController();
  late String _clearButtonText;
  @override
  void initState() {
    super.initState();
    controller.text = '0';
    _clearButtonText = 'AC';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.orange.shade800,
          elevation: 0,
          leading: const Icon(
            Icons.calculate_rounded,
            // color: Colors.orange.shade800,
            color: Colors.white,
            size: 30,
          ),
          title: const Text(
            "Abacus",
            // style: TextStyle(color: Colors.orange.shade800),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    controller: controller,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.6),
                            style: BorderStyle.solid,
                            width: 0.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 0.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calculatorButtons(_clearButtonText),
                    calculatorButtons('⌫'),
                    calculatorButtons("%"),
                    calculatorButtons("÷"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calculatorButtons('7'),
                    calculatorButtons('8'),
                    calculatorButtons('9'),
                    calculatorButtons("×"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calculatorButtons('4'),
                    calculatorButtons('5'),
                    calculatorButtons('6'),
                    calculatorButtons('-'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calculatorButtons("1"),
                    calculatorButtons("2"),
                    calculatorButtons("3"),
                    calculatorButtons('+'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    calculatorButtons(""),
                    calculatorButtons('0'),
                    calculatorButtons("."),
                    calculatorButtons("="),
                  ],
                ),
              ]),
        ));
  }

  Container calculatorButtons(String ch) {
    const operators = {"×", "÷", '+', '-'};
    const numbers = {"0", ".", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

    // Sets the background color of all buttons to white except for the = sign
    Color getBackgroundColor(String ch) {
      return (ch == "=")
          ? Colors.orange.shade800
          : Colors.white.withOpacity(0.05);
    }

    Color getTextColor(String ch) {
      return numbers.contains(ch)
          ? Colors.black
          : ((ch == "=") ? Colors.white : Colors.orange.shade800);
    }

    getIconText(String ch) {
      return (ch == '⌫')
          ? Icon(Icons.backspace_outlined, color: Colors.orange.shade800)
          : Text(
              ch,
              style: TextStyle(
                color: getTextColor(ch),
                fontSize: operators.contains(ch)
                    ? 35.0
                    : (ch == 'AC' || ch == 'C' ? 25.0 : 30.0),
                fontWeight: FontWeight.normal,
              ),
            );
    }

    return Container(
      margin: const EdgeInsets.all(5.0),
      child: TextButton(
          onPressed: () {
            controller.text = controller.text.replaceFirst(RegExp(r'='), '');
            switch (ch) {
              case 'AC':
              case 'C':
                controller.text = "0";
                break;
              case '⌫':
                controller.text = (controller.text.length == 1)
                    ? '0'
                    : controller.text.substring(0, controller.text.length - 1);
                break;
              case "×":
              case "÷":
              case '+':
              case '-':
                if (controller.text.isNotEmpty) {
                  int lastIndex = controller.text.length - 1;
                  if (operators.contains(controller.text[lastIndex])) {
                    controller.text = controller.text
                            .substring(0, controller.text.length - 1) +
                        ch;
                  } else {
                    controller.text = '${controller.text}$ch';
                  }
                }
                break;
              case '%':
                int lastIndex = controller.text.length - 1;
                if (controller.text.isNotEmpty &&
                    controller.text[lastIndex] != ch &&
                    controller.text[lastIndex] != '.' &&
                    !operators.contains(controller.text[lastIndex])) {
                  // Find the last index of an operator
                  // Example: 3×4÷9
                  // lastOperatorIndex = 3 + 1 -> 4
                  int lastOperatorIndex =
                      controller.text.lastIndexOf(RegExp(r'×|÷|/+|-')) + 1;
                  // Slice out the percentage number and parse it into a double number
                  // Example: 3×4÷9
                  // percentNumber= 9 -> 9.0
                  double percentNumber = double.parse(controller.text
                      .substring(lastOperatorIndex, controller.text.length));

                  // apply change number into its percent 9 -> 0.09
                  // Example: 3×4÷9
                  // percentNumber= 9.0 -> 0.09
                  percentNumber = percentNumber / 100;
                  String expBeforePercent =
                      controller.text.substring(0, lastOperatorIndex);
                  // Example: 3×4÷9
                  // 3×4÷0.09
                  controller.text =
                      '${expBeforePercent}${percentNumber.toString()}';
                }
                break;
              case '=':
                if (operators.contains(
                        controller.text[controller.text.length - 1]) ||
                    controller.text.endsWith('.')) {
                  break;
                }
                String exp = controller.text.replaceAll('=', '0');
                exp = controller.text.replaceAll(operators.elementAt(0), '*');
                exp = exp.replaceAll(operators.elementAt(1), '/');
                double numExp = Parser()
                    .parse(exp)
                    .evaluate(EvaluationType.REAL, ContextModel());
                exp = (numExp == numExp.toInt())
                    ? numExp.toInt().toString()
                    : numExp.toStringAsPrecision(4);
                controller.text = "=$exp";
                break;
              case '.':
                controller.text = '${controller.text}$ch';
                break;
              default:
                controller.text =
                    controller.text == '0' ? ch : '${controller.text}$ch';
            }

            setState(() {
              _clearButtonText = (controller.text == '0') ? 'AC' : 'C';
            });
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(getBackgroundColor(ch)),
          ),
          child: SizedBox(
            child: Center(child: getIconText(ch)),
          )),
    );
  }
}

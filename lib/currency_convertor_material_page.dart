import 'package:http/http.dart'
    as http; // this lib is used to make a web req(API call).
import 'dart:convert'; // This lib is used to convert the JSON data into dart readable data
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// To create a variable that stores the input amount
// To crate a function that multiplies the input money with the value of indian rupee
// to store the value, we get after conversion
// Display the amount.

class CurrencyConvertorMaterialPage extends StatefulWidget {
  const CurrencyConvertorMaterialPage({super.key});
  @override
  State<CurrencyConvertorMaterialPage> createState() =>
      _CurrencyConvertorMaterialPageState();
}

class _CurrencyConvertorMaterialPageState
    extends State<CurrencyConvertorMaterialPage> {
  double result = 0;
  String resultText = "";
  String fromCurrency = "INR";
  String toCurrency = "USD";
  final List<String> currencies = [
    "AUD",
    "BRL",
    "CAD",
    "CHF",
    "CNY",
    "CZK",
    "DKK",
    "EUR",
    "GBP",
    "HKD",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "ISK",
    "JPY",
    "KRW",
    "MXN",
    "MYR",
    "NOK",
    "NZD",
    "PHP",
    "PLN",
    "RON",
    "SEK",
    "SGD",
    "THB",
    "TRY",
    "USD",
    "ZAR",
  ];
  final TextEditingController textEditingController = TextEditingController();

  Future<void> convertCurrency() async {
    final String inputText = textEditingController.text;
    final double? inputAmt = double.tryParse(inputText);

    if (inputAmt == null) {
      setState(() {
        resultText = "That not a NUMBER , you DUMB!!!";
      });
      return;
    }
    if (inputAmt <= 0) {
      setState(() {
        resultText = "Broke!!!";
      });
      return;
    }

    try {
      final url = Uri.parse(
        'https://api.frankfurter.app/latest?base=$fromCurrency',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final double exchangeRate = data['rates'][toCurrency];

        setState(() {
          resultText = "${(inputAmt * exchangeRate).toString()} $toCurrency";
        });
      } else {
        if (kDebugMode) print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // here we have mentioned Border function , so that we can use it below in the code.
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 226, 52, 40),
        width: 2,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      borderRadius: BorderRadius.all(Radius.circular(60)),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 124, 168),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 117, 252),
        title: const Text(
          'Currency Convertor',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resultText.isNotEmpty
                  ? resultText
                  : '₹${result != 0 ? result.toStringAsFixed(2) : 0}',
              style: TextStyle(
                fontSize: 32.2,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: fromCurrency,
                    items: currencies
                        .map(
                          (cur) =>
                              DropdownMenuItem(value: cur, child: Text(cur)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => fromCurrency = val!),
                  ),

                  const Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0, 
                      right: 20.0, 
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    child: Icon(Icons.arrow_forward),
                  ),

                  DropdownButton<String>(
                  
                    value: toCurrency,
                    items: currencies
                        .map(
                          (cur) =>
                              DropdownMenuItem(value: cur, child: Text(cur)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => toCurrency = val!),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  prefixIcon: const Icon(Icons.monetization_on),
                  prefixIconColor: Colors.green,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            // Button

            // raised
            // appears
            TextButton(
              onPressed: convertCurrency,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(100, 50),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

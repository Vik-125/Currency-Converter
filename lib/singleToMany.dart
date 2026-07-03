import 'package:currency_convertor/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:country_flags/country_flags.dart';

class SingleToManyPage extends StatefulWidget {
  const SingleToManyPage({super.key});
  @override
  State<SingleToManyPage> createState() => _SingleToManyPageState();
}

class _SingleToManyPageState extends State<SingleToManyPage> {
  double result = 0;
  String resultText = "";
  String fromCurrency = "USD";
  List<String> toCurrencies = ["INR"];
  bool isLoading = false;

  final Map<String, Map<String, String>> currencyData = {
    "INR": {"name": "Indian Rupee", "country": "IN"},
    "AUD": {"name": "Australian Dollar", "country": "AU"},
    "BRL": {"name": "Brazilian Real", "country": "BR"},
    "CAD": {"name": "Canadian Dollar", "country": "CA"},
    "CHF": {"name": "Swiss Franc", "country": "CH"},
    "CNY": {"name": "Chinese Yuan", "country": "CN"},
    "CZK": {"name": "Czech Koruna", "country": "CZ"},
    "DKK": {"name": "Danish Krone", "country": "DK"},
    "EUR": {"name": "Euro", "country": "EU"},
    "GBP": {"name": "British Pound", "country": "GB"},
    "HKD": {"name": "Hong Kong Dollar", "country": "HK"},
    "HUF": {"name": "Hungarian Forint", "country": "HU"},
    "IDR": {"name": "Indonesian Rupiah", "country": "ID"},
    "ILS": {"name": "Israeli New Sheqel", "country": "IL"},
    "ISK": {"name": "Icelandic Króna", "country": "IS"},
    "JPY": {"name": "Japanese Yen", "country": "JP"},
    "KRW": {"name": "South Korean Won", "country": "KR"},
    "MXN": {"name": "Mexican Peso", "country": "MX"},
    "MYR": {"name": "Malaysian Ringgit", "country": "MY"},
    "NOK": {"name": "Norwegian Krone", "country": "NO"},
    "NZD": {"name": "New Zealand Dollar", "country": "NZ"},
    "PHP": {"name": "Philippine Peso", "country": "PH"},
    "PLN": {"name": "Polish Złoty", "country": "PL"},
    "RON": {"name": "Romanian Leu", "country": "RO"},
    "SEK": {"name": "Swedish Krona", "country": "SE"},
    "SGD": {"name": "Singapore Dollar", "country": "SG"},
    "THB": {"name": "Thai Baht", "country": "TH"},
    "TRY": {"name": "Turkish Lira", "country": "TR"},
    "USD": {"name": "United States Dollar", "country": "US"},
    "ZAR": {"name": "South African Rand", "country": "ZA"},
  };

  final TextEditingController textEditingController = TextEditingController();
  late List<String> currencies = currencyData.keys.toList();

  Future<void> convertCurrency() async {
    final String inputText = textEditingController.text;
    final double? inputAmt = double.tryParse(inputText);

    if (inputAmt == null) {
      setState(() {
        resultText = "That not a number!!!";
      });
      return;
    }
    if (inputAmt <= 0) {
      setState(() {
        resultText = "Broke!!!";
      });
      return;
    }
    if(toCurrencies.isEmpty){
      setState(() {
        resultText = "$inputAmt $fromCurrency";
      });
      return;
    }
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        'https://v6.exchangerate-api.com/v6/$api_key/latest/${fromCurrency.trim()}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> rates = data['conversion_rates'];

        List<String> results = [];
        for (var code in toCurrencies) {
          if (code == fromCurrency) continue;
          double exchangeRate = rates[code];
          double converted = inputAmt * exchangeRate;
          results.add(
            "$inputAmt $fromCurrency = ${converted.toStringAsFixed(2)} $code",
          );
        }
        setState(() {
          resultText = resultText = results.join("\n");
        });
      } else {
        if (kDebugMode) print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error : $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // here we have mentioned Border function , so that we can use it below in the code.
    // For adding styles to the TextField.
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 226, 52, 40),
        width: 2,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      borderRadius: BorderRadius.all(Radius.circular(60)),
    );

    // For adding Style to the Dropdown Buttons.
    final ddButton = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(60)),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 155, 174),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 117, 252),
        title: const Text(
          'Currency Convertor',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                resultText.isNotEmpty
                    ? resultText
                    : '${result != 0 ? result.toStringAsFixed(2) : 0}',
                style: TextStyle(
                  fontSize: 32.2,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ddButton,

                        // First Drop-Down options (i.e for choosing First currency)
                        child: DropdownButton<String>(
                          underline: const SizedBox(),
                          value: fromCurrency,
                          // Add this to prevent the text from overflowing
                          isExpanded: false,
                          items: currencies.map((code) {
                            final data = currencyData[code]!;
                            return DropdownMenuItem(
                              value: code,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryFlag.fromCountryCode(
                                    data['country']!,
                                    height: 20,
                                    width: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text("$code - ${data['name']}"),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => fromCurrency = val!),
                        ),
                      ),

                      SizedBox(height: 5),
                      
                      // Down arrow.
                      Icon(Icons.arrow_downward_rounded),

                      SizedBox(height: 5),
                      // Drop-Down options (i.e for choosing second currency)
                      Column(
                        children: toCurrencies.asMap().entries.map((entry) {
                          int index = entry.key;
                          String selected = entry.value;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: ddButton,
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              value: selected,
                              items: currencies.map((code) {
                                final data = currencyData[code]!;
                                return DropdownMenuItem(
                                  value: code,
                                  child: Row(
                                    children: [
                                      CountryFlag.fromCountryCode(
                                        data['country']!,
                                        height: 20,
                                        width: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text("$code - ${data['name']}"),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  toCurrencies[index] = val!;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      Row(
                        children: [

                          // '+' button for increasing the number of toChange currencies.
                          IconButton(
                            icon: Icon(Icons.add_circle,color: Colors.black,),
                            onPressed: () {
                              setState(() {
                                toCurrencies.add(currencies.first);
                              });
                            },
                          ),

                          // '-' button for decreasing the number of toChange currencies.
                          IconButton(
                            icon: Icon(Icons.remove_circle,color: Colors.black,),
                            onPressed: () {
                              setState(() {
                                if (toCurrencies.isNotEmpty) {
                                  toCurrencies.removeLast();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
              // Space for entering the amount.
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      prefixIcon: const Icon(Icons.move_down_sharp),
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
              ),

              // Animation of the convert button
              TextButton(
                onPressed: isLoading ? null : convertCurrency,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(100, 50),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 300,
                  ), // Smooth fade time
                  child: isLoading
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          key: ValueKey('loading'),
                          children: [
                            Icon(
                              Icons.currency_exchange,
                              size: 18,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Converting...',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      // The last button for allowing convertion to happen.
                      : const Text(
                          'Convert',
                          key: ValueKey('text'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
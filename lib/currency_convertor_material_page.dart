import 'package:http/http.dart'
    as http; // this lib is used to make a web req(API call).
import 'dart:convert'; // This lib is used to convert the JSON data into dart readable data
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:country_flags/country_flags.dart';

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
  bool isLoading = false;

  final Map<String, Map<String, String>> currencyData = {
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
    "INR": {"name": "Indian Rupee", "country": "IN"},
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

    if (toCurrency == fromCurrency) {
      setState(() {
        resultText = "$inputAmt $toCurrency";
      });
    }
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
    setState(() => isLoading = true);

    try {
      //await Future.delayed(const Duration(seconds: 3));
      final url = Uri.parse(
        'https://api.frankfurter.app/latest?base=$fromCurrency',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final double exchangeRate = data['rates'][toCurrency];

        setState(() {
          resultText =
              "${(inputAmt * exchangeRate).toStringAsFixed(2)} $toCurrency";
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
      backgroundColor: const Color.fromARGB(255, 255, 124, 168),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ddButton,
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
                          onChanged: (val) => setState(() => fromCurrency = val!),
                        ),
                      ),
                            
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 0.0,
                          bottom: 0.0,
                        ),
                        child: Icon(Icons.arrow_forward),
                      ),
                            
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ddButton,
                        child: DropdownButton<String>(
                          underline: const SizedBox(),
                          value: toCurrency,
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
                          onChanged: (val) => setState(() => toCurrency = val!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
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
              // Button
          
              // raised
              // appears
              TextButton(
                onPressed: isLoading ? null : convertCurrency,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(100, 50),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300), // Smooth fade time
                  child: isLoading
                      ? const Row(
                          key: ValueKey('loading'),
                          mainAxisSize: MainAxisSize.min,
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
                      : const Text(
                          'Convert',
                          key: ValueKey('text'),
                          style: TextStyle(fontWeight: FontWeight.bold),
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

import 'package:currency_convertor/singleToMany.dart';
import 'package:currency_convertor/singleToSingle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 184, 184),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 136, 230),
        title: Text(
          "Choose Mode",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: commonButtonStyle,
              child: Text(
                "Single To Single Mode",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SingleToSinglePage()),
                );
              },
            ),
            SizedBox(height: 80),
            ElevatedButton(
              style: commonButtonStyle,
              child: Text(
                "Single To Multiple Mode",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SingleToManyPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:plantavor/history.dart';
import 'package:plantavor/prediksi.dart';

class UtamaApp extends StatefulWidget {
  const UtamaApp({Key? key}) : super(key: key);

  @override
  State<UtamaApp> createState() => _UtamaState();
}

class _UtamaState extends State<UtamaApp> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('data');

  Map<dynamic, dynamic> items = {};

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  Future<void> _getDataFromFirebase() async {
    try {
      DatabaseEvent dataSnapshot = await _databaseReference.once();
      String jsonData = jsonEncode(dataSnapshot.snapshot.value!);
      print(
          'Raw data from Firebase: $jsonData'); // Print raw data for debugging
      // Cek apakah jsonData sesuai dengan format JSON yang diharapkan
      if (jsonData.isNotEmpty &&
          jsonData.startsWith('{') &&
          jsonData.endsWith('}')) {
        Map<dynamic, dynamic> data = jsonDecode(jsonData);
        setState(() {
          items = data;
        });
      } else {
        print('Data from Firebase is not in expected JSON format: $jsonData');
      }
    } catch (e) {
      print('Error fetching data from Firebase: $e');
    }
  }

  void _sendDataToPredictEndpoint() {
    http
        .post(
      Uri.parse('https://plantavor.pythonanywhere.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(items),
    )
        .then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Parse JSON dari response body
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      // Navigasi ke halaman Prediksi dengan parameter
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Prediksi(data: {
                  'predicted_plant': 'Kembang Kol',
                  'predicted_time': 60,
                })),
      );
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD89D),
        title: const Text('Halaman Utama'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       color: Color(0xff2b4522),
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child: const Text(
                'Plantavor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Color(0xFA2B4522),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1, // Hanya satu objek karena data tunggal
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: const Text('Realtime Data'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Temperature: ${items['Temperature']}'),
                              Text('Humidity: ${items['Humidity']}'),
                              Text('Soil: ${items['Soil']}'),
                              Text('pH: ${items['pH']}'),
                              Text('LDR: ${items['LDR']}'),
                              Text('unsur N: ${items['unsurN']}'),
                              Text('unsur P: ${items['unsurP']}'),
                              Text('unsur K: ${items['unsurK']}'),
                              // Tambahkan item lain sesuai kebutuhan
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _sendDataToPredictEndpoint();
                },
                child: const Text(
                  "Hasil Prediksi",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFA2B4522),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAFD89D),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const History()),
                  );
                },
                child: const Text(
                  "Riwayat Sensor",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFA2B4522),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

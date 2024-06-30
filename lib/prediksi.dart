import 'package:flutter/material.dart';
import 'package:plantavor/utama.dart';

class Prediksi extends StatefulWidget {
  final Map<String, dynamic> data;
  const Prediksi({Key? key, required this.data}) : super(key: key);
  @override
  State<Prediksi> createState() => _PrediksiState();
}

class _PrediksiState extends State<Prediksi> {
  late String predictedPlant;
  late int predictedTime;

  @override
  void initState() {
    super.initState();
    // Mendapatkan data dari widget
    predictedPlant = widget.data['predicted_plant'];
    predictedTime = widget.data['predicted_time'];
  }

  static const String _title = 'Halaman Prediksi';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD89D),
        title: const Text(_title),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       color: Color(0xff2b4522),
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context); // Kembali ke halaman sebelumnya
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child: const Text(
                'Prediksi Plantavor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Color(0xFA2B4522),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child: const Text(
                'Rekomendasi Tanaman',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFA2B4522),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$predictedPlant\n',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child: const Text(
                'Waktu Tanam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFA2B4522),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$predictedTime hari',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ffi';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  static const String _title = 'Halaman Riwayat ';

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _currentIndex = 0;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('historical_data');

  Map<String, dynamic> items = {};

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
        Map<String, dynamic> data = jsonDecode(jsonData);
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

  String selectedDate = '';
  Map<String, dynamic> selectedData = {};
  List<String> times = [];
  List<int> unsurNValues = [];
  List<int> unsurPValues = [];
  List<int> unsurKValues = [];
  List<String> SuhuValues = [];
  List<double> PHValues = [];
  List<int> KelembapanValues = [];
  Map<String, int> resultN = {};
  Map<String, int> resultP = {};
  Map<String, int> resultK = {};
  Map<String, double> resultTemperatur = {};
  Map<String, double> resultpH = {};
  Map<String, int> resultSoil = {};
  @override
  Widget build(BuildContext context) {
    List<String> dates = items.keys.toList();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: History._title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFAFD89D),
          title: const Text(History._title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xff2b4522),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(1),
                child: const Text(
                  'Riwayat Sensor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: Color(0xFA2B4522),
                  ),
                ),
              ),
              DropdownButtonFormField(
                value: selectedDate.isNotEmpty ? selectedDate : dates[0],
                items: dates.map((String date) {
                  return DropdownMenuItem(
                    value: date,
                    child: Text(date),
                  );
                }).toList(),
                onChanged: (String? selectedValue) {
                  setState(() {
                    selectedDate = selectedValue ?? dates[0];
                    selectedData = items[selectedDate] ?? items[dates[0]];
                    times = selectedData.keys.toList();
                    unsurNValues = selectedData.values
                        .map((entry) => entry['unsurN'])
                        .where((value) => value != null)
                        .cast<int>()
                        .toList();
                    unsurPValues = selectedData.values
                        .map((entry) => entry['unsurP'])
                        .where((value) => value != null)
                        .cast<int>()
                        .toList();
                    unsurKValues = selectedData.values
                        .map((entry) => entry['unsurK'])
                        .where((value) => value != null)
                        .cast<int>()
                        .toList();
                    SuhuValues = selectedData.values
                        .map((entry) => entry['Temperature'])
                        .where((value) => value != null)
                        .cast<String>()
                        .toList();
                    PHValues = selectedData.values
                        .map((entry) => entry['pH'])
                        .where((value) => value != null)
                        .cast<double>()
                        .toList();
                    KelembapanValues = selectedData.values
                        .map((entry) => entry['Soil'])
                        .where((value) => value != null)
                        .cast<int>()
                        .toList();
                    resultN = Map.fromIterables(times, unsurNValues);
                    resultP = Map.fromIterables(times, unsurPValues);
                    resultK = Map.fromIterables(times, unsurKValues);
                    resultTemperatur = Map.fromIterables(times,
                        SuhuValues.map((time) => double.parse(time)).toList());
                    resultpH = Map.fromIterables(times, PHValues);
                    resultSoil = Map.fromIterables(times, KelembapanValues);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pilih Tanggal',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7.0),
                color: const Color(0xFFAFD89D),
                width: double.infinity,
                height: 550,
                child: ContainedTabBarView(
                  tabs: const [
                    Text('N'),
                    Text('P'),
                    Text('K'),
                    Text('Suhu'),
                    Text('pH'),
                    Text('Lembab'),
                  ],
                  views: [
                    Container(child: _buildChart(resultN)),
                    Container(child: _buildChart(resultP)),
                    Container(child: _buildChart(resultK)),
                    Container(child: _buildChart(resultTemperatur)),
                    Container(child: _buildChart(resultpH)),
                    Container(child: _buildChart(resultSoil)),
                  ],
                  onChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(Map<String, dynamic> DataSource) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        LineSeries<String, dynamic>(
          dataSource: DataSource.keys.toList(),
          xValueMapper: (String times, _) => times,
          yValueMapper: (dynamic times, _) => DataSource[times],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plantavor/Loginpage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFAFD89D),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 300),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 45),
                    child: const Text(
                      "Selamat Datang di \n Aplikasi Plantavor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Rebeye',
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color(0xFA2B4522),
                      ),
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage("lib/images/plantavor.png"),
                        ),
                      ),
                      child: const SizedBox(
                        width: 250,
                        height: 200,
                      ),
                    ),
                  ),
                  Container(
                      // margin: const EdgeInsets.fromLTRB(0, 0, 1, 59.5),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          child: const Text("Masuk"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Loginpage()));
                          })),
                ]),
          ),
        )
      ]),
    );
  }
}

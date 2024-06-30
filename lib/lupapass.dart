import 'package:flutter/material.dart';
import 'package:plantavor/loginpage.dart';
import 'package:plantavor/services/auth_service.dart';

// void main() => runApp(const MyApp());

class lupapass extends StatelessWidget {
  const lupapass({super.key});

  static const String _title = 'Halaman Lupa Sandi';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFFAFD89D),
            title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  // String _message = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(1),
                child: const Text(
                  'Plantavor',
                  style: TextStyle(
                      color: Color(0xFA2B4522),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            // Container(
            //     alignment: Alignment.center,
            //     padding: const EdgeInsets.all(1),
            //     child: const Text(
            //       ' ',
            //       style: TextStyle(
            //           color: Color(0xFA2B4522),
            //           fontWeight: FontWeight.w500,
            //           fontSize: 30),
            //     )),
            CircleAvatar(
              radius: 80,
              child: Container(
                height: 170,
                width: 170,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/images/plantavor.png"),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Ubah Kata Sandi',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: () async {
                      AuthService.resetPassword(nameController.text);
                      debugPrint(
                          "Pesan telah dikirim ke email, silakan ubah password di link yang dikirimkan ke email");
                      _showSnackbarReview(false,
                          "Pesan telah dikirim ke email, silakan ubah password di link yang dikirimkan ke email");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFA2B4522)),
                    child: const Text('Ubah Kata Sandi'))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Sudah punya akun?'),
                TextButton(
                  child: const Text(
                    'Masuk',
                    style: TextStyle(color: Color(0xFA2B4522), fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Loginpage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ));
  }

  void _showSnackbarReview(bool isError, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: !isError ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

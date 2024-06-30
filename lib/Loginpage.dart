import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantavor/lupapass.dart';
import 'package:plantavor/signup.dart';
import 'package:plantavor/services/auth_service.dart';
import 'package:plantavor/services/util.dart';
import 'package:plantavor/utama.dart';
import 'package:sign_button/sign_button.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'plantavor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 26, 206, 143)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});
  static const String _title = 'Ayo Masuk';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFAFD89D),
          title: const Text(_title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xff2b4522),
              ),
              onPressed: () {
                // _showAlertDialog(context);
                // Get.back();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // ignore: unused_field
  String _message = '';
  User? user1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 2.5),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(1),
          child: const Text(
            'Halo !! \n Petani Cerdas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              color: Color(0xFA2B4522),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email Pengguna',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kata Sandi',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const lupapass(),
              ),
            );
            //forgot password screen
          },
          child: const Text(
            'Lupa Kata Sandi',
            style: TextStyle(color: Color(0xFA2B4522)),
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              onPressed: () async {
                // print("test");
                if (passwordController.text.isNotEmpty) {
                  // final userLoggedIn =
                  //     await SharedPrefService.getLoggedInUserData();

                  debugPrint(hashPass(passwordController.text));
                  // debugPrint(userLoggedIn.password);
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential userCredential =
                        await auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    User? user1 = userCredential.user;

                    _showSnackbarReview(
                        false, '${user1!.email} Berhasil Masuk');
                    // debugPrint(user1.toString() + " success123");
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UtamaApp(),
                      ),
                    );
                    setState(() {
                      _message = result ?? '';
                    });
                  } catch (e) {
                    _showSnackbarReview(true, 'Password Salah');

                    debugPrint("gagal karena : $e");
                  }
                } else {
                  _showSnackbarReview(
                      true, 'Kolom password tidak boleh kosong');
                }
              },
////// button ke menu utama setelah punya akun
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFA2B4522)),
              child: const Text('Masuk'),
            )),

        /// Sign in With Google
        SignInButton(
          buttonSize: ButtonSize.small,
          onPressed: () async {
            await AuthService.googleSignIn(context);

            // Navigator.pop(context);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UtamaApp(),
              ),
            );
            setState(() {
              _message = result ?? '';
            });
          },
          buttonType: ButtonType.google,
        ),

        ///// Buat Akun
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Belum Punya Akun?'),
            TextButton(
              child: const Text(
                'Buat Akun',
                style: TextStyle(color: Color(0xFA2B4522), fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
                //signup screen
              },
            )
          ],
        )
      ]),
    );
    //     ]
    //   ),
    // );
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

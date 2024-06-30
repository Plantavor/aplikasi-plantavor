import 'package:flutter/material.dart';
import 'package:plantavor/controller/create_new_pass.dart';
import 'package:plantavor/services/pref_service.dart';
import 'package:plantavor/services/util.dart';
// import 'package:haruka1_0/app/data/providers/pref_service.dart';
// import 'package:haruka1_0/app/util/util.dart';
// import 'package:haruka1_0/app/modules/create_new_password/views/create_new_password_view.dart';

class ConfirmPasswordView extends StatefulWidget {
  final String email;
  const ConfirmPasswordView({super.key, required this.email});

  @override
  State<ConfirmPasswordView> createState() => _ConfirmPasswordViewState();
}

class _ConfirmPasswordViewState extends State<ConfirmPasswordView> {
  late TextEditingController _passController;

  void _showSnackbarReview(bool isError, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: !isError ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Password",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: "Masukkan password Anda"),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if (_passController.text.isNotEmpty) {
                  final userLoggedIn =
                      await SharedPrefService.getLoggedInUserData();

                  debugPrint(hashPass(_passController.text));
                  debugPrint(userLoggedIn.password);
                  if (hashPass(_passController.text) == userLoggedIn.password) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewPasswordView(
                          currentPassword: _passController.text,
                          email: widget.email,
                        ),
                      ),
                    );
                  } else {
                    _showSnackbarReview(true, 'Password tidak sesuai');
                  }
                } else {
                  _showSnackbarReview(
                      true, 'Kolom password tidak boleh kosong');
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }
}

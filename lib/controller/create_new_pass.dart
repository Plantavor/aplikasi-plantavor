import 'package:flutter/material.dart';
import 'package:plantavor/controller/loading_dialog.dart';
import 'package:plantavor/services/auth_service.dart';
// import '../../../components/loading_dialog.dart';
// import 'package:haruka1_0/app/data/providers/auth_service.dart';
// import 'package:haruka1_0/app/modules/wrapper/views/wrapper.dart';

class CreateNewPasswordView extends StatefulWidget {
  final String email;
  final String currentPassword;
  const CreateNewPasswordView(
      {super.key, required this.email, required this.currentPassword});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final _key = GlobalKey<FormState>();

  late TextEditingController _passController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    super.initState();
    _passController = TextEditingController();
    _confirmPassController = TextEditingController();
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () async {
        Navigator.pop(context);
        LoadingDialog.showLoadingDialog(context);
        var result = await AuthService.changePassword(
            widget.email, widget.currentPassword, _passController.text);

        if (!mounted) return;
        // ignore: use_build_context_synchronously
        LoadingDialog.dismissDialog(context);
        if (result) {
          _showSnackbar(false, 'Pengubahan password berhasil');
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Wrapper(),
          //     ),
          //     ((route) => false));
        } else {
          _showSnackbar(true, 'Terjadi kesalahan silahkan coba kembali nanti');
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Konfirmasi password"),
      content: const Text("Apakah Anda yakin ingin mengubah passord anda?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showSnackbar(bool isError, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: !isError ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Password",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Masukkan password baru Anda"),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong';
                    } else if (value.length < 8) {
                      return 'Password setidaknya harus terdiri dari 8 karakter';
                    }
                    return null;
                  })),
              const SizedBox(height: 30),
              const Text(
                "Konfirmasi Password",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "Konfirmasi password baru Anda"),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Field tidak boleh kosong';
                  } else if (value.length < 8) {
                    return 'Password setidaknya harus terdiri dari 8 karakter';
                  }
                  return null;
                }),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    if (_confirmPassController.text != _passController.text) {
                      _showSnackbar(true, 'Konfirmasi password tidak sama');
                    } else {
                      _showAlertDialog(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

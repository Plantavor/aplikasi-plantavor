import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantavor/constant/color.dart';
import 'package:plantavor/controller/theme_controller.dart';
import 'package:plantavor/model/user.dart';
import 'package:plantavor/services/auth_service.dart';
import 'package:plantavor/services/firestore_service.dart';
import 'package:get/get.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final DatabaseReference = FirebaseDatabase.instance.ref();..... ???
  final db = FirebaseFirestore.instance;
  // List<Data> dataList = []; ----  ???
  // final themeController = Get.find<AppTheme>();
  final themeController = Get.put(AppTheme());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final _key = GlobalKey<FormState>();

  final FocusNode _emailFieldFocus = FocusNode();
  final FocusNode _passwordFieldFocus = FocusNode();
  final FocusNode _noFieldFocus = FocusNode();
  final FocusNode _namaFieldFocus = FocusNode();

  Color _emailDarkColor = AppColor.darkFormFillColor;
  Color _passwordDarkColor = AppColor.darkFormFillColor;
  Color _emailLightColor = AppColor.lightFormFillColor;
  Color _passwordLightColor = AppColor.lightFormFillColor;

  Color _noDarkColor = AppColor.darkFormFillColor;
  Color _namadDarkColor = AppColor.darkFormFillColor;
  Color _noLightColor = AppColor.lightFormFillColor;
  Color _namaLightColor = AppColor.lightFormFillColor;

  bool _obscureText = true;

  final OutlineInputBorder _outlineBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _noController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailFieldFocus.addListener(() {
      if (_emailFieldFocus.hasFocus) {
        setState(() {
          _emailLightColor = AppColor.lightFormfillFocusColor;
          _emailDarkColor = AppColor.darkFormFillFocusColor;
        });
      } else {
        setState(() {
          _emailLightColor = AppColor.lightFormFillColor;
          _emailDarkColor = AppColor.darkFormFillColor;
        });
      }
    });
    _passwordFieldFocus.addListener(() {
      if (_passwordFieldFocus.hasFocus) {
        setState(() {
          _passwordLightColor = AppColor.lightFormfillFocusColor;
          _passwordDarkColor = AppColor.darkFormFillFocusColor;
        });
      } else {
        setState(() {
          _passwordLightColor = AppColor.lightFormFillColor;
          _passwordDarkColor = AppColor.darkFormFillColor;
        });
      }
    });
    _noFieldFocus.addListener(() {
      if (_noFieldFocus.hasFocus) {
        setState(() {
          _noLightColor = AppColor.lightFormfillFocusColor;
          _noDarkColor = AppColor.darkFormFillFocusColor;
        });
      } else {
        setState(() {
          _noLightColor = AppColor.lightFormFillColor;
          _noDarkColor = AppColor.lightFormFillColor;
        });
      }
    });
    _namaFieldFocus.addListener(() {
      if (_namaFieldFocus.hasFocus) {
        setState(() {
          _namaLightColor = AppColor.lightFormfillFocusColor;
          _namadDarkColor = AppColor.darkFormFillFocusColor;
        });
      } else {
        setState(() {
          _namaLightColor = AppColor.lightFormFillColor;
          _namadDarkColor = AppColor.darkFormFillColor;
        });
      }
    });
    super.initState();
  }

  Widget _formField(TextEditingController controller, String hint,
      FocusNode focusNode, Color color, bool obscure,
      {String? Function(String?)? validate,
      TextInputType? inputType,
      Widget? suffix}) {
    return Container(
      width: 256,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          focusNode: focusNode,
          obscureText: obscure,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: color,
              focusedBorder: _outlineBorder,
              enabledBorder: _outlineBorder,
              errorBorder: _outlineBorder,
              focusedErrorBorder: _outlineBorder,
              suffixIcon: suffix),
          validator: validate ??
              (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'BUILD SIGN UP ======================================================');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 19, top: 78, bottom: 34),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFA2B4522)),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                const Text(
                  'Halaman Buat Akun',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 53,
                ),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      Obx(
                        () => _formField(
                            _namaController,
                            'Nama Pengguna',
                            _namaFieldFocus,
                            themeController.isDarkMode.value
                                ? _namadDarkColor
                                : _namaLightColor,
                            false),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => _formField(
                          _emailController,
                          'Email',
                          _emailFieldFocus,
                          themeController.isDarkMode.value
                              ? _emailDarkColor
                              : _emailLightColor,
                          false)),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => _formField(
                              _noController,
                              'No. telfon',
                              _noFieldFocus,
                              themeController.isDarkMode.value
                                  ? _noDarkColor
                                  : _noLightColor,
                              false, validate: (value) {
                            if (value!.isEmpty) {
                              return 'Tidak boleh kosong';
                            } else if (value.length < 11) {
                              return 'Nomor telfon minimal 11 number';
                            } else if (value.length > 12) {
                              return 'Nomor telfon Maksimal 12 number';
                            }
                            return null;
                          }, inputType: TextInputType.number)),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(
                        () => _formField(
                          _passwordController,
                          'Kata Sandi',
                          _passwordFieldFocus,
                          themeController.isDarkMode.value
                              ? _passwordDarkColor
                              : _passwordLightColor,
                          _obscureText,
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: _obscureText
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : AppColor.lightPrimaryColor,
                                    size: 18,
                                  )
                                : Icon(
                                    Icons.visibility_outlined,
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : AppColor.lightPrimaryColor,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 41,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      try {
                        print('Buat Akun');
                        await AuthService.signUp(
                                _emailController.text, _passwordController.text)
                            .then(
                          (value) => FirestoreService.addUserDataToFirestore(
                            value,
                            userData: UserData(
                              uid: value!.uid,
                              name: _namaController.text,
                              email: _emailController.text,
                              no: _noController.text,
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'Kata sandi lemah') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("AlertDialog Title"),
                              content: const Text(
                                  "This is the content of the AlertDialog"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                          // alertDialog(
                          //     context,
                          //     'Invalid Password',
                          //     'Password must contain atleast 6 character. Please try again with the correct password'));
                        } else if (e.code == 'Email tidak valid') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("AlertDialog Title"),
                              content: const Text(
                                  "This is the content of the AlertDialog"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),

                            // alertDialog(
                            //     context,
                            //     'Invalid Email',
                            //     'Please try again with the correct email! format')
                          );
                        } else if (e.code == 'email sudah digunakan') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("AlertDialog Title"),
                              content: const Text(
                                  "This is the content of the AlertDialog"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),

                            // alertDialog(
                            //     context,
                            //     'Invalid Email',
                            //     'Please try again with the correct email! format')
                          );
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => alertDialog(
                          //       context,
                          //       'Email Alredy Exists',
                          //       'The email provided is already in use by an existing user. Please sign in with your registered email'),
                          // );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("AlertDialog Title"),
                              content: const Text("Email already Exist"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),

                            // alertDialog(
                            //     context,
                            //     'Invalid Email',
                            //     'Please try again with the correct email! format')
                          );
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                      print('sukses');
                    }
                  },
                  child: Container(
                    height: 36,
                    width: 256,
                    decoration: BoxDecoration(
                        color: const Color(0xFA2B4522),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(2, 5))
                        ]),
                    child: const Center(
                      child: Text(
                        'Buat Akun',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 111,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

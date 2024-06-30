// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantavor/services/firestore_service.dart';
import 'package:plantavor/services/pref_service.dart';
import 'package:plantavor/services/shared_pref.dart';
import 'package:plantavor/services/util.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:terature/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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
    );
  }
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // static Future<FirebaseApp> initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  // }
  //...................................
  // static final Facebook
  // static Future<bool> updateLoggedUserPassword(
  //     String uid, String newPassword) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(uid)
  //         .update({'password': newPassword});
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  static Future<bool> changePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      var user = FirebaseAuth.instance.currentUser!;

      final cred =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword);
        FirestoreService.updateLoggedUserPassword(
            user.uid, hashPass(newPassword));
        SharedPrefService.setNewPassword(hashPass(newPassword));
      });
      return true;
    } catch (e) {
      debugPrint("Password can't be changed$e");
      return false;
    }
  }

  static Future<User?> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User? firebaseUser = userCredential.user;

    return firebaseUser;
  }

  static Future<User?> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    User? firebaseUser = userCredential.user;

    return firebaseUser;
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> signOut() async {
    await _auth.signOut();

    await _googleSignIn.signOut();
    // await _f
  }

  static Future<String> getUserLoggedInName() async {
    final prefs = await SharedPreferences.getInstance();

    String? encodedMap = prefs.getString('loggedUser');
    Map<String, dynamic> decodedMap = json.decode(encodedMap!);
    debugPrint(decodedMap["name"]);
    return decodedMap["name"];
  }

  static Future<void> googleSignIn(BuildContext context) async {
    print('awal1');
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      print('awal2');
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);
        print('success');

        await FirestoreService.addUserDataToFirestore(userCredential.user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        print("account-exists-with-different-credential");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text('Error'),
                content: Text(e.message!),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      )),
                  // TextButton(
                  //     onPressed: () async {
                  //       Navigator.pop(context);
                  //       List<String> emailList = await FirebaseAuth.instance
                  //           .fetchSignInMethodsForEmail(e.email!);
                  //       // if (emailList.first == "facebook.com") {
                  //       //   await facebookSignIn(context);
                  //       // }
                  //     },
                  //     child: const Text('Ok'))
                ],
              );
            });
      }
    } catch (e) {
      print('not success');
      print(e.toString());
    }
  }

  // static Future<void> facebookSignIn(BuildContext context) async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       AuthCredential authCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);

  //       UserCredential userCredential =
  //           await _auth.signInWithCredential(authCredential);
  //       print("Success");
  //       await FirestoreService.addUserDataToFirestore(userCredential.user);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'account-exists-with-different-credential') {
  //       print("account-exists-with-different-credential");
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               title: const Text('Error'),
  //               content: Text(e.message!),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text(
  //                       'Cancel',
  //                       style: TextStyle(color: Colors.red),
  //                     )),
  //                 TextButton(
  //                     onPressed: () async {
  //                       Navigator.pop(context);
  //                       List<String> emailList = await FirebaseAuth.instance
  //                           .fetchSignInMethodsForEmail(e.email!);
  //                       if (emailList.first == "google.com") {
  //                         // await googleSignIn(context);
  //                         await googleSignIn(context);
  //                       }
  //                     },
  //                     child: const Text('Ok'))
  //               ],
  //             );
  //           });
  //     }
  //   } catch (e) {
  //     print("Not success");
  //     print(e.toString());
  //   }
  // }

  static Stream<User?> get firebaseUserStream => _auth.authStateChanges();
}

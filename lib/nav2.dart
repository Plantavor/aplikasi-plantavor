import 'package:plantavor/Loginpage.dart';
import 'package:plantavor/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plantavor/utama.dart';

import '../controller/navbar_controller.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  final _controller = Get.put(NavBarController());
  final List<Widget> _listPage = [
    const Loginpage(),
    const UtamaApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _controller.currentTab.value,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: 'View Data'),
            BottomNavigationBarItem(
                icon: Icon(Icons.update), label: 'Update Data'),
            BottomNavigationBarItem(
                icon: Icon(Icons.input_outlined), label: 'Input Data'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_array), label: 'View File'),
          ],
          onTap: (value) => _controller.pageChange(value),
        ),
        body: _listPage.elementAt(_controller.currentTab.value),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () => Get.back(),
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () async {
        Get.back();
        AuthService.signOut();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Apakah Anda yakin ingin log out?"),
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
}

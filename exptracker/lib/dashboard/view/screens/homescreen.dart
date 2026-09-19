import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/bottom_navbar_provider.dart';
import 'package:exptracker/dashboard/view/screens/dashboardscreen.dart';
import 'package:exptracker/dashboard/view/screens/historyscreen.dart';
import 'package:exptracker/dashboard/view/screens/settingsscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  final List<Widget> screens = const [
    Dashboardscreen(),
    Historyscreen(),
    Settingsscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[context.watch<BottomNavbarProvider>().selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Commoncolors.primaryColor,
        currentIndex: context.read<BottomNavbarProvider>().selectedIndex,
        onTap: (index) {
          context.read<BottomNavbarProvider>().updateSelectedIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: context.watch<BottomNavbarProvider>().selectedIndex,
        onDestinationSelected: (index) {
          context.read<BottomNavbarProvider>().updateSelectedIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Home",
          ),
          NavigationDestination(icon: Icon(Icons.history), label: "History"),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

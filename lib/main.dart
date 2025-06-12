import 'package:flutter/material.dart';
import 'package:reviewall_mobile/screeens/home/home_screen.dart';
import 'package:reviewall_mobile/screeens/media/media_list_screen.dart';

const baseUrlApi = 'https://67e6f0a56530dbd31111f8e2.mockapi.io/reviewall'; 

const Color primaryGray = Color(0xFF333333); 
const Color secondaryGray = Color(0xFF4D4D4D);
const Color accentGray = Color(0xFF666666);
const Color lightGray = Color(0xFFAAAAAA);
const Color backgroundColor = Color(0xFF222222);

const primaryColor = primaryGray;
const primaryColorLight = secondaryGray;
const secondaryColor = accentGray;
const secondaryColorLight = lightGray;
const fontColor = Colors.white;

void main() {
  runApp(NavigationBarApp());
}

// Navigation
class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: true), home: const NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[

          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.movie_creation_outlined),
            label: 'Mídias',
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home page
            HomeScreen(),

            /// Mídias page
            MediaListScaffold(),

          ][currentPageIndex],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_studegate/screeens/analise_curricular/analise_curricular_screen.dart';
import 'package:mobile_studegate/screeens/boletim/boletim_screen.dart';
import 'package:mobile_studegate/screeens/grade_curricular/grade_curricular_screen.dart';
import 'package:mobile_studegate/screeens/home/home_screen.dart';
import 'package:mobile_studegate/screeens/login/login_screen.dart'; // Supondo que você tenha uma tela de login
import 'package:mobile_studegate/screeens/rematricula_online/rematricula_edit_aluno_screen.dart';
import 'package:mobile_studegate/screeens/rematricula_online/rematricula_online_screen.dart';
import 'package:mobile_studegate/screeens/situacao_academica/situacao_academica_screen.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';


const baseUrlApi = 'http://localhost:8080';

const Color primaryGray = Color(0xFF333333); 
const Color secondaryGray = Color(0xFF4D4D4D);
const Color accentGray = Color(0xFF666666);
const Color lightGray = Color(0xFFAAAAAA);
const Color backgroundColor = Color(0xFF222222);

const primaryColor = Color.fromARGB(255, 38, 74, 179);
const primaryColorLight = secondaryGray;
const secondaryColor = accentGray;
const secondaryColorLight = lightGray;
const fontColor = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'StudeGate',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: authProvider.user != null
                ? const NavigationBarApp()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(useMaterial3: true),
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor, // Cor primária
          secondary: secondaryColor, // Cor secundária
        ),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  // Adicione este método para navegar para uma página específica
  void navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

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
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Boletim',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Grade',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.how_to_reg),
            icon: Icon(Icons.how_to_reg_outlined),
            label: 'Rematrícula',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.insights),
            icon: Icon(Icons.insights_outlined),
            label: 'Análise',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Situação'
          ),

        ],
      ),
      body: <Widget>[
        HomeScreen(onNavigate: navigateToPage),
        BoletimScaffold(),
        GradeCurricularScaffold(),
        EditarAlunoScreen(),
        AnaliseCurricularScaffold(),
        SituacaoAcademicaScaffold(),
      ][currentPageIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_studegate/screeens/home/home_screen.dart';
import 'package:mobile_studegate/screeens/media/media_list_screen.dart';
import 'package:mobile_studegate/screeens/login/login_screen.dart'; // Supondo que você tenha uma tela de login
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


const baseUrlApi = 'http://localhost:8080';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Verificar status de login quando o app iniciar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authProvider.checkLoginStatus();
          });
          
          return MaterialApp(
            title: 'StudeGate',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            // Você pode usar o estado de autenticação para decidir qual tela mostrar
            home: authProvider.isLoggedIn ? NavigationBarApp() : LoginScreen(),
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
      theme: ThemeData(useMaterial3: true),
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
      body: <Widget>[
        HomeScreen(), // Exemplo: botão para deslogar
        MediaListScaffold(),
      ][currentPageIndex],
    );
  }
}

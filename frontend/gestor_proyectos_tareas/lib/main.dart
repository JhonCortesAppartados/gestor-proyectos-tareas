import 'app_providers.dart';
import 'config/dependencias.dart';
import 'presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await dotenv.load();

  runApp(buildAppProviders(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/proyectos': (context) => const ProyectosScreen(),
        '/tareas': (context) => const TareasScreen(),
        '/usuarios': (context) => const UsuariosScreen(),
      },
    );
  }
}

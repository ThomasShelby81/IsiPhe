import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isiphe/data/repository/meals_repository.dart';
import 'package:isiphe/data/repository/user_repository.dart';
import 'package:isiphe/ui/pages/dashboard/dashboard_page.dart';
import 'package:isiphe/ui/screens/login/login_screen.dart';
import 'package:isiphe/data/service/database_service.dart';

import 'business/bloc/authentication_bloc/authentication_bloc.dart';
import 'business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';
import 'business/bloc/meal_bloc/bloc/meal_bloc.dart';
import 'business/bloc/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var databaseService = DatabaseService();

  var userRepository = UserRepository();
  var mealsRepository = MealsRepositoryImpl(databaseService);

  BlocOverrides.runZoned(
      () => runApp(MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AuthenticationBloc(
                    userRepository: UserRepository(),
                  )..add(AuthenticationStarted()),
                  child: MyApp(
                    userRepository: userRepository,
                    mealsRepository: mealsRepository,
                  ),
                ),
              ],
              child: MyApp(
                userRepository: userRepository,
                mealsRepository: mealsRepository,
              ))),
      blocObserver: SimpleBlocObserver());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final MealsRepository _mealsRepository;

  const MyApp(
      {Key? key,
      required UserRepository userRepository,
      required MealsRepository mealsRepository})
      : _userRepository = userRepository,
        _mealsRepository = mealsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: true,
      title: 'Isi Phe',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.lato(
              fontSize: 16,
              textStyle: TextStyle(
                  color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
          headline2: GoogleFonts.lato(
              fontSize: 20,
              textStyle: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        lightSource: LightSource.topLeft,
        depth: 10,
        baseColor: const Color(0xFFFFFFFF),
        /**
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xff6a515e),
          )*/
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure || state is AuthenticationLogout) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is AuthenticationSuccess) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => CurrentDateBloc(_mealsRepository)),
                BlocProvider(create: (context) => MealBloc(_mealsRepository)),
              ],
              child: DashboardPage(
                user: state.user,
                mealsRepository: _mealsRepository,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Loading'),
            ),
          );
        },
      ),
    );
  }
}

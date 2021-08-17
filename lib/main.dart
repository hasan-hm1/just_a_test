import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/data/repositories/announcements_repository.dart';
import 'package:interview_test/data/repositories/auth_repository.dart';
import 'package:interview_test/logic/bloc/announcements_bloc/announcements_bloc.dart';
import 'package:interview_test/logic/bloc/auth_bloc/auth_bloc.dart';
import 'package:interview_test/presentation/screens/announcements/all_announcements_screen.dart';
import 'package:interview_test/presentation/screens/auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthRepository authRepository = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository),
          ),
          BlocProvider(
            create: (_) => AnnouncementsBloc(AnouncementsRepository()),
          ),
        ],
        child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData.light().copyWith(
                    primaryColor: Colors.pink, accentColor: Colors.amber),
                home: FirebaseAuth.instance.currentUser == null
                    ? AuthScreen()
                    : AllAnouncementsScreen(),
              ),
      ),
    );
  }
}

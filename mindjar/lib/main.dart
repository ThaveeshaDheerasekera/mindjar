import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindjar/configs/custom_colors.dart';
import 'package:mindjar/firebase_options.dart';
import 'package:mindjar/repositories/auth_repository.dart';
import 'package:mindjar/repositories/notes_repository.dart';
import 'package:mindjar/screens/login_screen.dart';
import 'package:mindjar/widget/global_widgets/bottom_nav_bar_widget.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthRepository()),
        ChangeNotifierProvider(create: (context) => NotesRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MindJar',
        theme: ThemeData(
          fontFamily: 'Karla',
          colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.olive),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: AuthRepository().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Provider.of<AuthRepository>(context, listen: false)
                  .clearMessage();
              return const BottomNavBarWidget();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

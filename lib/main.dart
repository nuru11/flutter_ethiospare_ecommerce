import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maanstore/screens/Theme/theme.dart';
import 'package:maanstore/screens/home_screens/home.dart';
import 'package:maanstore/screens/splash_screen/splash_screen_one.dart';
import 'package:provider/provider.dart' as pro;
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/language_change_provider.dart';
import 'generated/l10n.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Future.delayed(const Duration(seconds: 3)); 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedTheme = prefs.getString('theme') ?? 'system';
  savedTheme == 'light' ? _themeManager.toggleTheme(false) : _themeManager.toggleTheme(true);
  savedTheme == 'dark' ? _themeManager.toggleTheme(true) : _themeManager.toggleTheme(false);
  savedTheme == 'system' ? _themeManager.toggleTheme(false) : null;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // OneSignal.shared.setAppId(oneSignalAppId);
  runApp(const ProviderScope(child: MyApp()));
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 2...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 1...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('go!');
    FlutterNativeSplash.remove();
  }
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    initialization();
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return pro.ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeManager.themeMode,
          locale: pro.Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Home(),
          supportedLocales: S.delegate.supportedLocales,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}




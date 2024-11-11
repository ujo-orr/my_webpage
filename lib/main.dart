import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/data/service/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'shared/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'Onglyp_harunanum',
        brightness: Brightness.dark,
      ),
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        FlutterQuillLocalizations.delegate, // 추가된 delegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'ui/home.dart';
import 'ui/splash.dart';

void main() {
  runApp(const CadastroPessoasApp());
}

class CadastroPessoasApp extends StatefulWidget {
  const CadastroPessoasApp({super.key});

  @override
  State<CadastroPessoasApp> createState() => _CadastroPessoasAppState();
}

class _CadastroPessoasAppState extends State<CadastroPessoasApp> {
  bool temaEscuro = false;

  void alterarTema(bool valor) {
    setState(() {
      temaEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Pessoas',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(
        onFinish: (context) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                temaEscuro: temaEscuro,
                alterarTema: alterarTema,
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:ecolife/pages/yemek_tahmin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Sayfa importları
import 'package:ecolife/pages/login_screen.dart';
import 'package:ecolife/pages/home_screen.dart';
import 'package:ecolife/pages/profil_screen.dart';
import 'package:ecolife/pages/dolabim_screen.dart';
import 'package:ecolife/pages/tarif_screen.dart';
import 'package:ecolife/pages/skor_screen.dart';
import 'package:ecolife/pages/ulasim_tercihi.dart';
import 'package:ecolife/pages/maps.dart';
import 'package:ecolife/pages/eco_education_screen.dart'; // ✅ Eco Eğitim sayfası importu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase başlatılıyor
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoLife',
      home: const LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(kullaniciAdi: ''),
        '/profil': (context) => const ProfilScreen(),
        '/dolabim': (context) => const DolabimScreen(),
        '/tarif': (context) {
          final route = ModalRoute.of(context);
          if (route != null && route.settings.arguments is List<String>) {
            final args = route.settings.arguments as List<String>;
            return TarifEkrani(malzemeler: args);
          } else {
            return const Scaffold(
              body: Center(child: Text('Beklenen malzemeler listesi bulunamadı.')),
            );
          }
        },
        '/skor': (context) => const SkorScreen(),
        '/ulasim': (context) => const UlasimAsistaniScreen(),
        '/harita': (context) => const HaritaEkrani(),
        '/egitim': (context) => EcoEducationScreen(), // ✅ Eco Eğitim rotası
        '/yemek-tahmin': (context) => const YemekTahminScreen(), // bunu ekle
      },
    );
  }
}

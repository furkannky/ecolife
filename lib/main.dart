import 'package:ecolife/pages/community_screen.dart';
import 'package:ecolife/pages/qr_scanner_screen.dart';
import 'package:ecolife/pages/yemek_tahmin_screen.dart';
import 'package:ecolife/pages/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ecolife/pages/login_screen.dart';
import 'package:ecolife/pages/home_screen.dart';
import 'package:ecolife/pages/profil_screen.dart';
import 'package:ecolife/pages/dolabim_screen.dart';
import 'package:ecolife/pages/tarif_screen.dart';
import 'package:ecolife/pages/skor_screen.dart';
import 'package:ecolife/pages/ulasim_tercihi.dart';
import 'package:ecolife/pages/maps.dart';
import 'package:ecolife/pages/eco_education_screen.dart'; 
import 'package:ecolife/firebase_options.dart';
import 'package:ecolife/constants/app_theme.dart'; // YENİ TEMA EKLENDİ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase başlatılıyor
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoLife',
      theme: AppTheme.lightTheme, // YENİ TEMA UYGULANDI
      home:  LoginScreen(),
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
        '/egitim': (context) => EcoEducationScreen(), 
        '/yemek-tahmin': (context) => const YemekTahminScreen(), 
        '/urun-bilgisi': (context) => UrunBilgisiAlmaEkran(), 
        '/EcoLife Topluluğu': (context) => CommunityScreen(), 
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}

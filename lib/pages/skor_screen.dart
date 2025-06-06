import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkorScreen extends StatefulWidget {
  const SkorScreen({super.key});

  @override
  State<SkorScreen> createState() => _SkorScreenState();
}

class _SkorScreenState extends State<SkorScreen> {
  double karbonSkoru = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getKarbonSkoru();
  }

  // Firestore'dan karbon skorunu almak
  Future<void> _getKarbonSkoru() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          karbonSkoru = userData['karbonSkoru'] ?? 0.0;
          isLoading = false; // Veri alındığında loading durumu bitiyor
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Hata durumunu yönetmek için bir şeyler ekleyebilirsin (örneğin, hata mesajı gösterme)
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.green.shade900,
                    Colors.green.shade800,
                    Colors.green.shade400,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Karbon Skorunuz",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bugünkü Skor",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${karbonSkoru.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Karbon Puanı",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 800),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Haftalık Takip",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700),
                              ),
                              const SizedBox(height: 10),
                              _karbonTakibi("Pazar", 5.0),
                              _karbonTakibi("Pazartesi", 4.5),
                              _karbonTakibi("Salı", 4.0),
                              _karbonTakibi("Çarşamba", 3.8),
                              _karbonTakibi("Perşembe", 4.2),
                              _karbonTakibi("Cuma", 4.0),
                              _karbonTakibi("Cumartesi", 3.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _karbonTakibi(String gun, double puan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(gun, style: const TextStyle(fontSize: 16)),
          Text("${puan.toStringAsFixed(2)} Karbon Puanı",
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String kullaniciAdi = "Furkan Kaya";
  String email = "furkan.kaya@example.com";
  double karbonHedefi = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
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
              const SizedBox(height: 80),
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Profilim",
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
                          "Kullanıcı Adı:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          kullaniciAdi,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Email:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(fontSize: 18),
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
                          "Karbon Hedefi",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700),
                        ),
                        Slider(
                          value: karbonHedefi,
                          min: 0.0,
                          max: 50.0,
                          divisions: 5,
                          label: "${karbonHedefi.toStringAsFixed(0)} g CO2",
                          activeColor: Colors.green.shade700,
                          inactiveColor: Colors.green.shade200,
                          onChanged: (double value) {
                            setState(() {
                              karbonHedefi = value;
                            });
                          },
                        ),
                        Text(
                          "Hedef: ${karbonHedefi.toStringAsFixed(0)} g CO2",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
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
                          "Rozetler",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700),
                        ),
                        const SizedBox(height: 10),
                        _rozetSirasi(Icons.star, Colors.yellow, "Başlangıç Rozeti"),
                        _rozetSirasi(Icons.star, Colors.green, "Yeşil Yıldız Rozeti"),
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

  Widget _rozetSirasi(IconData icon, Color color, String metin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 10),
          Text(metin, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
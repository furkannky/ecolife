import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'forum_screen.dart';
import 'events_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      'EcoLife Topluluğu',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      'Sürdürülebilir bir gelecek için birlikte!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                padding: const EdgeInsets.all(30), // Padding'i artırdık
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30), // Boşluğu artırdık
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: const Text(
                          'Topluluğa Hoş Geldiniz!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                          textAlign: TextAlign.center, // Ortaya hizaladık
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 1500),
                        child: const Text(
                          'Burada sürdürülebilir yaşam için önerilerde bulunabilir, etkinliklere katılabilir ve forumlarda tartışmalara katılabilirsiniz.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center, // Ortaya hizaladık
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 1600),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForumScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Padding'i artırdık
                            backgroundColor: Colors.green.shade700, // Daha belirgin bir renk
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // Daha yuvarlak butonlar
                            ),
                          ),
                          child: const Text(
                            'FORUM - GENEL TARTIŞMALAR',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 1700),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EventsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                            backgroundColor: Colors.lightGreen.shade700, // Farklı bir yeşil tonu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'ETKİNLİKLER - KATILIN',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        duration: const Duration(milliseconds: 1800),
                        child: const Text(
                          'Öne Çıkanlar',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        delay: const Duration(milliseconds: 900),
                        duration: const Duration(milliseconds: 1900),
                        child: Card(
                          elevation: 3, // Gölge ekledik
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Köşeleri yuvarladık
                          child: ListTile(
                            leading: const Icon(Icons.forum, color: Colors.green), // İkon ekledik
                            title: const Text('Sürdürülebilir Yaşam Forumları', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Yaşam tarzınızı daha sürdürülebilir hale getirmek için ipuçları'),
                            trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
                            onTap: () {
                              // Forum ekranına yönlendirme yapılabilir
                            },
                          ),
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        duration: const Duration(milliseconds: 2000),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: const Icon(Icons.event, color: Colors.lightGreen), // Farklı bir ikon
                            title: const Text('Yeşil Ulaşım Etkinliği', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Bölgenizdeki yeşil ulaşım projelerine katılın'),
                            trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
                            onTap: () {
                              // Etkinlik ekranına yönlendirme yapılabilir
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
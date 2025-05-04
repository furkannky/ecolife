import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // HomeScreen'ı import etmeyi unutmayın
import 'maps.dart'; // HaritaEkrani'nı import edin

class UlasimAsistaniScreen extends StatefulWidget {
  const UlasimAsistaniScreen({super.key});

  @override
  _UlasimAsistaniScreenState createState() => _UlasimAsistaniScreenState();
}

class _UlasimAsistaniScreenState extends State<UlasimAsistaniScreen> {
  String? _secilenUlasim; // Kullanıcının seçtiği ulaşım tercihi

  // Karbon emisyon değerleri
  final Map<String, double> _karbonDegerleri = {
    'Bisiklet': 0.0,
    'Yürüyüş': 0.0,
    'Toplu Taşıma': 1.5,
    'Araba': 8.0,
  };

  // Seçilen ulaşım aracına göre karbon puanı hesapla
  double _karbonPuanHesapla(String? ulasimAraci) {
    if (ulasimAraci != null && _karbonDegerleri.containsKey(ulasimAraci)) {
      return _karbonDegerleri[ulasimAraci]!;
    }
    return 0.0;
  }

  // Alternatif ulaşım önerisi
  String _alternatifUlasim(String? ulasimAraci) {
    if (ulasimAraci == 'Araba') {
      return 'Bugün toplu taşıma veya bisiklet kullanmayı deneyin!';
    } else if (ulasimAraci == 'Toplu Taşıma') {
      return 'Bisiklet veya yürüyüş daha çevre dostu bir seçenek!';
    }
    return 'Çevre dostu ulaşım seçimi yaparak karbon ayak izinizi azaltabilirsiniz!';
  }

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
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: const Text(
                    'Yeşil Ulaşım Asistanı',
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
                            'Bugün hangi ulaşım aracını kullanacaksınız?',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: _karbonDegerleri.keys.map((ulasim) {
                              return FadeInLeft(
                                delay: Duration(
                                    milliseconds:
                                        200 * _karbonDegerleri.keys.toList().indexOf(ulasim)),
                                duration: const Duration(milliseconds: 600),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _secilenUlasim = ulasim;
                                      });
                                      // Ana sayfaya gitmek için burayı kaldırın veya yorum satırı yapın
                                      /*Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                            kullaniciAdi: "Kullanıcı Adı", // Burada gerçek kullanıcı adını almalısınız
                                            ulasimTercihi: _secilenUlasim,
                                          ),
                                        ),
                                      );*/
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _secilenUlasim == ulasim
                                          ? Colors.green.shade700
                                          : Colors.blue.shade600,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      minimumSize: const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      ulasim,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_secilenUlasim != null)
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
                              'Seçilen Ulaşım Aracı:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _secilenUlasim!,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Karbon Ayak İzi:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${_karbonPuanHesapla(_secilenUlasim).toStringAsFixed(2)} kg CO₂e',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Öneri:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _alternatifUlasim(_secilenUlasim),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 800),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/harita');
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'Haritayı Görüntüle',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Ana sayfaya dönme butonu (isteğe bağlı)
                if (_secilenUlasim != null)
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 800),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              kullaniciAdi: "Kullanıcı Adı", // Gerçek kullanıcı adını buraya almalısınız
                              ulasimTercihi: _secilenUlasim,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Ana Sayfaya Dön',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
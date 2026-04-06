import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'maps.dart'; 
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class UlasimAsistaniScreen extends StatefulWidget {
  const UlasimAsistaniScreen({super.key});

  @override
  _UlasimAsistaniScreenState createState() => _UlasimAsistaniScreenState();
}

class _UlasimAsistaniScreenState extends State<UlasimAsistaniScreen> {
  String? _secilenUlasim;

  final Map<String, double> _karbonDegerleri = {
    'Bisiklet': 0.0,
    'Yürüyüş': 0.0,
    'Toplu Taşıma': 1.5,
    'Araba': 8.0,
  };

  final Map<String, IconData> _ulasimIkonlari = {
    'Bisiklet': Icons.pedal_bike_rounded,
    'Yürüyüş': Icons.directions_walk_rounded,
    'Toplu Taşıma': Icons.directions_bus_rounded,
    'Araba': Icons.directions_car_rounded,
  };

  double _karbonPuanHesapla(String? ulasimAraci) {
    if (ulasimAraci != null && _karbonDegerleri.containsKey(ulasimAraci)) {
      return _karbonDegerleri[ulasimAraci]!;
    }
    return 0.0;
  }

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
    return OrganicBackground(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
             child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryGreen),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'Yeşil Ulaşım',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: FadeInDown(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: Text(
                  'Bugün hangi ulaşım aracını kullanacaksınız?',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  String ulasim = _karbonDegerleri.keys.elementAt(index);
                  bool isSelected = _secilenUlasim == ulasim;

                  return FadeInLeft(
                    delay: Duration(milliseconds: 100 * index),
                    duration: const Duration(milliseconds: 600),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _secilenUlasim = ulasim;
                          });
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: isSelected
                              ? AppTheme.primaryGreen.withOpacity(0.2)
                              : Colors.white.withOpacity(0.4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryGreen : Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _ulasimIkonlari[ulasim],
                                  color: isSelected ? Colors.white : AppTheme.primaryGreen,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  ulasim,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _karbonDegerleri.keys.length,
              ),
            ),
          ),
          if (_secilenUlasim != null)
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.co2_rounded, size: 40, color: Colors.orangeAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Karbon Ayak İzi:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                              ),
                            ),
                            Text(
                              '${_karbonPuanHesapla(_secilenUlasim).toStringAsFixed(2)} kg',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.orangeAccent),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.tips_and_updates_rounded, color: AppTheme.primaryGreen),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Öneri:',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _alternatifUlasim(_secilenUlasim),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/harita');
                      },
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('Haritayı Görüntüle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (_secilenUlasim != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                kullaniciAdi: "Kullanıcı Adı",
                                ulasimTercihi: _secilenUlasim,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryGreen,
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
    );
  }
}
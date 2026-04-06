import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class KarbonAyakIziBilgiEkrani extends StatelessWidget {
  const KarbonAyakIziBilgiEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return OrganicBackground(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
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
                        'Karbon Ayak İzi',
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(
                  delay: 100,
                  ikon: Icons.help_outline_rounded,
                  baslik: 'Karbon Ayak İzi Nedir?',
                  icerik: 'Karbon ayak izi, bir bireyin, organizasyonun, ürünün veya hizmetin doğrudan ve dolaylı olarak yaydığı sera gazı miktarının karbondioksit (CO₂) cinsinden ifadesidir. Bu, günlük aktivitelerimizden, kullandığımız enerjiden ve tükettiğimiz ürünlerden kaynaklanan çevresel etkimizin bir ölçüsüdür.',
                ),
                _buildInfoSection(
                  delay: 200,
                  ikon: Icons.warning_amber_rounded,
                  baslik: 'Neden Önemlidir?',
                  icerik: 'Yüksek karbon ayak izi, küresel ısınma ve iklim değişikliği gibi ciddi çevresel sorunlara katkıda bulunur. Sera gazlarının atmosferdeki birikimi, dünyanın ortalama sıcaklığının artmasına, deniz seviyelerinin yükselmesine, aşırı hava olaylarının artmasına ve biyoçeşitliliğin azalmasına yol açar.',
                ),
                _buildInfoSection(
                  delay: 300,
                  ikon: Icons.nature_people_rounded,
                  baslik: 'Nasıl Azaltabiliriz?',
                  icerik: '• Daha az araba kullanarak toplu taşıma, bisiklet veya yürüyüşü tercih edin.\n'
                          '• Enerji tasarruflu cihazlar kullanın ve ışıkları kapatın.\n'
                          '• Daha az et ve süt ürünü tüketin.\n'
                          '• Yerel ve mevsimlik ürünler tercih edin.\n'
                          '• Daha az tüketin ve geri dönüşüme özen gösterin.\n'
                          '• Ağaç dikimine destek olun.',
                ),
                _buildInfoSection(
                  delay: 400,
                  ikon: Icons.commute_rounded,
                  baslik: 'Ulaşımın Rolü',
                  icerik: 'Ulaşım, bireysel karbon ayak izinin önemli bir bölümünü oluşturur. Araba kullanmak, uçakla seyahat etmek gibi fosil yakıt kullanan ulaşım yöntemleri yüksek miktarda sera gazı salınımına neden olur. Bu nedenle, ulaşım tercihlerimiz çevresel etkimizi azaltmada kritik bir rol oynar.',
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required int delay, required IconData ikon, required String baslik, required String icerik}) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(ikon, color: AppTheme.primaryGreen, size: 28),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      baslik,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                icerik,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
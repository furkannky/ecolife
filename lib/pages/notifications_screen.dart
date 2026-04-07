import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Çevre temalı örnek bildirim verileri
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Karbon Hedefine Ulaştın! 🏆",
        "message": "Tebrikler! Bu haftaki 20kg karbon tasarrufu hedefini başarıyla tamamladın.",
        "icon": Icons.workspace_premium_rounded,
        "color": Colors.amber,
        "time": "1 saat önce"
      },
      {
        "title": "Yeni Geri Dönüşüm Noktası",
        "message": "Konumunuza 2km yakınlıkta yeni bir pil geri dönüşüm kutusu eklendi.",
        "icon": Icons.recycling_rounded,
        "color": AppTheme.primaryGreen,
        "time": "3 saat önce"
      },
      {
        "title": "Topluluk Etkinliği Başlıyor!",
        "message": "Kadıköy sahil temizliği etkinliği yarın sabah 09:00'da başlıyor. Katılmayı unutma!",
        "icon": Icons.group_rounded,
        "color": Colors.blue.shade400,
        "time": "Dün"
      },
      {
        "title": "Yeni Vegan Tarifler",
        "message": "Haftanın sürdürülebilir, düşük karbon ayak izine sahip leziz tarifleri Akıllı Mutfak'ta yayınlandı.",
        "icon": Icons.fastfood_rounded,
        "color": Colors.orange.shade400,
        "time": "2 gün önce"
      },
       {
        "title": "Ulaşım Analizi",
        "message": "Geçen haftaya göre %15 daha fazla toplu taşıma kullanarak 5 ağaç kurtardın!",
        "icon": Icons.directions_bus_rounded,
        "color": Colors.teal.shade400,
        "time": "Geçen hafta"
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: OrganicBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                        'Bildirimler',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Text(
                        "Şu an yeni bildirim yok.",
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          duration: const Duration(milliseconds: 600),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GlassCard(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (notif['color'] as Color).withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(notif['icon'], color: notif['color'], size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notif['title'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppTheme.textPrimary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              notif['time'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          notif['message'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'forum_screen.dart';
import 'events_screen.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrganicBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
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
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'EcoLife Topluluğu',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeInDown(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 1300),
              child: Text(
                'Sürdürülebilir bir gelecek için birlikte!',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    child: GlassCard(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.diversity_1_rounded, size: 50, color: AppTheme.primaryGreen),
                          const SizedBox(height: 15),
                          const Text(
                            'Topluluğa Hoş Geldiniz!',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Burada sürdürülebilir yaşam için önerilerde bulunabilir, etkinliklere katılabilir ve forumlarda tartışmalara katılabilirsiniz.',
                            style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 1600),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForumScreen()),
                        );
                      },
                      icon: const Icon(Icons.forum_rounded, size: 24),
                      label: const Text(
                        'FORUM - GENEL TARTIŞMALAR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 1700),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EventsScreen()),
                        );
                      },
                      icon: const Icon(Icons.event_available_rounded, size: 24),
                      label: const Text(
                        'ETKİNLİKLER - KATILIN',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: AppTheme.secondaryGreen,
                        minimumSize: const Size(double.infinity, 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 1800),
                    child: Text(
                      'Öne Çıkanlar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInUp(
                    delay: const Duration(milliseconds: 900),
                    duration: const Duration(milliseconds: 1900),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.forum_rounded, color: AppTheme.primaryGreen),
                        ),
                        title: const Text('Sürdürülebilir Yaşam Forumları', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        subtitle: Text('Yaşam tarzınızı daha sürdürülebilir hale getirmek için ipuçları', style: TextStyle(color: AppTheme.textSecondary)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.primaryGreen, size: 16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 2000),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppTheme.secondaryGreen.withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.event_rounded, color: AppTheme.secondaryGreen),
                        ),
                        title: const Text('Yeşil Ulaşım Etkinliği', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        subtitle: Text('Bölgenizdeki yeşil ulaşım projelerine katılın', style: TextStyle(color: AppTheme.textSecondary)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.primaryGreen, size: 16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsScreen()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
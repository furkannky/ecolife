import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late String kullaniciAdi;
  late String email;
  double karbonHedefi = 20.0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email ?? "Bilinmeyen Email";
    
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      kullaniciAdi = user.displayName!;
    } else if (user?.email != null) {
      final namePart = user!.email!.split('@').first;
      kullaniciAdi = namePart[0].toUpperCase() + namePart.substring(1);
    } else {
      kullaniciAdi = "Doğa Dostu";
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrganicBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryGreen),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Profilim",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: GlassCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kullaniciAdi,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 800),
                child: GlassCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.track_changes_rounded, color: AppTheme.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            "Karbon Hedefi",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Slider(
                        value: karbonHedefi,
                        min: 0.0,
                        max: 50.0,
                        divisions: 5,
                        label: "${karbonHedefi.toStringAsFixed(0)} g CO2",
                        activeColor: AppTheme.primaryGreen,
                        inactiveColor: AppTheme.secondaryGreen.withOpacity(0.3),
                        onChanged: (double value) {
                          setState(() {
                            karbonHedefi = value;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Hedef: ${karbonHedefi.toStringAsFixed(0)} g CO2",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 800),
                child: GlassCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            "Kazanılan Rozetler",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _rozetSirasi(Icons.star_rounded, Colors.amber, "Başlangıç Rozeti"),
                      const Divider(height: 30, color: Colors.black12),
                      _rozetSirasi(Icons.spa_rounded, AppTheme.primaryGreen, "Yeşil Yıldız Rozeti"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 800),
                child: GlassCard(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () => _hesabiSil(context),
                    child: const Row(
                      children: [
                        Icon(Icons.person_remove_rounded, color: Colors.redAccent, size: 28),
                        SizedBox(width: 15),
                        Text(
                          "Hesabı Sil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _hesabiSil(BuildContext context) async {
    final onayla = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
        content: const Text('Hesabınızı kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm kişisel verileriniz, rozetleriniz ve karbon ayak izi hedefiniz silinir.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (onayla == true) {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Güvenlik nedeniyle hesabınızı silmek için lütfen önce çıkış yapıp tekrar giriş yapın.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bir hata oluştu: ${e.message}'), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bilinmeyen bir hata oluştu: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Widget _rozetSirasi(IconData icon, Color color, String metin) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 15),
        Text(metin, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ],
    );
  }
}
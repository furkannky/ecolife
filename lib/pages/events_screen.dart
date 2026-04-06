import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  void joinEvent(String eventId, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance.collection('events').doc(eventId);
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      await ref.update({
        'joinedUsers': FieldValue.arrayUnion([uid]),
      });

      await userRef.update({
        'karbonSkoru': FieldValue.increment(1.0), 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Etkinliğe katıldınız! Karbon puanınız artırıldı.", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      print("Katılım ve karbon puanı güncelleme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: OrganicBackground(
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
                        'Yerel Etkinlikler',
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
                  'Bölgenizdeki yeşil projelere katılın ve karbon puanı kazanın!',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen));
                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(child: Text('Şu an aktif etkinlik bulunmuyor.', style: TextStyle(color: AppTheme.textSecondary)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 40),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return FadeInUp(
                          delay: Duration(milliseconds: 150 * index),
                          duration: const Duration(milliseconds: 600),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GlassCard(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.secondaryGreen.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.event_available_rounded, color: AppTheme.secondaryGreen, size: 28),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['title'] ?? 'İsimsiz Etkinlik',
                                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.textPrimary),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              data['description'] ?? 'Açıklama yok',
                                              style: TextStyle(color: AppTheme.textSecondary, height: 1.4, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Divider(color: Colors.grey.withOpacity(0.2)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month_rounded, size: 16, color: Colors.orangeAccent),
                                      const SizedBox(width: 5),
                                      Text(
                                        data['date'] ?? 'Tarih Belirtilmemiş',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent, fontSize: 13),
                                      ),
                                      const SizedBox(width: 15),
                                      const Icon(Icons.location_on_rounded, size: 16, color: Colors.blueAccent),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          data['location'] ?? 'Konum Belirtilmemiş',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      joinEvent(docs[index].id, context);
                                    },
                                    icon: const Icon(Icons.group_add_rounded),
                                    label: const Text('Katıl (+1 Puan)', style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 45),
                                        backgroundColor: AppTheme.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
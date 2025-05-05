import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  // Etkinliğe katılım sağlandığında karbon puanını artır
  void joinEvent(String eventId, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance.collection('events').doc(eventId);
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      // Etkinlik katılımını kaydet
      await ref.update({
        'joinedUsers': FieldValue.arrayUnion([uid]),
      });

      // Kullanıcının karbon puanını artır
      await userRef.update({
        'karbonSkoru': FieldValue.increment(1.0), // Karbon puanını 1 artırıyoruz
      });

      // Katılım sonrası bildirim göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Etkinliğe katıldınız! Karbon puanınız artırıldı.")),
      );
    } catch (e) {
      // Hata yönetimi
      print("Katılım ve karbon puanı güncelleme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.lightGreen.shade900,
              Colors.lightGreen.shade800,
              Colors.lightGreen.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Yerel Etkinlikler',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
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
                padding: const EdgeInsets.all(30),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return FadeInUp(
                          delay: Duration(milliseconds: 200 * index),
                          duration: const Duration(milliseconds: 500),
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              leading: const Icon(Icons.event, color: Colors.lightGreen, size: 30),
                              title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "${data['description'] ?? 'Açıklama yok'}\n📅 ${data['date'] ?? 'Tarih belirtilmemiş'} | 📍 ${data['location'] ?? 'Konum belirtilmemiş'}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              isThreeLine: true,
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreen.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Katıl"),
                                onPressed: () {
                                  joinEvent(docs[index].id, context);
                                },
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
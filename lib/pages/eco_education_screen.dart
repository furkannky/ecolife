import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/eco_lesson.dart';
import 'video_player_screen.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class EcoEducationScreen extends StatelessWidget {
  const EcoEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrganicBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
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
                      'Eco Eğitim',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeInDown(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 800),
              child: Text(
                "Doğayı korumanın en iyi yollarını buradan öğren.",
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('eco_lessons').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Henüz içerik yok.", style: TextStyle(fontSize: 16)));
                }

                final lessons = snapshot.data!.docs.map((doc) {
                  return EcoLesson.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: 200 + (100 * index)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VideoPlayerScreen(videoUrl: lesson.videoUrl),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.play_circle_fill_rounded, color: AppTheme.primaryGreen, size: 32),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson.title, 
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textPrimary)
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          lesson.description,
                                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
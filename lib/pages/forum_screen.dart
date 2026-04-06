import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('forums')
          .doc('genel')
          .collection('messages')
          .add({
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: OrganicBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                          'Sürdürülebilir Yaşam',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forums')
                        .doc('genel')
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen));
                      final docs = snapshot.data!.docs;
                      return FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                backgroundColor: Colors.white.withOpacity(0.6),
                                child: Text(
                                  data['text'] ?? '',
                                  style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Bir mesaj yazın...',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                      FadeInRight(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.white),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
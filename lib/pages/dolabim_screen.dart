import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class DolabimScreen extends StatefulWidget {
  const DolabimScreen({super.key});

  @override
  State<DolabimScreen> createState() => _DolabimScreenState();
}

class _DolabimScreenState extends State<DolabimScreen> {
  final TextEditingController _malzemeController = TextEditingController();
  final List<String> _malzemeler = [];

  void _malzemeEkle() {
    final yeniMalzeme = _malzemeController.text.trim();
    if (yeniMalzeme.isNotEmpty) {
      setState(() {
        _malzemeler.add(yeniMalzeme);
        _malzemeController.clear();
      });
    }
  }

  void _malzemeSil(int index) {
    setState(() {
      _malzemeler.removeAt(index);
    });
  }

  void _tarifleriGoster() {
    final kucukHarfliMalzemeler = _malzemeler.map((e) => e.toLowerCase()).toList();
    Navigator.pushNamed(context, '/tarif', arguments: kucukHarfliMalzemeler);
  }

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
                      'Akıllı Mutfak',
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
                "Neyin var? Senin için en iyi tarifi bulalım.",
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: GlassCard(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _malzemeController,
                              style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'Örn: Domates, Biber...',
                                hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_rounded, color: Colors.white),
                              onPressed: _malzemeEkle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FadeIn(
                      duration: const Duration(milliseconds: 1400),
                      child: ListView.builder(
                        itemCount: _malzemeler.length,
                        itemBuilder: (context, index) {
                          return FadeInLeft(
                            delay: Duration(milliseconds: 100 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                backgroundColor: Colors.white.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.secondaryGreen.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.restaurant_rounded, color: AppTheme.primaryGreen, size: 20),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        _malzemeler[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent),
                                      onPressed: () => _malzemeSil(index),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: ElevatedButton.icon(
                      onPressed: _malzemeler.isNotEmpty ? _tarifleriGoster : null,
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: const Text("Tarifleri Bul"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
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
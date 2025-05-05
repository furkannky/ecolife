import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade400,
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
                child: const Text("Akıllı Mutfak",
                    style: TextStyle(color: Colors.white, fontSize: 40)),
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: TextField(
                          controller: _malzemeController,
                          decoration: InputDecoration(
                            labelText: 'Malzeme ekle',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _malzemeEkle,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
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
                                delay: Duration(milliseconds: 200 * index),
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(_malzemeler[index]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _malzemeSil(index),
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
                        duration: const Duration(milliseconds: 1600),
                        child: ElevatedButton.icon(
                          onPressed: _malzemeler.isNotEmpty ? _tarifleriGoster : null,
                          icon: const Icon(Icons.receipt),
                          label: const Text("Tarifleri Göster"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
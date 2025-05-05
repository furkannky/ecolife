import 'package:flutter/material.dart';
import '../services/api_service.dart';

class YemekTahminScreen extends StatefulWidget {
  const YemekTahminScreen({super.key});

  @override
  State<YemekTahminScreen> createState() => _YemekTahminScreenState();
}

class _YemekTahminScreenState extends State<YemekTahminScreen> {
  final TextEditingController _malzemeController = TextEditingController();
  List<String> _tahminler = [];
  bool _yukleniyor = false;
  String? _hataMesaji;

  void _tahminEt() async {
    final metin = _malzemeController.text.trim();
    if (metin.isEmpty) return;

    final malzemeler = metin.split(',').map((e) => e.trim()).toList();

    setState(() {
      _yukleniyor = true;
      _tahminler = [];
      _hataMesaji = null;
    });

    try {
      final cevap = await ApiService.predictDish(malzemeler);
      setState(() {
        _tahminler = cevap;
      });
    } catch (e) {
      setState(() {
        _hataMesaji = e.toString();
      });
    } finally {
      setState(() {
        _yukleniyor = false;
      });
    }
  }

  @override
  void dispose() {
    _malzemeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Tahmin'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Evdeki malzemeleri virgülle ayırarak yaz:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _malzemeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "örnek: domates, pirinç, zeytinyağı",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _yukleniyor ? null : _tahminEt,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: _yukleniyor
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Tahmin Et"),
            ),
            const SizedBox(height: 30),

            if (_hataMesaji != null)
              Text(
                _hataMesaji!,
                style: const TextStyle(color: Colors.red),
              ),

            if (_tahminler.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tahmin Edilen Yemekler:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  ..._tahminler.map((tahmin) => Text("• $tahmin")).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

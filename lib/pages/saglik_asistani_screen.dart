import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class SaglikAsistaniScreen extends StatefulWidget {
  const SaglikAsistaniScreen({Key? key}) : super(key: key);

  @override
  _SaglikAsistaniScreenState createState() => _SaglikAsistaniScreenState();
}

class _SaglikAsistaniScreenState extends State<SaglikAsistaniScreen> {
  final _formKey = GlobalKey<FormState>();
  final AIService _aiService = AIService();

  // Form Değişkenleri (UCI Veri Setindeki Parametrelerin Varsayılan Değerleri)
  double age = 45;
  String sex = 'Male';
  String cp = 'asymptomatic';
  double trestbps = 130;
  double chol = 240;
  String fbs = 'False';
  String restecg = 'normal';
  double thalch = 150;
  String exang = 'False';
  double oldpeak = 0.0;
  String slope = 'flat';
  double ca = 0.0;
  String thal = 'normal';

  bool _loading = false;
  String _resultStatus = '';
  double _resultPercentage = 0.0;

  void _analizEt() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      // Veri setimizle %100 tutarlı JSON gövdesi hazırlıyoruz
      Map<String, dynamic> veriler = {
        "age": age,
        "sex": sex,
        "cp": cp,
        "trestbps": trestbps,
        "chol": chol,
        "fbs": fbs,
        "restecg": restecg,
        "thalch": thalch,
        "exang": exang,
        "oldpeak": oldpeak,
        "slope": slope,
        "ca": ca,
        "thal": thal
      };

      final response = await _aiService.kalpRiskiTahminEt(veriler);

      setState(() {
        _loading = false;
        if (response['durum'] == 'Basarili') {
          _resultStatus = response['kalp_hastaligi_riski'];
          _resultPercentage = response['olasilik_yuzdesi'];
        } else {
          _resultStatus = 'Hata: ${response['mesaj']}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("EcoLife Yapay Zeka Sağlık Asistanı")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                color: Colors.green.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green, size: 32),
                      SizedBox(height: 10),
                      Text(
                        "Nasıl Kullanılır?",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Yapay zeka modelimiz (1D-CNN), girdiğiniz klinik verileri analiz ederek kalp rahatsızlığı riskinizi hesaplar. Yakın zamanda yaptırdığınız kan tahlili veya tansiyon ölçümlerinizi aşağıdaki alanlara girebilirsiniz.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // YAŞ ALANI
              TextFormField(
                initialValue: age.toString(),
                decoration: InputDecoration(
                  labelText: 'Yaş',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline),
                  helperText: 'Lütfen yaşınızı girin (Örn: 45)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => age = double.tryParse(val) ?? 40,
              ),
              const SizedBox(height: 20),
              // KAN BASINCI ALANI
              TextFormField(
                initialValue: trestbps.toString(),
                decoration: InputDecoration(
                  labelText: 'Dinlenme Kan Basıncı (Tansiyon)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.favorite_border),
                  suffixText: 'mmHg',
                  helperText: 'Büyük tansiyon değeriniz (Normal: 90-120 arası)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => trestbps = double.tryParse(val) ?? 130,
              ),
              const SizedBox(height: 20),
              // KOLESTEROL ALANI
              TextFormField(
                initialValue: chol.toString(),
                decoration: InputDecoration(
                  labelText: 'Serum Kolesterol',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.water_drop_outlined),
                  suffixText: 'mg/dl',
                  helperText: 'Kan testindeki toplam kolesterol (Normal: < 200)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => chol = double.tryParse(val) ?? 200,
              ),
              const SizedBox(height: 20),
              // MAKSİMUM KALP ATIŞI
              TextFormField(
                initialValue: thalch.toString(),
                decoration: InputDecoration(
                  labelText: 'Maksimum Kalp Atış Hızı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.monitor_heart_outlined),
                  suffixText: 'bpm',
                  helperText: 'Efor anındaki en yüksek nabzınız (Örn: 150)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => thalch = double.tryParse(val) ?? 150,
              ),
              const SizedBox(height: 30),
              
              // ANALİZ ET BUTONU
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _analizEt,
                      child: const Text("Yapay Zeka ile Analiz Et", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
              
              const SizedBox(height: 25),
              // SONUÇ KARTI
              if (_resultStatus.isNotEmpty)
                Card(
                  elevation: 4,
                  color: _resultStatus == "Risk Var" ? Colors.red.shade50 : Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          _resultStatus == "Risk Var" ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                          color: _resultStatus == "Risk Var" ? Colors.red : Colors.blue,
                          size: 40,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Analiz Sonucu: $_resultStatus", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Yapay Sinir Ağı Olasılığı: %$_resultPercentage", style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    ));
  }
}

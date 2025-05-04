import 'package:flutter/material.dart';

class KarbonAyakIziBilgiEkrani extends StatelessWidget {
  const KarbonAyakIziBilgiEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karbon Ayak İzi Hakkında'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Karbon Ayak İzi Nedir?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Karbon ayak izi, bir bireyin, organizasyonun, ürünün veya hizmetin doğrudan ve dolaylı olarak yaydığı sera gazı miktarının karbondioksit (CO₂) cinsinden ifadesidir. Bu, günlük aktivitelerimizden, kullandığımız enerjiden ve tükettiğimiz ürünlerden kaynaklanan çevresel etkimizin bir ölçüsüdür.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Neden Önemlidir?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Yüksek karbon ayak izi, küresel ısınma ve iklim değişikliği gibi ciddi çevresel sorunlara katkıda bulunur. Sera gazlarının atmosferdeki birikimi, dünyanın ortalama sıcaklığının artmasına, deniz seviyelerinin yükselmesine, aşırı hava olaylarınınFrequency artmasına ve biyoçeşitliliğin azalmasına yol açar.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Karbon Ayak İzini Nasıl Azaltabiliriz?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              '- Daha az araba kullanarak toplu taşıma, bisiklet veya yürüyüşü tercih edin.\n'
              '- Enerji tasarruflu cihazlar kullanın ve gereksiz ışıkları kapatın.\n'
              '- Daha az et ve süt ürünü tüketin.\n'
              '- Yerel ve mevsimlik ürünler tercih edin.\n'
              '- Daha az tüketin ve geri dönüşüme özen gösterin.\n'
              '- Ağaç dikimine destek olun.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Ulaşımın Rolü:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Ulaşım, bireysel karbon ayak izinin önemli bir bölümünü oluşturur. Araba kullanmak, uçakla seyahat etmek gibi fosil yakıt kullanan ulaşım yöntemleri yüksek miktarda sera gazı salınımına neden olur. Bu nedenle, ulaşım tercihlerimiz çevresel etkimizi azaltmada kritik bir rol oynar.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registerUser(String email, String password) async {
  try {
    // 1. Firebase Authentication ile kayıt
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    // 2. Firestore'da "users" koleksiyonuna kullanıcıyı ekle
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'score': 0,
      'badges': [],
    });

    print("✅ Kullanıcı Firestore'a kaydedildi.");
  } catch (e) {
    print("❌ Hata: $e");
  }
}

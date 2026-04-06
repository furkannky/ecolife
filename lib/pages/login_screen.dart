import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import '../constants/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isLogin = true; // Giriş/Kayıt modu geçişi

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _authAction() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await _signIn();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await _signUp();
        if (mounted) {
          setState(() {
            isLogin = true; 
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Bir hata oluştu");
    } catch (e) {
      _showError("Beklenmedik hata: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': emailController.text.trim(),
        'score': 0,
        'badges': [],
      });

      _showSuccess("Kayıt başarılı! Giriş yapabilirsiniz");
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Bir hata oluştu");
    } catch (e) {
      _showError("Beklenmedik hata: $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.primaryGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Arka Plan Dekoru
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryGreen.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryGreen.withOpacity(0.2),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          Icon(
                            Icons.eco_rounded,
                            size: 80,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "E C O L İ F E",
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppTheme.primaryGreen,
                              letterSpacing: 3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isLogin ? "Sürdürülebilir yaşama dönüş" : "Doğa dostu topluluğa katıl",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "E-posta Adresi",
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Lütfen e-posta girin';
                                      if (!value.contains('@')) return 'Geçerli bir e-posta girin';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Şifre",
                                      prefixIcon: Icon(Icons.lock_outline_rounded),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Lütfen şifre girin';
                                      if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
                                      return null;
                                    },
                                  ),
                                  if (isLogin) ...[
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: isLoading ? null : () {},
                                        child: Text(
                                          "Şifremi Unuttum",
                                          style: TextStyle(color: AppTheme.textSecondary),
                                        ),
                                      ),
                                    ),
                                  ] else
                                    const SizedBox(height: 30),
                                    
                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _authAction,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent, // Renk yok (Saydam)
                                        foregroundColor: AppTheme.primaryGreen, // Yeşil Yazı ve İkon Rengi
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: const BorderSide(color: AppTheme.primaryGreen, width: 2), // Sadece dış çerçeve
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(color: AppTheme.primaryGreen, strokeWidth: 3),
                                            )
                                          : Text(
                                              isLogin ? "Giriş Yap" : "Kayıt Ol",
                                              style: const TextStyle(fontSize: 18, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin
                              ? "Hesabın yok mu? Kayıt ol"
                              : "Zaten hesabın var mı? Giriş yap",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
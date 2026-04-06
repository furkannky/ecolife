import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class OrganicBackground extends StatelessWidget {
  final Widget child;

  const OrganicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F1), // Very soft green-tinted white
      body: Stack(
        children: [
          // Top Right Blobs
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryGreen.withOpacity(0.25),
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -150,
            child: Container(
              width: 250,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: AppTheme.primaryGreen.withOpacity(0.15),
              ),
            ),
          ),
          
          // Bottom Left Blobs
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: AppTheme.primaryGreen.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryGreen.withOpacity(0.2),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            bottom: false,
            child: child,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF2E7D32); // Deep forest green
  static const Color buttonGreen = Color(0xFF2E7D32); // General green for buttons
  static const Color secondaryGreen = Color(0xFF81C784); // Soft accent green
  static const Color background = Color(0xFFF7FBF7); // Off-white/cream green tint
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF1E3A20); // Dark greenish-black
  static const Color textSecondary = Color(0xFF677C68); // Muted green-grey

  // Gradients
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF195528), // Darker green
      Color(0xFF2E7D32), // Primary green
      Color(0xFF4CAF50), // Brighter green
    ],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F5E9),
      Color(0xFFF7FBF7),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: surfaceColor,
        background: background,
      ),
      
      // Modern Typography with Google Fonts
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.nunito(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.nunito(color: textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.nunito(color: textPrimary),
        bodyMedium: GoogleFonts.nunito(color: textSecondary),
      ),

      // App Bar styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryGreen),
        titleTextStyle: GoogleFonts.nunito(
          color: primaryGreen,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),

      // Card styling
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 6,
        shadowColor: Color(0x19000000), // black with 0.1 opacity
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),

      // Button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonGreen, // Only softened the button color
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: buttonGreen.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400),
        prefixIconColor: primaryGreen,
      ),
    );
  }
}

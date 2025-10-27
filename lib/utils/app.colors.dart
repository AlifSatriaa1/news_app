import 'package:flutter/material.dart';

class AppColors {
  // 🎯 Primary Brand Colors - Professional Navy/Blue
  static const Color primaryDark = Color(0xFF0A1929); // Deep Navy
  static const Color primary = Color(0xFF1E3A5F); // Navy Blue
  static const Color primaryLight = Color(0xFF2E5984); // Light Navy
  
  // 🌟 Accent Colors - Gold/Amber Professional
  static const Color accent = Color(0xFFF59E0B); // Gold/Amber
  static const Color accentLight = Color(0xFFFBBF24); // Light Gold
  static const Color secondary = Color(0xFFDC2626); // Red for Breaking/Exclusive
  static const Color secondaryLight = Color(0xFFEF4444); // Light Red
  
  // 🎨 Gradient Colors - Professional Theme
  static const List<Color> primaryGradient = [
    Color(0xFF0A1929), // Deep Navy
    Color(0xFF1E3A5F), // Navy Blue
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFF59E0B), // Gold
    Color(0xFFFBBF24), // Light Gold
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF059669), // Emerald
    Color(0xFF10B981), // Light Emerald
  ];
  
  static const List<Color> heroGradient = [
    Color(0xFF0A1929), // Deep Navy
    Color(0xFF1E3A5F), // Navy
    Color(0xFF2E5984), // Light Navy
  ];

  // 🌙 Background & Surface - Modern Dark Mode Support
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color backgroundLight = Color(0xFFFAFAFA); 
  static const Color cardBackground = Colors.white;

  // ❗ Status Colors
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color onError = Colors.white;

  // ⚪ On Colors
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurface = Color(0xFF1E293B);

  // 📝 Text Colors - Modern Typography
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textHint = Color(0xFFCBD5E1); // Slate 300
  static const Color textInverse = Colors.white;

  // ➖ Additional UI Elements
  static const Color divider = Color(0xFFE2E8F0); // Slate 200
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color cardShadow = Color(0x1A000000);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
  
  // 🎭 Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // 🌈 Category Colors - Professional Theme
  static const Map<String, Color> categoryColors = {
    'business': Color(0xFF1E3A5F), // Navy Blue
    'entertainment': Color(0xFFDC2626), // Red
    'general': Color(0xFF64748B), // Slate
    'health': Color(0xFF059669), // Emerald
    'science': Color(0xFF7C3AED), // Violet
    'sports': Color(0xFFF59E0B), // Amber/Gold
    'technology': Color(0xFF0891B2), // Cyan
  };
  
  // 🏷️ Badge Colors
  static const Color breakingBadge = Color(0xFFDC2626); // Red
  static const Color exclusiveBadge = Color(0xFF7C3AED); // Violet
  static const Color trendingBadge = Color(0xFFF59E0B); // Gold
  static const Color featuredBadge = Color(0xFF1E3A5F); // Navy
}

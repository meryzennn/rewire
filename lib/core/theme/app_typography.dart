import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme get textTheme {
    GoogleFonts.config.allowRuntimeFetching = false;
    return GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, height: 1.5),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, height: 1.5),
      bodySmall: GoogleFonts.nunito(fontSize: 12, height: 1.5),
      labelLarge: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w500),
    );
  }
}

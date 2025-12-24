import 'dart:ui';

import 'package:flutter/material.dart';

class Util {
  static String getRequestErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Los datos ingresados son incorrectos.";
      case 401:
        return "Acceso no autorizado. Verifique sus credenciales.";
      case 500:
        return "Error del servidor. Inténtelo de nuevo más tarde.";
      default:
        return "Error desconocido. Inténtelo de nuevo.";
    }
  }

  static Color hexToColor(String code) {
    // Remove the '#' sign if it's present
    String hex = code.replaceFirst('#', '');
    // Ensure it has 6 digits, assume full opacity if not
    if (hex.length == 6) {
      hex = 'FF' + hex;
    }
    // Parse the hex string as an integer with radix 16 (hexadecimal)
    return Color(int.parse(hex, radix: 16));
  }

  static Color getAccentColor(String hexColor, {double lightnessIncrease = 0.25}) {
    // Remove #
    final hex = hexColor.replaceFirst('#', '');

    // Parse color
    final color = Color(int.parse('FF$hex', radix: 16));

    // Convert to HSL
    final hsl = HSLColor.fromColor(color);

    // Increase lightness (clamped between 0 and 1)
    final accentHsl = hsl.withLightness(
      (hsl.lightness + lightnessIncrease).clamp(0.0, 1.0),
    );

    return accentHsl.toColor();
  }

  static bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String? validateStringField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio.';
    }
    return null;
  }

  static String? validateDoubleField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio.';
    }

    final double? price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Ingrese un número válido mayor que cero.';
    }

    return null;
  }
}

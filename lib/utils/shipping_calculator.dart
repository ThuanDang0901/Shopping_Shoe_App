class ShippingCalculator {
  static double calculateShipping({
    required double totalWeightKg,
    required String? shippingAddress,
    required String paymentMethod,
    required double subtotalAmount,
  }) {
    if (shippingAddress == null || shippingAddress.isEmpty) {
      return 0.0;
    }

    String addressLower = shippingAddress.toLowerCase();

    List<String> localKeywords = [
      'hồ chí minh',
      'ho chi minh',
      'hcm',
      'tp hcm',
      'tphcm',
      'sài gòn',
      'sai gon',
    ];

    bool isLocal = false;

    for (var keyword in localKeywords) {
      if (addressLower.contains(keyword)) {
        isLocal = true;
        break;
      }
    }

    double baseShipVnd = 0.0;

    if (totalWeightKg <= 0.5) {
      baseShipVnd = isLocal ? 16500.0 : 30000.0;
    } else if (totalWeightKg <= 1.0) {
      baseShipVnd = isLocal ? 20000.0 : 40000.0;
    } else {
      double firstKgVnd = isLocal ? 20000.0 : 40000.0;
      double extraWeight = totalWeightKg - 1.0;
      double nextKgRateVnd = isLocal ? 2750.0 : 6000.0;

      baseShipVnd = firstKgVnd + (extraWeight * nextKgRateVnd);
    }

    double fuelSurcharge = baseShipVnd * 0.10;
    double totalShipVnd = baseShipVnd + fuelSurcharge;

    if (paymentMethod == 'cod') {
      double codFeeVnd = subtotalAmount * 0.0088;
      if (codFeeVnd < 16500.0) {
        codFeeVnd = 16500.0;
      }
      totalShipVnd += codFeeVnd;
    }

    return totalShipVnd;
  }

  static String formatCurrency(double amount) {
    return "${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ";
  }
}

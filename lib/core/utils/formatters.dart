class Formatters {
  Formatters._();

  static String currency(double value) => '₹${value.toStringAsFixed(2)}';
}

import 'package:invoice/domain/entities/business.dart';

class InvoiceNumberGenerator {
  /// Generates an invoice number and increments the business counter in-memory.
  /// Persistence (saving updated business) is the caller's responsibility.
  static String generateNumber(Business business) {
    final currentYear = DateTime.now().year;

    if (business.counterYear != currentYear) {
      business.counterYear = currentYear;
      business.invoiceCounter = 0;
    }

    business.invoiceCounter++;

    final prefix = business.invoicePrefix ?? 'INV';
    final counter = business.invoiceCounter.toString().padLeft(4, '0');
    return '$prefix-$currentYear-$counter';
  }
}

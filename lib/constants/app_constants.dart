class AppConstants {
  // Invoice number format
  static const String invoiceNumberPrefix = 'INV';
  static const String invoiceNumberSeparator = '-';

  // Payment types
  static const String paymentTypeLunas = 'lunas';
  static const String paymentTypeDP = 'dp';
  static const String paymentTypeTermin = 'termin';

  // Invoice statuses
  static const String invoiceStatusDraft = 'draft';
  static const String invoiceStatusSent = 'sent';
  static const String invoiceStatusPartialPaid = 'partial_paid';
  static const String invoiceStatusPaid = 'paid';
  static const String invoiceStatusOverdue = 'overdue';
  static const String invoiceStatusCancelled = 'cancelled';

  // Template field types
  static const String fieldTypeText = 'text';
  static const String fieldTypeMultiline = 'multiline';
  static const String fieldTypeNumber = 'number';
  static const String fieldTypeCurrency = 'currency';
  static const String fieldTypeDate = 'date';
  static const String fieldTypeDateRange = 'dateRange';
  static const String fieldTypeDropdown = 'dropdown';
  static const String fieldTypeCheckbox = 'checkbox';

  // Payment methods
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodTransfer = 'transfer';
  static const String paymentMethodOther = 'other';

  // Default values
  static const double defaultTax = 0.0;
  static const double defaultDiscount = 0.0;
  static const double defaultShipping = 0.0;

  // UI constants
  static const double cardRadius = 16.0;
  static const double cardRadiusLarge = 20.0;
  static const double shadowBlur = 12.0;
  static const double shadowSpread = 0.0;

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
}

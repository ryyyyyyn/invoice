import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/business_repository_drift.dart';
import '../../data/repositories/customer_repository_drift.dart';
import '../../data/repositories/catalog_repository_drift.dart';
import '../../data/repositories/template_repository_drift.dart';
import '../../data/repositories/invoice_repository_drift.dart';
import '../../core/constants/billing_constants.dart';

// Repository Providers (LocalStorage-backed for now)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final businessRepositoryProvider = Provider((ref) {
  return BusinessRepositoryDrift(ref.read(appDatabaseProvider));
});

final customerRepositoryProvider = Provider((ref) {
  return CustomerRepositoryDrift(ref.read(appDatabaseProvider));
});

final catalogRepositoryProvider = Provider((ref) {
  return CatalogRepositoryDrift(ref.read(appDatabaseProvider));
});

final templateRepositoryProvider = Provider((ref) {
  return TemplateRepositoryDrift(ref.read(appDatabaseProvider));
});

final invoiceRepositoryProvider = Provider((ref) {
  return InvoiceRepositoryDrift(ref.read(appDatabaseProvider));
});

class ProAccessState {
  final bool isAvailable;
  final bool isPro;
  final bool isLoading;
  final ProductDetails? productDetails;
  final String? errorMessage;

  const ProAccessState({
    required this.isAvailable,
    required this.isPro,
    required this.isLoading,
    this.productDetails,
    this.errorMessage,
  });

  const ProAccessState.initial()
      : isAvailable = false,
        isPro = false,
        isLoading = true,
        productDetails = null,
        errorMessage = null;

  ProAccessState copyWith({
    bool? isAvailable,
    bool? isPro,
    bool? isLoading,
    ProductDetails? productDetails,
    String? errorMessage,
  }) {
    return ProAccessState(
      isAvailable: isAvailable ?? this.isAvailable,
      isPro: isPro ?? this.isPro,
      isLoading: isLoading ?? this.isLoading,
      productDetails: productDetails ?? this.productDetails,
      errorMessage: errorMessage,
    );
  }
}

class ProAccessController extends StateNotifier<ProAccessState> {
  ProAccessController() : super(const ProAccessState.initial()) {
    _init();
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> _init() async {
    final available = await _iap.isAvailable();
    state = state.copyWith(isAvailable: available, isLoading: true);
    if (!available) {
      state = state.copyWith(isLoading: false, errorMessage: 'In-app purchase not available');
      return;
    }

    final response = await _iap.queryProductDetails({BillingConstants.proSubscriptionId});
    final product = response.productDetails.isNotEmpty ? response.productDetails.first : null;
    state = state.copyWith(
      productDetails: product,
      errorMessage: response.error?.message,
    );

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        state = state.copyWith(errorMessage: error.toString());
      },
    );

    await _iap.restorePurchases();
    state = state.copyWith(isLoading: false);
  }

  Future<void> buyPro() async {
    final product = state.productDetails;
    if (product == null) {
      state = state.copyWith(errorMessage: 'Product not available');
      return;
    }
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restore() async {
    await _iap.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    var hasPro = state.isPro;
    for (final purchase in purchases) {
      if (!_isProProduct(purchase)) continue;
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        hasPro = true;
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
    if (hasPro != state.isPro) {
      state = state.copyWith(isPro: hasPro);
    }
  }

  bool _isProProduct(PurchaseDetails purchase) {
    return purchase.productID == BillingConstants.proSubscriptionId;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final proAccessProvider = StateNotifierProvider<ProAccessController, ProAccessState>((ref) {
  return ProAccessController();
});

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/customers/customer_list_screen.dart';
import '../screens/catalog/catalog_list_screen.dart';
import '../screens/invoices/invoice_list_screen.dart';
import '../screens/invoices/invoice_create_screen.dart';
import '../screens/invoices/invoice_detail_screen.dart';
import '../screens/templates/template_list_screen.dart';
import '../screens/templates/template_editor_screen.dart';
import '../screens/payments/payment_tracking_screen.dart';
import '../screens/business/business_profile_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/settings/terms_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return _ShellScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/invoices',
          name: 'invoices',
          builder: (context, state) => const InvoiceListScreen(),
        ),
        GoRoute(
          path: '/customers',
          name: 'customers',
          builder: (context, state) => const CustomerListScreen(),
        ),
        GoRoute(
          path: '/catalog',
          name: 'catalog',
          builder: (context, state) => const CatalogListScreen(),
        ),
        GoRoute(
          path: '/templates',
          name: 'templates',
          builder: (context, state) => const TemplateListScreen(),
        ),
        GoRoute(
          path: '/payments',
          name: 'payments',
          builder: (context, state) => const PaymentTrackingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/invoice/create',
      name: 'invoice_create',
      builder: (context, state) => const InvoiceCreateScreen(),
    ),
    GoRoute(
      path: '/invoice/:id',
      name: 'invoice_detail',
      builder: (context, state) {
        final invoiceId = int.parse(state.pathParameters['id'] ?? '0');
        return InvoiceDetailScreen(invoiceId: invoiceId);
      },
    ),
    GoRoute(
      path: '/template/:id/edit',
      name: 'template_edit',
      builder: (context, state) {
        final templateId = int.parse(state.pathParameters['id'] ?? '0');
        return TemplateEditorScreen(templateId: templateId);
      },
    ),
    GoRoute(
      path: '/business-profile',
      name: 'business_profile',
      builder: (context, state) => const BusinessProfileScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      name: 'privacy_policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const TermsScreen(),
    ),
  ],
);

class _ShellScaffold extends StatefulWidget {
  final Widget child;

  const _ShellScaffold({required this.child});

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold> {
  static const List<String> _routes = [
    '/home',
    '/invoices',
    '/customers',
    '/catalog',
    '/templates',
    '/payments',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(context),
        onTap: (index) {
          context.go(_routes[index]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Payments',
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexOf(location);
    return index >= 0 ? index : 0;
  }
}


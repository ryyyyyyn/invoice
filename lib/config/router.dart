import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/invoices/invoice_list_screen.dart';
import '../../presentation/screens/customers/customer_list_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/business/business_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
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
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    // Non-shell routes
    GoRoute(
      path: '/business-profile',
      name: 'business-profile',
      builder: (context, state) => const BusinessProfileScreen(),
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
    '/settings',
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
            icon: Icon(Icons.receipt),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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

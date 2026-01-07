import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice/application/providers/providers.dart';
import 'package:invoice/core/constants/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowPulse;
  late final Animation<double> _floatY;

  @override
  void initState() {
    super.initState();
    ref.read(proAccessProvider.notifier);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.25, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _floatY = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    final repo = ref.read(businessRepositoryProvider);
    final business = await repo.getFirstBusiness();
    if (!mounted) return;
    if (business == null) {
      context.go('/business-profile');
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B0F17),
              Color(0xFF05070D),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatY.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentNeon.withOpacity(_glowPulse.value),
                            blurRadius: 28,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/invoice_logo.png',
                        height: 76,
                        width: 76,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.receipt_long_rounded,
                            size: 76,
                            color: AppColors.accentNeon,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Invoice Pro',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.accentNeon,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Preparing workspace...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: AppColors.surfaceCard.withOpacity(0.6),
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentNeon),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

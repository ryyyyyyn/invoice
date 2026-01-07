import 'package:flutter/material.dart';
import 'package:invoice/core/widgets/neon_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Terms of Service', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text(
                'This is placeholder terms of service text. Replace this content with your official terms '
                'before publishing to Google Play.',
              ),
              const SizedBox(height: 8),
              const Text(
                'By using this app, you agree to comply with local regulations and applicable tax rules. '
                'The app is provided as-is with no warranties.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

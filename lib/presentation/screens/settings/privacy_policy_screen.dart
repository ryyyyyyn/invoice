import 'package:flutter/material.dart';
import 'package:invoice/core/widgets/neon_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Privacy Policy', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text(
                'This is placeholder privacy policy text. Replace this content with your official policy '
                'before publishing to Google Play.',
              ),
              const SizedBox(height: 8),
              const Text(
                'We collect only the data necessary to provide invoice management features. '
                'Backups and exports are stored locally on the device unless explicitly shared by the user.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

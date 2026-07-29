import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountTypeSelectionScreen extends StatelessWidget {
  const AccountTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesab Tipi Seçin'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Siz Kim Siniz?',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _AccountTypeCard(
              icon: Icons.person_search,
              title: 'Göndərən',
              subtitle: 'Paket göndərmək istəyirəm',
              onTap: () {
                context.pushNamed(
                  'profileSetup',
                  extra: {'accountType': 'sender'},
                );
              },
            ),
            const SizedBox(height: 24),
            _AccountTypeCard(
              icon: Icons.local_shipping,
              title: 'Kuryər',
              subtitle: 'Paket daşımaq istəyirəm',
              onTap: () {
                context.pushNamed(
                  'profileSetup',
                  extra: {'accountType': 'carrier'},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yolçanta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateNotifierProvider.notifier).signOut();
              context.pushReplacementNamed('phoneAuth');
            },
          ),
        ],
      ),
      body: Center(
        child: authState.when(
          loading: () => const CircularProgressIndicator(),
          data: (user) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Xoş Gəlmişsiniz!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              if (user != null)
                Text(
                  'Telefon: ${user.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 32),
              const Text('Phase 2 tamamlandı. Phase 3 üçün hazırlanılır...'),
            ],
          ),
          error: (error, stack) => Text('Xəta: $error'),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final futureProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(microseconds: 200));
  return 2;
});

final streamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(Duration(seconds: 1), (x) => x).take(5);
});


class FutureProviderWidget extends ConsumerWidget {
  const FutureProviderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(futureProvider);

    return future.when(
      // Loading state
      loading: () => const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
      // Error state
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.exclamationmark_circle,
              size: 48,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          ],
        ),
      ),
      // Data/Success state
      data: (value) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.checkmark_circle,
              size: 48,
              color: CupertinoColors.systemGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'Value: $value',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

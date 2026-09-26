import 'package:flutter_riverpod/flutter_riverpod.dart';

final helloProvider = Provider<String>((ref){

  ref.onDispose(() {
    print('Hello Provider disposed');
  });

  return "Hello world";
});
import 'package:flutter_riverpod/flutter_riverpod.dart';

final libraryProvider = StateNotifierProvider<LibraryNotifier, int>((ref) =>
    LibraryNotifier()
);

class LibraryNotifier extends StateNotifier<int>{
  LibraryNotifier() : super(0);

  updateIndex(int value){
    state = value;
  }
}
import "package:flutter_riverpod/flutter_riverpod.dart";

class PathNotifier extends StateNotifier<String> {
  PathNotifier(): super("");

  void updateImagePath(String imgPath) {
    state = imgPath;
  }
  void clearImagePath(){
    state = "";
  }
}

final pathProvider = StateNotifierProvider<PathNotifier , String>((ref) {
  return PathNotifier();
});
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListNotifier extends StateNotifier<List<int>>{
  ListNotifier(): super([]);

  void updateList(List<int> newList){
    state = [...newList];
  }
  void clearList(){
    state = [];
  }
}

final listProvider = StateNotifierProvider<ListNotifier , List<int>>((ref) {
  return ListNotifier();
});
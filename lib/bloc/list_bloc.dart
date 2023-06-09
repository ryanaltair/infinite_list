import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListState()) {
    int generateItem() {
      return Random().nextInt(50) + 10;
    }

    int generateSessionKey() {
      return Random().nextInt(50);
    }

    on<ListLoadUpper>((event, emit) {
      emit(state.copyWith(before: [generateItem(), ...state.before]));
    });
    on<ListLoadBottom>((event, emit) {
      emit(state.copyWith(after: [...state.after, generateItem()]));
    });

    on<ListRegenerate>((event, emit) {
      final count = Random().nextInt(20) + 1;

      final list = List.generate(count, (index) => generateItem());
      emit(ListState(middle: [
        0,
        ...list,
      ], session: generateSessionKey(), anchor: list.last));
    });
    on<ListRefreshSession>((event, emit) {
      emit(state.copyWith(session: generateSessionKey()));
    });
  }
}

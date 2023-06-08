import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListState()) {
    on<ListLoadUpper>((event, emit) {
      emit(state.copyWith(list: state.list..addAll([1, 1, 1])));
    });
    on<ListLoadBottom>((event, emit) {
      emit(state.copyWith(list: state.list..addAll([2, 2, 2])));
    });
  }
}

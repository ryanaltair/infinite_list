// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_bloc.dart';

class ListState {
  final List<int> list;
  final int anchor;
  String? getContent(int i) {
    if (i >= list.length) return null;
    final content = list[i];
    return 'No. $content';
  }

  ListState({
    this.list = const [],
    this.anchor = 0,
  });

  ListState copyWith({
    List<int>? list,
    int? anchor,
  }) {
    return ListState(
      list: list ?? this.list,
      anchor: anchor ?? this.anchor,
    );
  }
}

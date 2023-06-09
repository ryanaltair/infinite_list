// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_bloc.dart';

class ListState {
  final List<int> before;
  final List<int> after;
  final int anchor;
  final int session;

  String? getBefore(int i) {
    if (i >= before.length) return null;
    final content = before[i];
    if (content == 0) return 'this is the start point';
    return 'before char:$content ${'x' * content}';
  }

  String? getAfter(int i) {
    if (i >= after.length) return null;
    final content = after[i];
    return 'after  char:$content ${'x' * content}';
  }

  ListState({
    this.before = const [],
    this.after = const [],
    this.anchor = 0,
    this.session = 1,
  });

  ListState copyWith({
    List<int>? before,
    List<int>? after,
    int? anchor,
    int? session,
  }) {
    return ListState(
      before: before ?? this.before,
      after: after ?? this.after,
      anchor: anchor ?? this.anchor,
      session: session ?? this.session,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_bloc.dart';

class ListState {
  final List<int> before;
  final List<int> middle;
  final List<int> after;
  final int anchor;
  final int session;

  static String getBefore(int content) {
    if (content == 0) return 'this is the start point';
    return 'before char:$content ${'x' * content}';
  }

  static String getMiddle(int content) {
    if (content == 0) return 'this is the start point';
    return 'middle char:$content ${'x' * content}';
  }

  static double getHeight(String content) {
    // return 50;
    final height = pow(sin(content.length / pi), 2) * 100.0 + 50;
    return height;
  }

  double get beforeHeight {
    if (before.isEmpty) return 0;
    final heights = before
        .map((e) => getHeight(getBefore(e)))
        .reduce((value, element) => value + element);
    return heights;
  }

  double get middleHeight {
    if (middle.isEmpty) return 0;
    final heights = middle.map((e) => getHeight(getAfter(e)));
    print([...heights]);
    return heights.reduce((value, element) => value + element);
  }

  double get afterHeight {
    if (after.isEmpty) return 0;
    final heights = after.map((e) => getHeight(getAfter(e)));
    print([...heights]);
    return heights.reduce((value, element) => value + element);
  }

  static String getAfter(int content) {
    return 'after  char:$content ${'x' * content}';
  }

  ListState({
    this.before = const [],
    this.middle = const [],
    this.after = const [],
    this.anchor = 0,
    this.session = 1,
  });

  ListState copyWith({
    List<int>? before,
    List<int>? middle,
    List<int>? after,
    int? anchor,
    int? session,
  }) {
    return ListState(
      before: before ?? this.before,
      middle: middle ?? this.middle,
      after: after ?? this.after,
      anchor: anchor ?? this.anchor,
      session: session ?? this.session,
    );
  }
}

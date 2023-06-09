part of 'list_bloc.dart';

@immutable
abstract class ListEvent {}

class ListLoadUpper extends ListEvent {}

class ListLoadBottom extends ListEvent {}

class ListRegenerate extends ListEvent {}

class ListRefreshSession extends ListEvent {}

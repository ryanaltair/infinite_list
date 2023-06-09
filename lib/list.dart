import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/list_bloc.dart';

class InfiniteList extends StatefulWidget {
  const InfiniteList({Key? key}) : super(key: key);

  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController(
      keepScrollOffset: false,
      debugLabel: 'list',
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final centerKey = const ValueKey('center');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      // buildWhen: (previous, current) => previous.session!=current.session,
      builder: (context, state) {
        return ScrollView(
          centerKey: centerKey,
          controller: controller,
          state: state,
        );
      },
    );
  }
}

class ScrollView extends StatefulWidget {
  const ScrollView({
    super.key,
    required this.centerKey,
    required this.controller,
    required this.state,
  });

  final ValueKey<String> centerKey;
  final ScrollController controller;
  final ListState state;

  @override
  State<ScrollView> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollView> {
  late Future<bool> future;
  final GlobalKey _key = GlobalKey();
  double _anchor = 0.0000;
  bool _showReversed = false;
  bool _mask = true;
  @override
  void initState() {
    future = Future<bool>.delayed(const Duration(milliseconds: 1000), () {
      return true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      // print(_getStageSize());
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        print(timeStamp);
        reRender();
      },
    );
    super.initState();
  }

  Future reRender() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final height = _getStageSize().height;
    final viewHeight = context.size?.height ?? 0;
    print([height, viewHeight]);
    if (height > viewHeight) {
      _anchor = 0.99999;
      _showReversed = true;
    }
    _mask = false;
    setState(() {});
  }

  Size _getStageSize() {
    final RenderBox renderLogo =
        _key.currentContext!.findRenderObject()! as RenderBox;
    return renderLogo.size;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          center: widget.centerKey,
          controller: widget.controller,
          anchor: _anchor,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final content = ListState.getBefore(
                      widget.state.before.reversed.toList()[index]);
                  return ListItem(content);
                },
                childCount: widget.state.before.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
            ),
            SliverOffstage(
              offstage: true,
              sliver: SliverToBoxAdapter(
                child: Column(
                  key: _key,
                  children: [
                    ...widget.state.middle
                        .map((e) {
                          final content = ListState.getMiddle(e);
                          return ListItem(content);
                        })
                        .toList()
                        .reversed
                  ],
                ),
              ),
            ),
            if (_showReversed)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final content = ListState.getMiddle(
                        widget.state.middle.reversed.toList()[index]);
                    return ListItem(
                      content,
                      color: Colors.greenAccent,
                    );
                  },
                  childCount: widget.state.middle.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                ),
              ),
            SliverPadding(
                key: widget.centerKey, padding: const EdgeInsets.only(top: 0)),
            if (!_showReversed)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final content = ListState.getMiddle(
                        widget.state.middle.toList()[index]);
                    return ListItem(
                      content,
                      color: Colors.redAccent,
                    );
                  },
                  childCount: widget.state.middle.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final content = ListState.getAfter(widget.state.after[index]);
                  return ListItem(content, color: Colors.cyan);
                },
                childCount: widget.state.after.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
            )
          ],
        ),
        if (_mask)
          Container(
            width: 2400,
            height: 2400,
            color: Colors.white,
          )
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(
    this.content, {
    super.key,
    this.color = Colors.amber,
  });
  final Color color;
  final String content;
  @override
  Widget build(BuildContext context) {
    final height = ListState.getHeight(content);
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: SizedBox(
        height: height,
        child: Text(content),
      ),
    );
  }
}

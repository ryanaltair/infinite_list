import 'dart:math';

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
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  jumpToBottom() {
    final value = controller.position.maxScrollExtent;

    for (final ScrollPosition position
        in List<ScrollPosition>.of(controller.positions)) {
      if (position is ScrollPositionWithSingleContext) {
        position.goIdle();
        if (position.pixels != value) {
          final double oldPixels = position.pixels;
          position.forcePixels(value);
          // position.didStartScroll();
          // position.didUpdateScrollPositionBy(position.pixels - oldPixels);
          // position.didEndScroll();
        }
        // position.goBallistic(0.0);
      } else {
        position.jumpTo(value);
      }
    }
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
  @override
  void initState() {
    future = Future<bool>.delayed(const Duration(milliseconds: 1000), () {
      return true;
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!widget.controller.hasClients) {
          print('no clients');
          return;
        }
        print('jump');
        widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
        // duration: const Duration(microseconds: 1),
        // curve: Curves.linear);
        // jumpToBottom();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          center: widget.centerKey,
          controller: widget.controller,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListItem(widget.state.getBefore(index) ?? 'none');
                },
                childCount: widget.state.before.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
            ),
            SliverList(
              key: widget.centerKey,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListItem(
                    widget.state.getAfter(index) ?? 'none',
                    color: Colors.cyan,
                  );
                },
                childCount: widget.state.after.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
            )
          ],
        ),
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const SizedBox();
              }
              return Container(
                width: 2400,
                height: 2400,
                color: Colors.redAccent,
              );
            })
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(this.content, {super.key, this.color = Colors.amber});
  final Color color;
  final String content;
  @override
  Widget build(BuildContext context) {
    final height = pow(sin(content.length / pi), 2) * 100.0 + 50;
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: SizedBox(
        height: height,
        child: Text(content),
      ),
    );
  }
}

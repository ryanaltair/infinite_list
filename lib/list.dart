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

  final centerKey = ValueKey('center');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        return NotificationListener(
          onNotification: (notification) {
            if(notification is ScrollNotification){
              if(notification.metrics.atEdge){
                context.read<ListBloc>().add(ListLoadUpper());
                // context.read<ListBloc>().add(ListLoadUpper());
              }
            }
            return false;
          },
          child: CustomScrollView(
            center: centerKey,
            controller: controller,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      child: Text(state.getContent(index) ?? 'none'),
                    );
                  },
                ),
              ),
              SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      child: Text(state.getContent(index) ?? 'none'),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

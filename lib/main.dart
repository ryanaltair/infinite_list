import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/list_bloc.dart';
import 'list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc()..add(ListRegenerate()),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ListBloc, ListState>(
                builder: (context, state) {
                  return InfiniteList(
                    key: Key(state.session.toString()),
                  );
                },
              ),
            ),
            const Row(
              children: [
                ListInfo(),
                Spacer(),
                RefreshButton(),
                AddTopButton(),
                AddBottomButton()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ListBloc>().add(ListRegenerate());
      },
      tooltip: 'refresh list',
      icon: const Icon(Icons.refresh),
    );
  }
}

class AddTopButton extends StatelessWidget {
  const AddTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ListBloc>().add(ListLoadUpper());
      },
      tooltip: 'add top',
      icon: const Icon(Icons.vertical_align_top),
    );
  }
}

class AddBottomButton extends StatelessWidget {
  const AddBottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ListBloc>().add(ListLoadBottom());
      },
      tooltip: 'add bottom',
      icon: const Icon(Icons.vertical_align_bottom),
    );
  }
}

class ListInfo extends StatelessWidget {
  const ListInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        return Text('session: ${state.session} before: ${state.before.length} ${state.after.length} ');
      },
    );
  }
}

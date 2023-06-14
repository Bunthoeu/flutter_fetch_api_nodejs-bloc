import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';
import '../bloc/user_bloc.dart';
import '../create_user_screen/create_screen.dart';
import '../update_screen/update_screen.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UsersBloc bloc = UsersBloc();
  var loaded = false;
  List<UserModel>? todos;
  @override
  void initState() {
    super.initState();
    bloc.add(UnitUsersStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(),
      child: BlocListener(
        bloc: bloc,
        listener: (context, state) {
          if (state is UsersLoadingState) {
            setState(() {
              loaded = false;
            });
          } else if (state is UsersLoadedState) {
            todos = state.todos;
            setState(() {
              loaded = true;
            });
          } else if (state is UsersDeleteLoadingState) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Please Wait'),
                content: const Text('Deleting.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Okay'),
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
          } else if (state is UsersDeleteLoadedState) {
            Navigator.pop(context);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Deleted.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Okay'),
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
            bloc.add(UnitUsersStartEvent());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("USER LIST"),
          ),
          body: loaded
              ? RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  strokeWidth: 4.0,
                  onRefresh: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenPage()));
                    // Replace this delay with the code to be executed during refresh
                    // and return a Future when code finishes execution.
                    return Future<void>.delayed(const Duration(seconds: 3));
                  },
                  child: ListView.builder(
                    itemCount: todos!.length,
                    itemBuilder: (context, index) {
                      UserModel user = todos![index];
                      return Card(
                        child: ListTile(
                          title: Text(todos![index].name),
                          leading: CircleAvatar(
                            child: Text(user.id.toString()),
                          ),
                          trailing: Wrap(
                            spacing: 12,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateScreenPage(
                                        todo: todos![index],
                                        refreshFn: () {
                                          bloc.add(UnitUsersStartEvent());
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  bloc.add(
                                    UsersDeleteEvent(todos![index]),
                                  );
                                },
                              ), // icon-1
                              // icon-2
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreenPage(
                    refreshFn: () {
                      bloc.add(UnitUsersStartEvent());
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

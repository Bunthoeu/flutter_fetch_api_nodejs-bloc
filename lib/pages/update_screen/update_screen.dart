import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/todo_model.dart';
import '../bloc/user_bloc.dart';

class UpdateScreenPage extends StatefulWidget {
  final UserModel todo;
  final void Function() refreshFn;

  const UpdateScreenPage(
      {required this.todo, required this.refreshFn, Key? key})
      : super(key: key);

  @override
  _UpdateScreenPageState createState() => _UpdateScreenPageState();
}

class _UpdateScreenPageState extends State<UpdateScreenPage> {
  UsersBloc bloc = UsersBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.name;
    emailController.text = widget.todo.email;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is UsersUpdateLoadingState) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Please Wait'),
              content: const Text('Editing.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else if (state is UsersUpdateLoadedState) {
          Navigator.pop(context);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Edited.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
          widget.refreshFn();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("EDIT"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                ElevatedButton(
                  onPressed: () {
                    bloc.add(
                      UsersUpdateEvent(
                        UserModel(
                            id: widget.todo.id,
                            name: nameController.text,
                            email: emailController.text),
                      ),
                    );
                  },
                  child: const Text("Edit"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

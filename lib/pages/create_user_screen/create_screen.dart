import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../models/todo_model.dart';
import '../bloc/user_bloc.dart';

class CreateScreenPage extends StatefulWidget {
  final void Function() refreshFn;

  const CreateScreenPage({required this.refreshFn, Key? key}) : super(key: key);

  @override
  _CreateScreenPageState createState() => _CreateScreenPageState();
}

class _CreateScreenPageState extends State<CreateScreenPage> {
  UsersBloc bloc = UsersBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is UsersCreateLoadingState) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Please Wait'),
              content: const Text('Creating.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else if (state is UsersCreateLoadedState) {
          Navigator.pop(context);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Created.'),
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
            title: const Text("Create"),
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
                      UsersCreateEvent(
                        UserModel(
                            id: 0,
                            name: nameController.text,
                            email: emailController.text),
                      ),
                    );
                    nameController.text = '';
                    emailController.text = '';
                  },
                  child: const Text("Create"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

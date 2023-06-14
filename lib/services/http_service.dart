import 'dart:convert';


import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class HttpServices {
  Future<List<UserModel>> getAllTodos() async {
    var response =
        await http.get(Uri.parse("http://192.168.100.34:8080/user"));
    var usersBody = jsonDecode(response.body);
    List<UserModel> todos = [];
    for (var users in usersBody) {
      UserModel user =
          UserModel(id: users['id'], name: users['name'], email: users['email']);
      todos.add(user);
    }
    return todos;
  }

  void createTodo(UserModel users) async {
    var response =
        await http.post(Uri.parse("http://192.168.100.34:8080/user"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode({"name": users.name, "email": users.email}));
    print(response.statusCode);
  }

  void updateTodo(UserModel user) async {
    var response =
        await http.put(Uri.parse("http://192.168.100.34:8080/user/${user.id}"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode({"name": user.name, "email": user.email}));
    print(response.statusCode);
  }

  void deleteTodo(UserModel user) async {
    var response = await http
        .delete(Uri.parse("http://192.168.100.34:8080/user/${user.id}"));
    print(response.statusCode);
  }
}

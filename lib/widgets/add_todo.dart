// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_todo_api/widgets/styled_flat_button.dart';

class AddTodo extends StatefulWidget {
  final Function addTodo;

  const AddTodo(this.addTodo, {Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: null,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: 'New to do item'),
              controller: textController,
            ),
          ),
          ButtonBar(
            children: <Widget>[
              StyledFlatButton(
                'Save',
                onPressed: () async {
                  await widget.addTodo(textController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

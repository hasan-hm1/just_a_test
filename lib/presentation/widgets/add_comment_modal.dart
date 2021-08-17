import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interview_test/data/models/announcements/comment.dart';
import 'package:interview_test/logic/bloc/comments_bloc/comments_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentModal extends StatefulWidget {
  @override
  _AddCommentModalState createState() => _AddCommentModalState();
}

class _AddCommentModalState extends State<AddCommentModal> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        if (_formKey.currentState != null &&
            _formKey.currentState!.validate()) {
          Navigator.of(context).pop();
          context.read<CommentsBloc>().add(
                AddComment(
                  comment: Comment(
                      comment: _commentController.text.trim(),
                      userEmail:
                          FirebaseAuth.instance.currentUser?.email ?? ''),
                ),
              );
        }
      },
      child: Text('Add'),
    );
  }

  Widget _buildCommentField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        validator: (text) => text!.trim().isEmpty ? 'Required Field' : null,
        controller: _commentController,
        maxLines: 3,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Type comment '),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCommentField(),
          SizedBox(
            height: 40,
          ),
          _buildAddButton(),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}

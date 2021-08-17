import 'package:flutter/material.dart';
import 'package:interview_test/data/models/announcements/announcement.dart';
import 'package:interview_test/logic/bloc/announcements_bloc/announcements_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAnnouncementModal extends StatefulWidget {
  @override
  _AddAnnouncementModalState createState() => _AddAnnouncementModalState();
}

class _AddAnnouncementModalState extends State<AddAnnouncementModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildTitleField() {
    return TextFormField(
      validator: (text) => text!.trim().isEmpty ? 'Required Field' : null,
      controller: _titleController,
      maxLines: 1,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Type a title'),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      validator: (text) => text!.trim().isEmpty ? 'Required Field' : null,
      controller: _textController,
      maxLines: 3,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Type a description'),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: _addAnnouncement,
      child: Text(
        'Add',
      ),
    );
  }

  void _addAnnouncement() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      context.read<AnnouncementsBloc>().add(
            AddAnnouncement(
              announcement: Announcement(
                title: _titleController.text.trim(),
                body: _textController.text.trim(),
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleField(),
            SizedBox(
              height: 10,
            ),
            _buildTextField(),
            SizedBox(
              height: 20,
            ),
            _buildAddButton(),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}

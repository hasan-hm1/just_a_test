import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/data/models/auth/user.dart';
import 'package:interview_test/logic/bloc/auth_bloc/auth_bloc.dart';
import 'package:interview_test/presentation/screens/announcements/all_announcements_screen.dart';
import 'package:interview_test/presentation/widgets/choice_chip_theme.dart';
import 'package:interview_test/presentation/widgets/common.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final AuthBloc authBloc;
  // local state
  bool _isStudent = false;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildUserTypeRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChipTheme(
            isSelected: !_isStudent,
            child: ChoiceChip(
              label: Text('Teacher'),
              selected: !_isStudent,
              onSelected: (bool selected) {
                setState(
                  () {
                    _isStudent = false;
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ChoiceChipTheme(
            isSelected: _isStudent,
            child: ChoiceChip(
              label: Text('Student'),
              selected: _isStudent,
              onSelected: (bool selected) {
                if (selected) {}
                setState(
                  () {
                    _isStudent = true;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 50),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: _signup,
          child: Text('Signup'),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: _signin,
        child: Text('Login'),
      ),
    );
  }

  Future<void> _signup() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final user = User(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          type: _getUserTypeAsString());

      authBloc.add(
        Siginup(user: user),
      );
    }
  }

  Future<void> _signin() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final user = User(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          type: _getUserTypeAsString());
      authBloc.add(
        SiginIn(user: user),
      );
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (text) => text!.trim().isEmpty ? 'Required Field' : null,
      decoration: InputDecoration(
        hintText: 'Email',
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: TextFormField(
        controller: _passwordController,
        validator: (text) => text!.trim().isEmpty ? 'Required Field' : null,
        decoration: InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }

  Widget _buildUserTypeLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text('Select user Type (for signup only)'),
    );
  }

  void _handleErrorState(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(
        errorMessage: errorMessage,
      ),
    );
  }

  String _getUserTypeAsString() {
    if (_isStudent) {
      return 'student';
    }
    return 'teacher';
  }

  Widget _buildScreenBody() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEmailField(),
                _buildPasswordField(),
                _buildUserTypeLabel(),
                _buildUserTypeRow(),
                _buildSignupButton(),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => AllAnouncementsScreen(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return current is AuthError || current is AuthSuccess;
        },
        listener: (ctx, state) {
          if (state is AuthError) {
            _handleErrorState(state.errorMessage);
          } else if (state is AuthSuccess) {
            _navigateToHome();
          }
        },
        builder: (ctx, state) {
          if (state is AuthLoading) {
            return Stack(
              children: [
                _buildScreenBody(),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CeneteredCircualrProgressIndicator(),
                  ),
                ),
              ],
            );
          }

          return _buildScreenBody();
        },
      ),
    );
  }
}

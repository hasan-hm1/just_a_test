import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/data/repositories/auth_repository.dart';
import 'package:interview_test/enums/user_type.dart';
import 'package:interview_test/logic/bloc/announcements_bloc/announcements_bloc.dart';
import 'package:interview_test/logic/bloc/auth_bloc/auth_bloc.dart';
import 'package:interview_test/presentation/screens/auth/auth_screen.dart';
import 'package:interview_test/presentation/widgets/add_announcement_modal.dart';
import 'package:interview_test/presentation/widgets/announcement_list_item.dart';
import 'package:interview_test/presentation/widgets/common.dart';

class AllAnouncementsScreen extends StatefulWidget {
  @override
  _AllAnouncementsScreenState createState() => _AllAnouncementsScreenState();
}

class _AllAnouncementsScreenState extends State<AllAnouncementsScreen> {
  late final AnnouncementsBloc bloc;

  @override
  void initState() {
    bloc = context.read<AnnouncementsBloc>();
    if (context.read<AuthRepository>().userType == null) {
      context.read<AuthBloc>().add(
            FetchUserType(userId: FirebaseAuth.instance.currentUser!.uid),
          );
    }
    super.initState();
  }

  @override
  void dispose() {
    // close announcements stream subscription
    bloc.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('Are you sure ?'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(Signout());
              Navigator.of(context).pop();
            },
            child: Text(
              'confirm',
              style: TextStyle(
                color: Colors.pink.withOpacity(0.3),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'cancel',
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Announcements'),
      actions: [
        IconButton(
            onPressed: () {
              _showConfirmationDialog();
            },
            icon: Icon(Icons.logout)),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => BlocProvider.value(
            value: bloc,
            child: BlocProvider<AnnouncementsBloc>.value(
              value: context.read<AnnouncementsBloc>(),
              child: AddAnnouncementModal(),
            ),
          ),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.add,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) => Navigator.of(context)
              .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AuthScreen()),
                  (route) => false),
          listenWhen: (previous, current) => current is Signedout,
          buildWhen: (previous, current) =>
              current is AuthSuccess || current is AuthError,
          builder: (ctx, state) {
            if (state is AuthSuccess) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: _buildAppBar(),
                body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                  bloc: bloc,
                  builder: (ctx, state) {
                    if (state is AnnouncementsFetched) {
                      return ListView(
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 100),
                        children: state.announcements
                            .map<Widget>((announ) =>
                                AnnouncementListItem(announcement: announ))
                            .toList(),
                      );
                    } else if (state is AnnouncementsError) {
                      return Center(
                        child: Text('Error'),
                      );
                    }

                    return CeneteredCircualrProgressIndicator();
                  },
                ),
                floatingActionButton:
                    context.read<AuthRepository>().userType == UserType.teacher
                        ? _buildFloatingActionButton()
                        : SizedBox(),
              );
            } else if (state is AuthError) {
              return Scaffold(
                appBar: _buildAppBar(),
                body: Center(
                  child: Text('Error'),
                ),
              );
            }

            return Scaffold(
              appBar: _buildAppBar(),
              body: CeneteredCircualrProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

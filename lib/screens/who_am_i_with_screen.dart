import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/who_am_i_with/who_am_i_with_bloc.dart';
import '../bloc/who_am_i_with/who_am_i_with_event.dart';
import '../bloc/who_am_i_with/who_am_i_with_state.dart';
import '../l10n/app_localizations.dart';

class WhoAmIWithScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WhoAmIWithBloc()..add(LoadFriendsEvent()),
      child: BlocListener<WhoAmIWithBloc, WhoAmIWithState>(
        listenWhen: (prev, curr) =>
            prev is WhoAmIWithLoaded &&
            curr is WhoAmIWithLoaded &&
            curr.saved == true &&
            prev.saved != true,
        listener: (context, state) async {
          if (state is WhoAmIWithLoaded && state.saved) {
            await Future.delayed(Duration(seconds: 1));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.save)),
            );
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.who_am_i_with),
          ),
          body: BlocBuilder<WhoAmIWithBloc, WhoAmIWithState>(
            builder: (context, state) {
              if (state is WhoAmIWithLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is WhoAmIWithLoaded) {
                final searchController = TextEditingController(
                  text: state.searchQuery,
                );
                final filteredFriends = state.friends.where((friend) {
                  final nickname = (friend['nickname'] ?? '')
                      .toString()
                      .toLowerCase();
                  final query = state.searchQuery.toLowerCase();
                  return nickname.contains(query);
                }).toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.search_by_nickname,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<WhoAmIWithBloc>().add(
                            UpdateSearchQueryEvent(value),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredFriends.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)!.no_friends_found,
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredFriends.length,
                              itemBuilder: (context, index) {
                                final friend = filteredFriends[index];
                                final isSelected = state.selectedFriends
                                    .contains(friend['uid']);
                                return GestureDetector(
                                  onTap: () {
                                    context.read<WhoAmIWithBloc>().add(
                                      ToggleFriendEvent(friend['uid']),
                                    );
                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Colors.blue[100]
                                        : Colors.white,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            friend['photoUrl'] != null &&
                                                friend['photoUrl'].isNotEmpty
                                            ? NetworkImage(friend['photoUrl'])
                                            : null,
                                        child:
                                            (friend['photoUrl'] == null ||
                                                friend['photoUrl'].isEmpty)
                                            ? Text(
                                                friend['nickname'] != null &&
                                                        friend['nickname']
                                                            .isNotEmpty
                                                    ? friend['nickname'][0]
                                                    : '?',
                                              )
                                            : null,
                                      ),
                                      title: Text(friend['nickname'] ?? ''),
                                      subtitle: Text(
                                        (friend['name'] ?? '') +
                                            (friend['surname'] != null &&
                                                    friend['surname']
                                                        .toString()
                                                        .isNotEmpty
                                                ? ' ' + friend['surname']
                                                : ''),
                                      ),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                            )
                                          : Icon(Icons.radio_button_unchecked),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is WhoAmIWithError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.failed_to_load_friends,
                  ),
                );
              }
              return Container();
            },
          ),
          floatingActionButton: BlocBuilder<WhoAmIWithBloc, WhoAmIWithState>(
            builder: (context, state) {
              if (state is WhoAmIWithLoaded) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    context.read<WhoAmIWithBloc>().add(SaveCompanyEvent());
                  },
                  label: Text(AppLocalizations.of(context)!.save),
                  icon: Icon(Icons.save),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

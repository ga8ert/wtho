import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/source/colors.dart';
import '../bloc/chat/chat_bloc.dart';
import '../l10n/app_localizations.dart';
import 'chat_room_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load chats when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(LoadChats());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh chats when returning to the screen
    context.read<ChatBloc>().add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: TabBar(
            controller: _tabController,
            labelColor: CustomColors.darkblue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: CustomColors.blue,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.my_events),
              Tab(text: AppLocalizations.of(context)!.joined_events),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ChatLoaded) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // My events chats
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<ChatBloc>().add(LoadChats());
                      },
                      child: state.myEventsChats.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 200),
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.no_events,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: state.myEventsChats.length,
                              itemBuilder: (context, index) {
                                final chat = state.myEventsChats[index];
                                return ListTile(
                                  leading: const Icon(Icons.event),
                                  title: Text(chat.eventTitle),
                                  subtitle: Text(
                                    AppLocalizations.of(context)!.participants +
                                        ': ' +
                                        chat.userIds.length.toString(),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatRoomScreen(
                                          chatId: chat.chatId,
                                          eventTitle: chat.eventTitle,
                                          eventEndTime: chat.eventEndTime,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    // Joined events chats
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<ChatBloc>().add(LoadChats());
                      },
                      child: state.joinedEventsChats.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 200),
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.no_events,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: state.joinedEventsChats.length,
                              itemBuilder: (context, index) {
                                final chat = state.joinedEventsChats[index];
                                return ListTile(
                                  leading: const Icon(Icons.event_available),
                                  title: Text(chat.eventTitle),
                                  subtitle: Text(
                                    AppLocalizations.of(context)!.participants +
                                        ': ' +
                                        chat.userIds.length.toString(),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatRoomScreen(
                                          chatId: chat.chatId,
                                          eventTitle: chat.eventTitle,
                                          eventEndTime: chat.eventEndTime,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

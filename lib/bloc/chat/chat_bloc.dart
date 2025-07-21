import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatInfo {
  final String chatId;
  final String eventTitle;
  final List<String> userIds;
  final String authorId;
  final DateTime? eventEndTime;
  ChatInfo({
    required this.chatId,
    required this.eventTitle,
    required this.userIds,
    required this.authorId,
    this.eventEndTime,
  });
}

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {}

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatInfo> myEventsChats;
  final List<ChatInfo> joinedEventsChats;
  const ChatLoaded({
    required this.myEventsChats,
    required this.joinedEventsChats,
  });
  @override
  List<Object?> get props => [myEventsChats, joinedEventsChats];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const ChatLoaded(myEventsChats: [], joinedEventsChats: []));
        return;
      }
      final uid = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .get();
      final allChats = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ChatInfo(
          chatId: doc.id,
          eventTitle: data['eventTitle'] ?? '',
          userIds: List<String>.from(data['userIds'] ?? []),
          authorId: data['authorId'] ?? '',
          eventEndTime: data['eventEndTime'] != null
              ? DateTime.tryParse(data['eventEndTime'])
              : null,
        );
      }).toList();
      final myEventsChats = allChats.where((c) => c.authorId == uid).toList();
      final joinedEventsChats = allChats
          .where((c) => c.userIds.contains(uid) && c.authorId != uid)
          .toList();
      emit(
        ChatLoaded(
          myEventsChats: myEventsChats,
          joinedEventsChats: joinedEventsChats,
        ),
      );
    } catch (e) {
      emit(const ChatLoaded(myEventsChats: [], joinedEventsChats: []));
    }
  }
}

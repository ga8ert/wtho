import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wtho/l10n/app_localizations.dart';
import 'package:wtho/screens/user_profile_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatId;
  final String eventTitle;
  final DateTime? eventEndTime;
  const ChatRoomScreen({
    Key? key,
    required this.chatId,
    required this.eventTitle,
    this.eventEndTime,
  }) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  Map<String, Map<String, dynamic>> userProfiles = {};
  List<String> _lastUserIds = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfilesIfNeeded();
  }

  Future<void> _loadUserProfilesIfNeeded() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();
    final userIds = List<String>.from(chatDoc.data()?['userIds'] ?? []);
    if (userIds.isEmpty) return;
    if (_lastUserIds.join(',') == userIds.join(','))
      return; // не оновлювати, якщо не змінились
    final usersSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: userIds)
        .get();
    setState(() {
      userProfiles = {for (var doc in usersSnap.docs) doc['uid']: doc.data()};
      _lastUserIds = userIds;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfilesIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ChatRoomScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUserProfilesIfNeeded();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _sending = true);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'senderId': user.uid,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        });
    _controller.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    _loadUserProfilesIfNeeded();
    final now = DateTime.now();
    String? expiryText;
    if (widget.eventEndTime != null) {
      final expiry = widget.eventEndTime!.add(const Duration(days: 7));
      final daysLeft = expiry.difference(now).inDays;
      if (daysLeft > 0) {
        expiryText = AppLocalizations.of(context)!.chat_expiry(daysLeft);
      } else {
        expiryText = AppLocalizations.of(context)!.chat_expired;
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.eventTitle)),
      body: Column(
        children: [
          if (expiryText != null)
            Container(
              width: double.infinity,
              color: Colors.yellow[100],
              padding: const EdgeInsets.all(12),
              child: Text(
                expiryText,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.no_data),
                  );
                }
                final user = FirebaseAuth.instance.currentUser;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data();
                    final isMe = user != null && msg['senderId'] == user.uid;
                    final sender = userProfiles[msg['senderId']];
                    String senderName = '';
                    if (sender != null) {
                      if ((sender['name'] ?? '').toString().isNotEmpty ||
                          (sender['surname'] ?? '').toString().isNotEmpty) {
                        senderName =
                            (sender['name'] ?? '') +
                            ' ' +
                            (sender['surname'] ?? '');
                      } else if ((sender['nickname'] ?? '')
                          .toString()
                          .isNotEmpty) {
                        senderName = sender['nickname'];
                      }
                    }
                    final senderPhoto = sender != null
                        ? sender['photoUrl']
                        : null;
                    String initials = '';
                    if (sender != null) {
                      if ((sender['name'] ?? '').toString().isNotEmpty)
                        initials += sender['name'][0];
                      if ((sender['surname'] ?? '').toString().isNotEmpty)
                        initials += sender['surname'][0];
                      if (initials.isEmpty &&
                          (sender['nickname'] ?? '').toString().isNotEmpty)
                        initials = sender['nickname'][0];
                    }
                    final time = msg['timestamp'] != null
                        ? _formatTime(msg['timestamp'])
                        : '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  final currentUserId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (msg['senderId'] != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => UserProfileScreen(
                                          userId: msg['senderId'],
                                          currentUserId: currentUserId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child:
                                    senderPhoto != null &&
                                        senderPhoto.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          senderPhoto,
                                        ),
                                        radius: 18,
                                      )
                                    : CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.deepPurple[100],
                                        child: Text(
                                          initials.toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (!isMe && senderName.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 2,
                                      bottom: 2,
                                    ),
                                    child: Text(
                                      senderName.trim(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepPurple,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.green[100]
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(
                                        isMe ? 16 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 4 : 16,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        msg['text'] ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        time,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isMe) const SizedBox(width: 36),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.chat_input_hint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_sending,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

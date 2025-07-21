import 'package:flutter/material.dart';

class MeetingCardData {
  final String title;
  final String subtitle;
  final List<ImageProvider> avatars;

  MeetingCardData({
    required this.title,
    required this.subtitle,
    required this.avatars,
  });
}

class MeetingCard extends StatelessWidget {
  final MeetingCardData data;

  const MeetingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(data.subtitle, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: data.avatars.map((image) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(radius: 20, backgroundImage: image),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

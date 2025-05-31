import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<dynamic> dosenList = [];

  @override
  void initState() {
    super.initState();
    loadDosenData();
  }

  Future<void> loadDosenData() async {
    final String response =
        await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      dosenList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'WhKasmisaja',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(
                    child: Text(
                      'Belum ada pencarian',
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          final List<dynamic> messages = dosen['details'] ?? [];
          final lastMessage = messages.isNotEmpty
          ? messages[messages.length - 1]['message']
          : 'Belum ada chat';
          final String lastMessageRole = messages.isNotEmpty
          ? messages[messages.length - 1]['role']
          : '';
          final String lastMessageTime = lastMessageRole == 'dosen' ? '2 menit lalu' : 'Kemarin';

          // Since JSON does not have 'is_read', unreadCount will be 0
          final int unreadCount = lastMessageRole == 'dosen' ? 1 : 0;

          return ListTile(
        onTap: () {
          // Transform dosen data to match PesanScreen expected structure
          final transformedDosen = {
            'avatar': dosen['img'],
            'full_name': dosen['name'],
            'messages': (dosen['details'] as List<dynamic>).map((detail) {
              return {
                'from': detail['role'] == 'dosen' ? 0 : 1,
                'message': detail['message'],
              };
            }).toList(),
          };
          Navigator.push(
            context,
            MaterialPageRoute(
          builder: (context) => PesanScreen(dosen: transformedDosen),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage(dosen['img']),
        ),
        title: Text(dosen['name']),
        subtitle: Text(lastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (unreadCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              unreadCount.toString(),
              style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
              ),
            ),
          ),
            const SizedBox(height: 4),
            Text(
          lastMessageTime,
          style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'Pembaruan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
        ],
      ),
    );
  }
}
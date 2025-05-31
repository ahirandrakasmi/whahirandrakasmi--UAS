import 'package:flutter/material.dart';

class PesanScreen extends StatefulWidget {
  final dynamic dosen;
  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  late List<dynamic> messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages = List<dynamic>.from(widget.dosen['messages']);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'from': 1, 'message': text});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 29,
        elevation: 2,
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundImage: AssetImage(widget.dosen['avatar']),
            radius: 16,
          ),
          title: Text(
            widget.dosen['full_name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text('06.30'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isDosen = message['from'] == 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: isDosen
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDosen)
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.dosen['avatar']),
                          radius: 14,
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          decoration: BoxDecoration(
                            color: isDosen
                                ? colorScheme.tertiary
                                : colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isDosen ? 0 : 12),
                              bottomRight: Radius.circular(isDosen ? 12 : 0),
                            ),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(
                              fontSize: 15,
                              color: isDosen
                                  ? colorScheme.onTertiary
                                  : colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      if (!isDosen)
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/gambar_dosen/Ahirandra_Kasmi.jpg'),
                          radius: 14,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              controller: _controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.emoji_emotions),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
                hintText: 'Ketikkan pesan',
                filled: true,
              ),
            ),
          ),
        ],
     ),
    );
  }
}
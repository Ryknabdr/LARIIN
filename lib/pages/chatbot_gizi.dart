import 'package:flutter/material.dart';

class ChatbotGiziTab extends StatefulWidget {
  const ChatbotGiziTab({super.key});

  @override
  State<ChatbotGiziTab> createState() => _ChatbotGiziTabState();
}

class _ChatbotGiziTabState extends State<ChatbotGiziTab> {
  // Controller untuk input pesan
  final TextEditingController _messageController = TextEditingController();

  // Daftar pesan (dummy AI)
  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'message':
          'Halo! Saya adalah chatbot gizi Lariin. Saya bisa membantu Anda dengan pertanyaan tentang nutrisi, diet, dan kesehatan. Apa yang bisa saya bantu hari ini?',
    },
  ];

  // Fungsi kirim pesan
  void _sendMessage() {
    // Cek kalau input tidak kosong
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        // Tambahkan pesan user
        _messages.add({
          'sender': 'user',
          'message': _messageController.text.trim(),
        });

        // Tambahkan respon bot (dummy)
        _messages.add({
          'sender': 'bot',
          'message':
              'Terima kasih atas pertanyaannya! Saya sedang memproses jawaban yang tepat untuk Anda. Fitur integrasi AI akan segera hadir untuk memberikan respons yang lebih cerdas.',
        });
      });

      // Clear input
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar chatbot
      appBar: AppBar(
        title: const Text(
          'Chatbot Gizi',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      // Isi halaman
      body: Column(
        children: [
          // Daftar chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user'; // cek posisi bubble

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight // chat user di kanan
                      : Alignment.centerLeft,  // chat bot di kiri
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75, // max lebar bubble
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF0077BE)  // warna bubble user
                          : Colors.grey[200],        // warna bubble bot
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87, // warna teks
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input chat + tombol kirim
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // TextField input pesan
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pertanyaan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(), // tekan enter
                  ),
                ),

                const SizedBox(width: 8),

                // Tombol send
                CircleAvatar(
                  backgroundColor: const Color(0xFF0077BE),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose(); // bersihkan controller
    super.dispose();
  }
}

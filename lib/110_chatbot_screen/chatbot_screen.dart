import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../service_now_ticket_screen.dart';
import '../../servicenow_service.dart';
// import 'package:flutter/servicenow_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  late ServiceNowService serviceNowService;

  final String aiUrl = "https://flutter-ai-chatbot.onrender.com/ask";

  @override
  void initState() {
    super.initState();
    // In production, get these from secure storage or environment variables
    serviceNowService = ServiceNowService(
      instanceUrl: 'https://dev268721.service-now.com',
      username: 'admin',
      password: 'FY*m58GJtko/', 
    );
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": message});
      isLoading = true;
    });

    try {
      if (_isSupportRequest(message)) {
        final ticketNumber = await _handleSupportRequest(message);
        _addBotMessage("Your support request has been logged. Ticket Number: $ticketNumber");
      } else {
        await _handleAiRequest(message);
      }
    } catch (e) {
      _addBotMessage("Sorry, I encountered an error: ${e.toString().replaceAll(RegExp(r'^Exception: '), '')}");
      debugPrint('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<String> _handleSupportRequest(String message) async {
    try {
      return await serviceNowService.createIncident(message);
    } catch (e) {
      throw Exception('Failed to create ServiceNow ticket: $e');
    }
  }

  Future<void> _handleAiRequest(String message) async {
    try {
      final response = await http.post(
        Uri.parse(aiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"question": message}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _addBotMessage(data["answer"]);
      } else {
        throw Exception('AI service returned ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      messages.add({"role": "bot", "text": text});
    });
  }

  bool _isSupportRequest(String message) {
    final text = message.toLowerCase();
    return text.contains("issue") ||
        text.contains("error") ||
        text.contains("problem") ||
        text.contains("support") ||
        text.contains("ticket") ||
        text.contains("help");
  }

  Widget buildMessage(String role, String text) {
    return Align(
      alignment: role == "user" ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: role == "user" ? Colors.deepPurple[100] : Colors.grey[200],
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: role == "user"
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            if (role == "bot" && !isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Icon(Icons.check_circle, size: 16, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Flutter AI Chat", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'View Tickets',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServiceNowTicketScreen(service: serviceNowService),
                  ),
                );
              },
            ),
          ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 10),
                        Text("Typing...", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                }
                final msg = messages[index];
                return buildMessage(msg["role"]!, msg["text"]!);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type your message here",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (_controller.text.trim().isNotEmpty) {
                        sendMessage(_controller.text.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Map<String, String>> messages = [];
//   final TextEditingController _controller = TextEditingController();
//   bool isLoading = false;

//   Future<void> sendMessage(String message) async {
//     setState(() {
//       messages.add({"role": "user", "text": message});
//       isLoading = true;
//     });

//     final response = await http.post(
//       Uri.parse("https://flutter-ai-chatbot.onrender.com/ask"), // or your hosted URL
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"question": message}),
//     );

//     final data = json.decode(response.body);

//     setState(() {
//       messages.add({"role": "bot", "text": data["answer"]});
//       isLoading = false;
//     });
//   }

//   Widget buildMessage(String role, String text) {
//     return Align(
//       alignment: role == "user" ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: role == "user" ? Colors.deepPurple[100] : Colors.grey[200],
//           border: Border.all(color: Colors.deepPurple),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: role == "user"
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(fontSize: 16),
//             ),
//             if (role == "bot" && !isLoading)
//               const Padding(
//                 padding: EdgeInsets.only(top: 4.0),
//                 child: Icon(Icons.check_circle, size: 16, color: Colors.green),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Flutter AI Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length + (isLoading ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == messages.length && isLoading) {
//                   return const Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(width: 10),
//                         Text("Typing..."),
//                       ],
//                     ),
//                   );
//                 }
//                 final msg = messages[index];
//                 return buildMessage(msg["role"]!, msg["text"]!);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type your message here",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.deepPurple),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   color: Colors.deepPurple,
//                   onPressed: () {
//                     if (_controller.text.trim().isEmpty) return;
//                     sendMessage(_controller.text.trim());
//                     _controller.clear();
//                   },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceNowService {
  final String instanceUrl;
  final String username;
  final String password;
  final Duration timeoutDuration;

  ServiceNowService({
    required this.instanceUrl,
    required this.username,
    required this.password,
    this.timeoutDuration = const Duration(seconds: 30),
  });

  Map<String, String> get headers => {
    'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    'Content-Type': 'application/json',
  };

  Future<String> createIncident(String message) async {
    final url = Uri.parse('$instanceUrl/api/now/table/incident');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'short_description': 'Chatbot Support: $message',
          'urgency': '2',
          'category': 'inquiry',
        }),
      ).timeout(const Duration(seconds: 10)); // Reduced timeout for faster failure

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['result']['number'] ?? 'INC001'; // Fallback if number is null
      } else {
        throw Exception('ServiceNow Error ${response.statusCode}: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('ServiceNow timeout - check instance URL or network');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<String>> fetchUserTickets() async {
    final url = Uri.parse('$instanceUrl/api/now/table/incident?sysparm_limit=5');

    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['result'] as List;
        return results
            .map<String>((ticket) => ticket['number']?.toString() ?? 'N/A')
            .toList();
      } else {
        throw Exception('Failed to fetch tickets: ${response.statusCode}\n${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
import 'package:flutter/material.dart';
import 'servicenow_service.dart';

class ServiceNowTicketScreen extends StatefulWidget {
  final ServiceNowService service;

  const ServiceNowTicketScreen({super.key, required this.service});

  @override
  State<ServiceNowTicketScreen> createState() => _ServiceNowTicketScreenState();
}

class _ServiceNowTicketScreenState extends State<ServiceNowTicketScreen> {
  List<String> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final fetched = await widget.service.fetchUserTickets();
    setState(() {
      tickets = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
          ? const Center(child: Text("No tickets found"))
          : ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: Text(tickets[index]),
          );
        },
      ),
    );
  }
}

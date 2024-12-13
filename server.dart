import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ServerController {
  String serverAddress = "192.168.70.91";

  Future<void> updateRelay(BuildContext context, String relay, String state, Function(String, String) onSuccess) async {
    final url = Uri.parse('http://$serverAddress:5000/$relay');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'state': state}),
      );

      if (response.statusCode == 200) {
        onSuccess(relay, state);
        _showSnackBar(context, "$relay turned $state successfully!");
      } else {
        final errorMessage = jsonDecode(response.body)['error'] ?? "Unknown error";
        throw Exception(errorMessage);
      }
    } catch (e) {
      _showSnackBar(context, "Error: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

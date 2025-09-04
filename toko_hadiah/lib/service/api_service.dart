import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.241.199.4:8000/api";

  static Future<List<dynamic>> getCustomers() async {
    final response = await http.get(Uri.parse("$baseUrl/customers"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load customers");
    }
  }

  static Future<Map<String, dynamic>> getCustomerDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/customers/$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return {
        "id": data["CustID"],
        "name": data["Name"],
        "address": data["Address"],
        "phone": data["PhoneNo"],
        "ttotpList": List<String>.from(data["TTOTPList"] ?? []),
      };
    } else {
      throw Exception("Failed to load customer detail");
    }
  }

  static Future<List<dynamic>> getTTH() async {
    final response = await http.get(Uri.parse("$baseUrl/tth"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load TTH");
    }
  }

  static Future<List<dynamic>> getTTHDetail(String tthNo) async {
    final response = await http.get(Uri.parse("$baseUrl/tth/$tthNo"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load TTH Detail");
    }
  }

  static Future<List<Map<String, dynamic>>> getPrizeSummary() async {
    final url = Uri.parse("$baseUrl/summary-tth");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load prize summary");
    }
  }

  static Future<void> markTTHReceived(String ttottpno) async {
    final url = Uri.parse("$baseUrl/tth/receive/$ttottpno");
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal update TTH $ttottpno");
    }
  }

  static Future<String> getCustomerStatus(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/customers/$id/status"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"];
    } else {
      throw Exception("Gagal ambil status");
    }
  }

  static Future<void> updateTTH({
    required String tthNo,
    required int received,
    int? failedReason,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tth/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tthno": tthNo,
        "received": received,
        "failed_reason": failedReason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update TTH");
    }
  }


}

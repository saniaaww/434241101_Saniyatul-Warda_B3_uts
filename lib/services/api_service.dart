import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  static const baseUrl = "http://10.0.2.2:8000/api";
  static int? currentUserId;
  static String? currentUserName;
  static String? currentUserEmail;
  static String? currentUserRole;

  static Future login(String email, String password) async {
    try {
      print("HIT API");

      var response = await http
          .post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "email": email,
          "password": password,
        },
      )
          .timeout(const Duration(seconds: 10));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e, s) {
      print("ERROR API");
      print(e);
      print(s);
      return null;
    }
  }
  static Future<List<dynamic>> getComments(
      int ticketId) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/tickets/$ticketId/comments',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];

    } catch (e) {

      print(e);
      return [];
    }
  }

  static Future<List<dynamic>> getHistory(
      int ticketId) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/tickets/$ticketId/history',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];

    } catch (e) {

      print(e);
      return [];
    }
  }

  static Future<bool> sendComment(
      int ticketId,
      int userId,
      String comment,
      ) async {

    try {

      final response = await http.post(
        Uri.parse(
          '$baseUrl/tickets/$ticketId/comments',
        ),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'user_id': userId,
          'comment': comment,
        }),
      );

      return response.statusCode == 200;

    } catch (e) {

      print(e);
      return false;
    }
  }

  static Future<List<dynamic>> getTickets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
  static Future<Map<String, dynamic>?> getTicketDetail(
      int ticketId) async {

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/$ticketId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;

    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> updateStatus(
      int ticketId,
      String status) async {

    try {

      final response = await http.post(
        Uri.parse(
          '$baseUrl/tickets/$ticketId/status',
        ),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'status': status,
          'sender_id': currentUserId,
        }),
      );

      return response.statusCode == 200;

    } catch (e) {

      print(e);
      return false;
    }
  }

  static Future<bool> assignTicket(
      int ticketId,
      int helpdeskId) async {

    try {

      final response = await http.post(
        Uri.parse(
          '$baseUrl/tickets/$ticketId/assign',
        ),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'assigned_to': helpdeskId,
          'sender_id' : ApiService.currentUserId,
        }),
      );

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.body}");

      return response.statusCode == 200;

    } catch (e) {

      print(e);
      return false;
    }
  }

  static Future<bool> createTicket({
    required String title,
    required String description,
    required int userId,
    File? image,
  }) async {
    try {

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/tickets"),
      );

      request.fields["title"] = title;
      request.fields["description"] = description;
      request.fields["user_id"] = userId.toString();

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            image.path,
          ),
        );
      }

      var response = await request.send();

      final body = await response.stream.bytesToString();

      print("STATUS : ${response.statusCode}");
      print("BODY   : $body");

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } catch (e) {
      print(e);
      return false;
    }
  }


  static Future<Map<String, dynamic>?> getUser(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['success'] == true) {
          currentUserId = result['user']['id'];
          currentUserName = result['user']['name'];
          currentUserEmail = result['user']['email'];
          currentUserRole = result['user']['role'];
        }

        return result;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
  static Future<List<dynamic>> getHelpdesk() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/helpdesk'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
  static Future<bool> updateUser(
      int id,
      String name,
      String email,
      ) async {

    try {

      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      return response.statusCode == 200;

    } catch (e) {

      print(e);
      return false;
    }
  }
  static Future<List<dynamic>> getMyTickets() async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/helpdesk/tickets/$currentUserId",
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<List<dynamic>> getTicketByHelpdesk(int helpdeskId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/helpdesk/tickets/$helpdeskId"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<dynamic>> getHelpdeskUsers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/helpdesk-users"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<dynamic>> getMyUserTickets() async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/user/tickets/$currentUserId",
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
  // =====================================
// NOTIFICATION
// =====================================

  static Future<List<dynamic>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/notifications/$currentUserId",
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> readNotification(
      int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "$baseUrl/notifications/$notificationId/read",
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<dynamic>> getUsers() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/users"),
      );

      if(response.statusCode==200){

        return jsonDecode(response.body);

      }

      return [];

    } catch(e){

      print(e);

      return [];

    }

  }

  static Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        }),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> updateManagedUser({
    required int id,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/users/$id"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "role": role,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/users/$id"),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

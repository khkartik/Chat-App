import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

final key =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1heGxlbmRqeHRsY2dqbWlvZWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4OTA5MjgsImV4cCI6MjA2ODQ2NjkyOH0.d9oFjAGsq34QG50jbx3Ahc6f9UYrvDiaxgVuPgUARxA";
Future<List> messageList({
  required int sender_id,
  required int reciver_id,
}) async {
  final url = Uri.parse(
    "https://maxlendjxtlcgjmioebx.supabase.co/rest/v1/mes?reciver_id=eq.$reciver_id&sender_id=eq.$sender_id",
  );
  var response = await http.get(
    url,
    headers: {"apikey": "$key", "Authorization": "Bearer $key"},
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    var jsonResponse = convert.jsonDecode(response.body) as List;
    print("Chats:");
    print(jsonResponse);
    return jsonResponse;
  } else {
    return [];
  }
}

Future<bool> addmessage({
  required int reciver_id,
  required int sender_id,
  required String message,
}) async {
  final url = Uri.parse("https://maxlendjxtlcgjmioebx.supabase.co/rest/v1/mes");
  var response = await http.post(
    url,
    body: convert.jsonEncode({
      "reciver_id": reciver_id,
      "sender_id": sender_id,
      "message": message,
    }),
    headers: {
      "apikey": "$key",
      "Authorization": "Bearer $key",
      "Content-Type": "application/json",
      "Prefer": "return=minimal",
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Details added successfully.');
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Body: ${response.body}');
    return false;
  }
}

Future<bool> deletemassage({
  required int sender_id,
  required int reciver_id,
}) async {
  final url = Uri.parse(
    "https://maxlendjxtlcgjmioebx.supabase.co/rest/v1/mes?sender_id=eq.$sender_id&reciver_id=eq.$reciver_id",
  );
  var response = await http.delete(
    url,
    headers: {"apikey": "$key", "Authorization": "Bearer $key"},
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Details delete successfully.');
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Body: ${response.body}');
    return false;
  }
}

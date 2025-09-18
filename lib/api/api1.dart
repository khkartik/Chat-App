import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

final key =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1heGxlbmRqeHRsY2dqbWlvZWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4OTA5MjgsImV4cCI6MjA2ODQ2NjkyOH0.d9oFjAGsq34QG50jbx3Ahc6f9UYrvDiaxgVuPgUARxA";

Future<List<dynamic>> showAccount() async {
  final url = Uri.parse(
    "https://maxlendjxtlcgjmioebx.supabase.co/rest/v1/sign?select=*",
  );

  final response = await http.get(
    url,
    headers: {"apikey": key, "Authorization": "Bearer $key"},
  );

  if (response.statusCode == 200) {
    // Decode the response as a List of dynamic objects
    final List<dynamic> jsonResponse = convert.jsonDecode(response.body);
    print('Fetched ${jsonResponse.length} chats.');
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return [];
  }
}

Future<bool> addAccount({
  required String name,
  required int phno,
  required String password,
}) async {
  final url = Uri.parse(
    "https://maxlendjxtlcgjmioebx.supabase.co/rest/v1/sign",
  );
  var response = await http.post(
    url,
    body: convert.jsonEncode({
      "name": name,
      "phno": phno,
      "password": password,
    }),

    headers: {
      "apikey": "$key",
      "Authorization": "Bearer $key",
      "Content-Type": "application/json",
      "Prefer": "return=minimal",
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    // var jsonResponse = convert.jsonDecode(response.body);
    // var itemCount = jsonResponse['totalItems'];
    // print('Number of books about http: $itemCount.');
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }
}

import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: 'AIzaSyBJ6nwqlm_S1TQmSy8XwdvINR6ImlRZG_s',
);

Future<String> getGeminiReply(String prompt) async {
  try {
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No response from Gemini.';
  } catch (e) {
    return 'Error: $e';
  }
}

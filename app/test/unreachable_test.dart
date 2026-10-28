import 'package:droidcon_companion/schemas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genkit/client.dart';
import 'package:http/http.dart' as http;

void main() {
  test(
    'unreachable server surfaces as GenkitException(cause: ClientException)',
    () async {
      final flow = defineRemoteAction(
        url: 'http://127.0.0.1:1/companionFlow',
        inputSchema: CompanionInput.$schema,
        outputSchema: CompanionOutput.$schema,
      );
      try {
        await flow(input: CompanionInput(question: 'hi'));
        fail('expected an error');
      } on GenkitException catch (e) {
        expect(e.cause, isA<http.ClientException>());
      }
    },
  );
}

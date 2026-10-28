import 'package:genkit/client.dart';

import 'schemas.dart';

/// Where the Genkit backend is running.
///
/// 10.0.2.2 is the Android emulator's alias for your laptop's localhost.
/// On a real phone, use your laptop's Wi-Fi IP instead (find it with
/// `ipconfig getifaddr en0` on macOS), e.g. 'http://192.168.1.42:3400'.
/// The phone and laptop must be on the same network.
const backendUrl = 'http://10.0.2.2:3400';

/// A typed handle to companionFlow on the server.
///
/// The schemas are the same ones the backend uses, so the request and
/// response are checked against exactly the same shape on both ends.
final companionFlow = defineRemoteAction(
  url: '$backendUrl/companionFlow',
  inputSchema: CompanionInput.$schema,
  outputSchema: CompanionOutput.$schema,
);

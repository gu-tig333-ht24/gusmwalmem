import 'package:http/http.dart' as http;

// Client som lägger till token på alla anrop
// källa https://pub.dev/packages/http#using
class ApiTokenClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> defaultQueryParams;

  ApiTokenClient(String token, this._inner)
      : defaultQueryParams = {"key": token};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Lägg till query parameters i URL:en
    final uri = request.url;
    final updatedUri = uri.replace(
      queryParameters: {...uri.queryParameters, ...defaultQueryParams},
    );
    final updatedRequest = http.Request(request.method, updatedUri)
      ..headers.addAll(request.headers);

    // Om det finns ett body, skicka det vidare
    if (request is http.Request) {
      updatedRequest.bodyBytes = await request.finalize().toBytes();
    }

    return _inner.send(updatedRequest);
  }
}

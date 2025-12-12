import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _inner;
  String? _token;

  ApiClient({
    this.baseUrl = 'http://127.0.0.1:8000/api/',
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  String? get token => _token;

  Map<String, String> _headers({bool json = false}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    if (_token != null) headers['Authorization'] = 'Bearer $_token';
    return headers;
  }

  Future<http.Response> post(String path, {Map<String, String>? body}) {
    final uri = Uri.parse('$baseUrl$path');
    return _inner.post(uri, headers: _headers(), body: body);
  }

  /// Multipart POST (for file uploads)
  Future<http.Response> postMultipart(
    String path, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final req = http.MultipartRequest('POST', uri)
      ..fields.addAll(fields);

    if (_token != null) {
      req.headers['Authorization'] = 'Bearer $_token';
    }

    req.files.addAll(files);

    final streamed = await req.send();
    return http.Response.fromStream(streamed);
  }
  Future<http.Response> get(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return _inner.get(uri, headers: _headers());
  }
  
  Future<http.Response> delete(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return _inner.delete(uri, headers: _headers());
  }
  
  void setToken(String? token) {
    _token = token;
  }
}

final apiClient = ApiClient();

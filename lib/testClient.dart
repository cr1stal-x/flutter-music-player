import 'dart:async';
import 'dart:convert';
import 'dart:io';

class CommandClient {
  final String serverAddress = '192.168.1.8';
  final int serverPort = 5050;
  Socket? _socket;
  bool _connecting = false;

  Completer<Map<String, dynamic>>? _responseCompleter;

  final StringBuffer _buffer = StringBuffer();

  Future<void> connect() async {
    if (_socket != null) return;
    if (_connecting) return;

    _connecting = true;
    try {
      _socket = await Socket.connect(serverAddress, serverPort, timeout: Duration(seconds: 5));
      print('✅Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}');

      _socket!.listen(
            (event) {
          _buffer.write(utf8.decode(event));

          while (_buffer.toString().contains("\n")) {
            String fullMessage = _buffer.toString();
            int newlineIndex = fullMessage.indexOf("\n");

            String oneMessage = fullMessage.substring(0, newlineIndex).trim();
            _buffer.clear();
            _buffer.write(fullMessage.substring(newlineIndex + 1));

            if (oneMessage.isNotEmpty) {
              try {
                final decoded = jsonDecode(oneMessage);
                _responseCompleter?.complete(decoded);
              } catch (e) {
                print("❌ JSON decode error: $e");
                _responseCompleter?.completeError(e);
              }
              _responseCompleter = null;
            }
          }
        },
        onError: (err) {
          print('❌ Socket error: $err');
          _socket = null;
        },
        onDone: () {
          print('🔌 Disconnected from server');
          _socket = null;
        },
      );
    } catch (e) {
      print('❌ Connection failed: $e');
      _socket = null;
    } finally {
      _connecting = false;
    }
  }

  Future<Map<String, dynamic>> sendCommand(
      String method, {
        String username = "",
        String password = "",
        String email = "",
         Map<String, dynamic>? extraData,
      }) async {
    if (_socket == null) {
      await connect();
      if (_socket == null) {
        throw Exception('No connection to server');
      }
    }

    _responseCompleter = Completer<Map<String, dynamic>>();

    final command = {
      'method': method,
      'username': username,
      'password': password,
      'email':email,
      "extraData": extraData ?? {}
    };

    _socket!.write("${jsonEncode(command)}\n");
    print('📤 Sent: $command');

    return _responseCompleter!.future;
  }
}

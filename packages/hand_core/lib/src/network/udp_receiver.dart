import 'dart:async';
import 'dart:io';

class UdpTransceiver {
  final int port;
  RawDatagramSocket? _socket;
  StreamController<String>? _controller;

  UdpTransceiver({required this.port});

  /// Starts listening for incoming UDP packets.
  Future<void> startListening() async {
    _controller = StreamController<String>();
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket?.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket?.receive();
        if (datagram != null) {
          _controller?.add(String.fromCharCodes(datagram.data));
        }
      }
    });
  }

  /// Stops listening for incoming UDP packets.
  Future<void> stopListening() async {
    if (_socket != null) {
      _socket?.close();
      _socket = null;
    }
    if (_controller != null) {
      await _controller?.close();
      _controller = null;
    }
  }

  /// Sends a UDP packet to the specified address and port.
  void send(String message, InternetAddress address, int port) {
    _socket?.send(message.codeUnits, address, port);
  }

  /// Stream of incoming data.
  Stream<String> get onData => _controller!.stream;
}

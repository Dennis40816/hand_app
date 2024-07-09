import 'dart:async';
import 'dart:io';

class UdpReceiver {
  final int port;
  RawDatagramSocket? _socket;
  final StreamController<String> _controller = StreamController<String>();

  UdpReceiver(this.port);

  /// Starts listening for incoming UDP packets.
  void startListening() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket?.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket?.receive();
        if (datagram != null) {
          _controller.add(String.fromCharCodes(datagram.data));
        }
      }
    });
  }

  /// Stops listening for incoming UDP packets.
  void stopListening() {
    _socket?.close();
    _socket = null;
  }

  /// Stream of incoming data.
  Stream<String> get onData => _controller.stream;
}

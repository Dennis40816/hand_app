import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import '../../network/udp_receiver.dart';
import '../../parser/hand_log_parser.dart';
import '../../models/hand/hand_log_message.dart';
import '../common/terminal_controller.dart';

import '../../../globals.dart' as globals;

class HandLogTerminalController extends TerminalController {
  /// UDP related
  final UdpTransceiver udpTransceiver;
  StreamSubscription? _subscription;

  // TODO: Ensure these two values are reset together when the UI checkbox
  // becomes available for the user during state changes
  bool _stopUdpTransceiverWhenExit = false;
  bool _needStartListen = true;

  /// HAND log parser
  final HandLogParser logParser = HandLogParser();
  List<HandLogMessage> messageQueue = [];

  /// output style
  late TextStyle Function(HandLogLevel) getStyle;

  HandLogTerminalController(this.udpTransceiver);

  /// Overrides function
  @override
  void addTerminalInput(TextSpan textSpan, [String? showPrefix]) {
    super.addTerminalInput(textSpan, showPrefix);
    if (textSpan.text == null) {
      globals.logger.e("text should never be null");
      return;
    }

    udpTransceiver.send(
        textSpan.text!, InternetAddress("192.168.1.114"), 12345);
  }

  /// Translates messages in the queue to TextSpans and notifies listeners.
  void translateMessages() {
    List<TextSpan> newSpans = [];
    for (var message in messageQueue) {
      newSpans.add(
          TextSpan(text: message.toString(), style: getStyle(message.level)));
    }
    messageQueue.clear();

    // This will call notifyListeners();
    addTextSpanList(newSpans);
  }

  /// Starts the UDP receiver and listens for incoming messages.
  Future<void> startUdpReceiver() async {
    if (_needStartListen) {
      await udpTransceiver.startListening();
      _subscription = udpTransceiver.onData.listen((data) {
        HandLogMessage message = logParser.parseLog(data);
        messageQueue.add(message);
        translateMessages();
        notifyListeners();
      });

      _needStartListen = false;
    }
  }

  /// Stops the UDP receiver.
  Future<void> stopUdpReceiver() async {
    if (_stopUdpTransceiverWhenExit) {
      await udpTransceiver.stopListening();
      _subscription?.cancel();

      _needStartListen = true;
    }
  }

  /// Returns the current list of messages in the queue.
  List<HandLogMessage> getMessages() {
    return messageQueue;
  }

  /// Clears the message queue.
  void clearMessages() {
    messageQueue.clear();
  }

  /// Sets the function to get the TextStyle for each log level.
  void setGetStyleFunction(TextStyle Function(HandLogLevel) styleFunction) {
    getStyle = styleFunction;
  }
}

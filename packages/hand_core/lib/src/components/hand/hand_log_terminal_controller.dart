import 'dart:io';

import 'package:flutter/material.dart';
import '../../network/udp_receiver.dart';
import '../../parser/hand_log_parser.dart';
import '../../models/hand/hand_log_message.dart';
import '../common/terminal_controller.dart';

import '../../../globals.dart' as globals;

class HandLogTerminalController extends TerminalController {
  final UdpTransceiver udpTransceiver;
  final HandLogParser logParser = HandLogParser();
  List<HandLogMessage> messageQueue = [];
  late TextStyle Function(HandLogLevel) getStyle;

  HandLogTerminalController(this.udpTransceiver);

  /// Overrides function
  @override
  void addTerminalInput(TextSpan textSpan) {
    super.addTerminalInput(textSpan);
    if (textSpan.text == null) {
      globals.logger.e("text should never be null");
      return;
    }

    /// remove prefix

    /// TODO: transmit through udp
    /// globals.logger.d("TODO: transmit to HAND MAIN through given transmitter");
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
    addTextSpanList(newSpans);
    // notifyListeners();
  }

  /// Starts the UDP receiver and listens for incoming messages.
  void startUdpReceiver() {
    udpTransceiver.startListening();
    udpTransceiver.onData.listen((data) {
      HandLogMessage message = logParser.parseLog(data);
      messageQueue.add(message);
      translateMessages();
      notifyListeners();
    });
  }

  /// Stops the UDP receiver.
  void stopUdpReceiver() {
    udpTransceiver.stopListening();
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

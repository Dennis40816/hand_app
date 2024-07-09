import 'package:flutter/material.dart';
import '../../network/udp_receiver.dart';
import '../../parser/hand_log_parser.dart';
import '../../models/hand/hand_log_message.dart';
import '../common/terminal_controller.dart';

import 'package:logger/logger.dart';

var logger = Logger();

class HandLogTerminalController extends TerminalController {
  final UdpReceiver udpReceiver;
  final HandLogParser logParser = HandLogParser();
  List<HandLogMessage> messageQueue = [];
  late TextStyle Function(HandLogLevel) getStyle;

  HandLogTerminalController(this.udpReceiver);

  void translateMessages() {
    List<TextSpan> newSpans = [];
    for (var message in messageQueue) {
      newSpans.add(
          TextSpan(text: message.toString(), style: getStyle(message.level)));
    }
    messageQueue.clear();
    terminalData.textSpanList.addAll(newSpans);
    notifyListeners();
  }

  void startUdpReceiver() {
    udpReceiver.startListening();
    udpReceiver.onData.listen((data) {
      HandLogMessage message = logParser.parseLog(data);
      messageQueue.add(message);
      translateMessages();
      logger.d("Logger is working!");
      notifyListeners();
    });
  }

  void stopUdpReceiver() {
    udpReceiver.stopListening();
  }

  List<HandLogMessage> getMessages() {
    return messageQueue;
  }

  void clearMessages() {
    messageQueue.clear();
  }

  void setGetStyleFunction(TextStyle Function(HandLogLevel) styleFunction) {
    getStyle = styleFunction;
  }
}

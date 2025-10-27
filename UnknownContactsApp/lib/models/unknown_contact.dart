import 'package:call_log/call_log.dart';

class UnknownContact {
  final String number;
  final int? lastCallDate;
  final CallType? callType;
  final int? duration;

  UnknownContact({
    required this.number,
    this.lastCallDate,
    this.callType,
    this.duration,
  });
}

import 'package:flutter/foundation.dart';

class ChatRoomInfo {
  const ChatRoomInfo({
    @required this.roomId,
    @required this.imageURL,
    @required this.targetUserId,
    @required this.posterName
  })  : assert(roomId != null),
        assert(imageURL != null),
        assert(posterName != null),
        assert(targetUserId != null);

  final String roomId;
  final String imageURL;
  final String targetUserId;
  final String posterName;

}
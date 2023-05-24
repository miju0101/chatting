class TextMessage {
  String uid; //보낸 놈
  DateTime sendDate; //보낸 날짜
  MessageType type =
      MessageType.Text; //메세지 타입. 나중에 데이터를 가져올 떄 텍스트인지 포토인지 구분하기 위해서
  String text; //메시지
  List<String>
      members; // 읽은 사람의 모음. 나중에 1:N채팅을 구현할 때. 내가 이 채팅을 읽었는지 지표가 됨. 리스트에 없으면 안 읽었다는 뜻 이니까
  int totalUnReadCount; //읽지 않은 수
  String chatId;

  TextMessage({
    required this.uid,
    required this.sendDate,
    required this.text,
    required this.members,
    required this.totalUnReadCount,
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "sendDate": sendDate,
      "type": type,
      "text": text,
      "members": members,
      "totalUnReadCount": totalUnReadCount,
    };
  }
}

enum MessageType { Text, Photo }

class Message {
  Message({
    required this.toId,
    required this.read,
    required this.message,
    required this.type,
    required this.sent,
    required this.fromId,
  });
  late final String toId;
  late final String read;
  late final String message;
  late final Type type;
  late final String sent;
  late final String fromId;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    read = json['read'].toString();
    message = json['message'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['read'] = read;
    data['message'] = message;
    data['type'] = type;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type { text, image }
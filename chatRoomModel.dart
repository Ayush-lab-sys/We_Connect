class ChatRoomModel {
String? chatroomid;
Map<String, dynamic>? participants;
String? lastMessage;
String? msgtype;
ChatRoomModel(
{this.chatroomid, this.participants, this.lastMessage, this.msgtype});
ChatRoomModel.fromMap(Map<String, dynamic> map) {
chatroomid = map["chatroomid"];
participants = map["participants"];
lastMessage = map["lastmessage"];
msgtype = map["msgtype"];
}
Map<String, dynamic> toMap() {
return {
"chatroomid": chatroomid,
"participants": participants,
"lastmessage": lastMessage,
"msgtype": msgtype
};
}}

// To parse this JSON data, do
//
//     final client = clientFromMap(jsonString);

import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

Client clientFromMap(String str) => Client.fromMap(json.decode(str));

String clientToMap(Client data) => json.encode(data.toMap());

class Client {
  Client({
    this.id,
    this.firstName,
    this.lastName,
    this.blocked,
  });

  int id;
  String firstName;
  String lastName;
  bool blocked;

  factory Client.fromMap(Map<String, dynamic> json) => Client(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    blocked: json["blocked"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "blocked": blocked,
  };
}


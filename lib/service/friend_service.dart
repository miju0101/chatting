import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendService with ChangeNotifier {
  //users/{uid}/friends/
  Future<QuerySnapshot> getMyFriends(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .get();
  }

  Future<QuerySnapshot> searchPerson(String search) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: search)
        .get();
  }

  void addFriend(DocumentSnapshot me, DocumentSnapshot person) async {
    //만약 나 거나 이미 친구로 등록된 경우 return
    //내 유저정보의 friends에 추가할 친구의 uid, name, email, profile_img,
    //친구도 내 정보를 삽입

    var myInfo = me.data() as Map<String, dynamic>;
    var personInfo = person.data() as Map<String, dynamic>;

    if (person["uid"] == myInfo["uid"]) {
      print("자신을 친구로 둘 수 없습니다.");
      return;
    }

    QuerySnapshot snapshot = await getMyFriends(myInfo["uid"]);

    //이 새끼가 내 친구냐?
    if (snapshot.docs.length > 0) {
      var myFriends = snapshot.docs;

      for (int i = 0; i < myFriends.length; i++) {
        if (myFriends[i]["uid"] == person["uid"]) {
          print("이미 친구로 등록되어 있습니다.");
          return;
        }
      }
    }

    //아니면 추가

    //나
    await FirebaseFirestore.instance
        .collection("users")
        .doc(myInfo["uid"])
        .collection("friends")
        .add(
      {
        "email": personInfo["email"],
        "name": personInfo["name"],
        "profile_img": personInfo["profile_img"],
        "uid": personInfo["uid"]
      },
    );

    //너
    await FirebaseFirestore.instance
        .collection("users")
        .doc(personInfo["uid"])
        .collection("friends")
        .add(
      {
        "email": myInfo["email"],
        "name": myInfo["name"],
        "profile_img": myInfo["profile_img"],
        "uid": myInfo["uid"]
      },
    );
  }
}

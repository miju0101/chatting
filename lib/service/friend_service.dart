import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendService with ChangeNotifier {
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

  void addFriend(QueryDocumentSnapshot me, QueryDocumentSnapshot person) async {
    //만약 나 거나 이미 친구로 등록된 경우 return
    //내 유저정보의 friends에 추가할 친구의 uid, name, email, profile_img,
    //친구도 내 정보를 삽입

    if (person["uid"] == me["uid"]) {
      print("자신을 친구로 둘 수 없습니다.");
      return;
    }

    QuerySnapshot snapshot = await getMyFriends(me["uid"]);

    //이 새끼가 내 친구냐?
    if (snapshot.docs.length > 0) {
      var myFriends = snapshot.docs;

      for (int i = 0; i < myFriends.length; i++) {
        if (myFriends[i]["uid"] == person["uid"]) {
          return;
        }
      }
    }

    //아니면 추가

    //나
    await FirebaseFirestore.instance
        .collection("users")
        .doc(me["uid"])
        .collection("friends")
        .add(
      {
        "email": person["email"],
        "name": person["name"],
        "profile_img": person["profile_img"],
        "uid": person["uid"]
      },
    );

    //너
    await FirebaseFirestore.instance
        .collection("users")
        .doc(person["uid"])
        .collection("friends")
        .add(
      {
        "email": me["email"],
        "name": me["name"],
        "profile_img": me["profile_img"],
        "uid": me["uid"]
      },
    );
  }
}

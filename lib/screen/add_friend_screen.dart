import 'package:chatting/service/friend_service.dart';
import 'package:chatting/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  QuerySnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("친구 추가"),
      ),
      body: Column(
        children: [
          TextField(
            controller: search,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () async {
                  if (search.text.isNotEmpty) {
                    snapshot = await context
                        .read<FriendService>()
                        .searchPerson(search.text);

                    setState(() {});
                  }
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          snapshot != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: snapshot!.docs.length,
                    itemBuilder: (context, index) {
                      var search_person =
                          snapshot!.docs[index] as DocumentSnapshot;
                      return InkWell(
                        onTap: () async {
                          User? me =
                              context.read<UserService>().user(); //나의 uid를 가져옴

                          DocumentSnapshot me_snapshot = await context
                              .read<UserService>()
                              .getMyInfo(me!.uid);

                          //위에서 받아온 uid로 나의 정보를 가져옴.
                          //나의 정보는 친구를 추가할 때  정보로 쓰임.

                          context
                              .read<FriendService>()
                              .addFriend(me_snapshot, search_person);
                        },
                        child: ListTile(
                          leading: Image.network(search_person["profile_img"]),
                          title: Text(search_person["name"]),
                          subtitle: Text(search_person["email"]),
                        ),
                      );
                    },
                  ),
                )
              : const Text("이메일을 입력해주세요")
        ],
      ),
    );
  }
}

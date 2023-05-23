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
                      var current_user = snapshot!.docs[index];
                      return InkWell(
                        onTap: () async {
                          User? me = context.read<UserService>().user();

                          if (me != null) {
                            QuerySnapshot me_snapshot = await context
                                .read<UserService>()
                                .getMyInfo(me.uid);

                            context.read<FriendService>().addFriend(
                                me_snapshot.docs.first, current_user);
                          }
                        },
                        child: ListTile(
                          leading: Image.network(current_user["profile_img"]),
                          title: Text(current_user["name"]),
                          subtitle: Text(current_user["email"]),
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

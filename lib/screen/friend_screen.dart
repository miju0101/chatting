import 'package:chatting/screen/add_friend_screen.dart';
import 'package:chatting/screen/chat_room_screen.dart';
import 'package:chatting/service/friend_service.dart';
import 'package:chatting/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("친구"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: context
                .read<UserService>()
                .getMyInfo(context.read<UserService>().user()!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var myInfo = snapshot.data!.data() as Map<String, dynamic>;

                return ListTile(
                  leading: Image.network(myInfo!["profile_img"] as String),
                  title: Text(myInfo["name"]),
                  subtitle: Text(myInfo["email"]),
                );
              } else {
                return const Center(child: Text("데이터 가져오는 중..."));
              }
            },
          ),
          const SizedBox(height: 50),
          FutureBuilder(
            future: context
                .read<FriendService>()
                .getMyFriends(context.read<UserService>().user()!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var current_friend = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("1:1 채팅"),
                                  content: Text(
                                      "${current_friend["name"]}님과 대화를 하겠습니까?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatRoomScreen(
                                                    uid: current_friend["uid"]),
                                          ),
                                        );
                                      },
                                      child: const Text("네"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading:
                                Image.network(current_friend["profile_img"]),
                            title: Text(current_friend["name"]),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text("친구가 없습니다."),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text("데이터를 가져오는 중..."),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFriendScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

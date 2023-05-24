import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  String uid;

  ChatRoomScreen({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController text = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("채팅 방"),
        ),
        body: Center(child: Text("$uid")),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: TextField(
                controller: text,
                decoration: InputDecoration(
                  hintText: "텍스트를 입력하세요",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

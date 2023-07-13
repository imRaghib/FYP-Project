import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/Messenger Models/chat_user.dart';
import '../../Model/Messenger Models/chat_user_card.dart';
import '../../Model/Messenger Models/dialogs.dart';
import '../../ViewModel/Messenger Class/apis.dart';
import '../../main.dart';
import '../Vendor Pages/vendor_drawer.dart';

//home screen -- where all available contacts are shown
class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing search status

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('Messages'),
          centerTitle: true,
        ),

        //floating button to add new user

        //body
        body: StreamBuilder(
          stream: APIs.getMyUsersId(),

          //get id of only known users
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show it
              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                  stream: APIs.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                  //get only those user, who's ids are provided
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return const Center(
                      //     child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(user: _list[index] );
                              });
                        } else {
                          return const Center(
                            child: Text('No Messages',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                );
            }
          },
        ),
      ),
    );
  }

  // for adding new chat user


}

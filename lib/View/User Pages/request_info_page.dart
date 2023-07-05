import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VenueRequestPage extends StatefulWidget {
  const VenueRequestPage({Key? key}) : super(key: key);

  @override
  State<VenueRequestPage> createState() => _VenueRequestPageState();
}

class _VenueRequestPageState extends State<VenueRequestPage> {
  final Stream<QuerySnapshot> _pendingStream = FirebaseFirestore.instance
      .collection('Venue Requests')
      .where('requestStatus', isEqualTo: 'pending')
      .where('customerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> _acceptedStream = FirebaseFirestore.instance
      .collection('Venue Requests')
      .where('requestStatus', isEqualTo: 'accepted')
      .where('customerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> _rejectedStream = FirebaseFirestore.instance
      .collection('Venue Requests')
      .where('requestStatus', isEqualTo: 'rejected')
      .where('customerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  String? requestStatus;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Venue Status'),
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Accepted",
                ),
                Tab(
                  text: "Rejected",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RequestStatus(
                      usersStream: _pendingStream, requestStatus: 'pending'),
                  RequestStatus(
                      usersStream: _acceptedStream, requestStatus: 'accepted'),
                  RequestStatus(
                      usersStream: _rejectedStream, requestStatus: 'rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestStatus extends StatelessWidget {
  const RequestStatus({
    super.key,
    required Stream<QuerySnapshot<Object?>> usersStream,
    required this.requestStatus,
  }) : _usersStream = usersStream;

  final Stream<QuerySnapshot<Object?>> _usersStream;
  final String? requestStatus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data?.docs[index];
            return ListTile(
              onTap: () {},
              leading: CircleAvatar(
                child: Text(
                  '',
                ),
              ),
              title: Text(data!['customerName']),
              subtitle: Text('nue on'),
              trailing: Icon(Icons.favorite_rounded),
            );
          },
        );
      },
    );
  }
}

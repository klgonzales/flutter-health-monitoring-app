import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../models/log_model.dart';
import '../../models/user_model.dart';
import '../../providers/log_provider.dart';

class AllStudentsLogs extends StatefulWidget {
  const AllStudentsLogs({Key? key}) : super(key: key);

  @override
  AllStudentsPageState createState() => AllStudentsPageState();
}

class AllStudentsPageState extends State<AllStudentsLogs> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<Log> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  UserModel? getStudentUID(String uid) {
    UserModel? matchingUser = users.firstWhere((user) => user.uid == uid,
        orElse: () => UserModel(id: '', name: 'Unknown'));

    return matchingUser;
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;

    Stream<QuerySnapshot> allUsers =
        context.watch<LogsProvider>().allUserStream;

    allUserStream.listen((QuerySnapshot snapshot) {
      List<UserModel> updatedUsers = [];

      // Iterate over the documents in the snapshot and convert them to UserModels
      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        updatedUsers.add(user);
      }

      // Update the users list and filteredUsers list
      setState(() {
        users = updatedUsers;
        // filteredUsers = updatedUsers;
      });
    });

    allUsers.listen((QuerySnapshot snapshot) {
      List<UserModel> updatedUsers = [];

      // Iterate over the documents in the snapshot and convert them to UserModels
      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        updatedUsers.add(user);
      }

      // Update the users list and filteredUsers list
      setState(() {
        users = updatedUsers;
        // filteredUsers = updatedUsers;
      });
    });

    StreamBuilder allLogsListBuilder = StreamBuilder(
      stream: allUsers,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No Entries Found"),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data?.docs.length,
          itemBuilder: ((context, index) {
            Log user = Log.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);

            user.uid = snapshot.data?.docs[index].id;

            // int milliseconds = int.parse(user.date!);
            // DateTime currentDate =
            //     DateTime.fromMillisecondsSinceEpoch(milliseconds);

            // Parse the date string
            DateTime date = DateTime.parse(user.date!);

            // Format the day of the week (e.g., Monday, Tuesday)
            String dayOfWeek = DateFormat('EEEE').format(date);
            String month = DateFormat('MMMM').format(date);

            String day = DateFormat('dd').format(date);
            UserModel? Name = getStudentUID(user.uid!);

            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: ListTile(
                onTap: () {},
                trailing: IconButton(
                    icon: const Icon(
                        IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                    tooltip: 'Delete Log',
                    onPressed: () {
                      context.read<LogsProvider>().deleteEntry(user.uid!);
                    }),
                hoverColor: Color.fromARGB(255, 98, 122, 188),
                shape: null,
                title: Text(
                  dayOfWeek,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 87, 231, 65),
                      decorationColor: Color.fromARGB(255, 255, 191, 0),
                      wordSpacing: 10,
                      height: 5,
                      fontSize: 10),
                ),
                subtitle: Wrap(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 171, 197, 176),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(Name!.name ?? "Unknown")),
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromARGB(255, 138, 214, 148),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(month)),
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 171, 197, 176),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(day)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("All Student Logs"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              allLogsListBuilder,
            ],
          ),
        ));
  }
}
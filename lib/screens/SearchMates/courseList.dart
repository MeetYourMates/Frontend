import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/screens/Chat/chatDetail.dart';
import 'package:meet_your_mates/screens/Chat/chatDetail2.dart';
import 'package:provider/provider.dart';

class CourseList extends StatelessWidget {
  final CourseAndStudents queryResult;
  final String myId;
  const CourseList({this.queryResult, this.myId});

  Widget build(BuildContext context) {
    SocketProvider socketProvider = Provider.of<SocketProvider>(context, listen: false);
    void openChat(User user) {
      //Search if This user is already a mate
      int index = socketProvider.mates.usersList.indexOf(user);
      //If yes --> Open ChatDetail with Chathistory
      if (index != -1) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ChatDetailPage(
              selectedIndex: index,
            ),
          ),
        );
      } else {
        //Else --> New Mate maybe --> Temporary ChatDetail or ChatDetail2!
        socketProvider.tempMate = user;
        socketProvider.askTempMateStatus(user.id);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ChatDetailPage2(),
          ),
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                border: Border.all(
                  color: Colors.blue[300],
                ),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  queryResult.subjectName,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          itemCount: queryResult.students.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            Student student = queryResult.students[index];
            if (student.user.id == myId) {
              //If its me, then don't show it
              return Container();
            } else {
              return Card(
                child: ListTile(
                    leading: student.user.picture != null ? Image.network(student.user.picture) : Text("No Picture"),
                    title: Text(student.user.name != null ? student.user.name : "No name"),
                    subtitle: Text(student.degree != null ? queryResult.students[index].degree : "No Degree"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      /* REDIRECCIONAR A PERFIL SELECCIONADO */
                      openChat(student.user);
                    }),
              );
            }
          },
        ),
      ],
    );
  }
}

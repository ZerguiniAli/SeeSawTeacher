import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seesaw1/MainPages/studentAbsence.dart';
import 'package:seesaw1/utils/StudentCard.dart';

import '../DB/mysqlConnection.dart';

class SubClassPage extends StatefulWidget {
  final String ClassId;
  const SubClassPage({super.key, required this.ClassId});

  @override
  State<SubClassPage> createState() => _SubClassPageState();
}

class _SubClassPageState extends State<SubClassPage> {
  List<List<dynamic>> Data = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData
  }

  Future<void> fetchData() async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      var results = await mysql.connection.query(
          'SELECT * FROM eleve WHERE classe_id = ?',
          [widget.ClassId]);
      if (results.isNotEmpty) {
        setState(() {
          Data = results.map((row) {
            return [
              row['eleve_id'].toString(),
              row['Nom'].toString(),
              row['Prenom'].toString(),
              row['date_de_naissance'].toString(),
              row['lieu_de_naissance'].toString(),
            ];
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Navigator(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => Container(
                    child: ListView.separated(
                      itemCount: Data.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10), // Add space between items
                      itemBuilder: (context, index) {
                        // Return the widget representing each item
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/substudents', arguments: {
                              'id': Data[index][0],
                              'fName': Data[index][1],
                              'lName': Data[index][2],
                              'birthDate': Data[index][3],
                              'birthPlace': Data[index][4],
                            });
                          },
                          child: StudentCard(
                            id: Data[index][0],
                            fName: Data[index][1],
                            lName: Data[index][2],
                            birthdate: Data[index][3],
                            birthplace: Data[index][4],
                          ),
                        );
                      },
                    ),
                  ),
                );
              case '/substudents':
                final arguments = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => StudentAbsens(
                    id: arguments['id'],
                    fName: arguments['fName'],
                    lName: arguments['lName'],
                    BirthDate: arguments['birthDate'],
                    BirthPlace: arguments['birthPlace'],
                  ),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Center(
                      child: Text('Page not found'),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
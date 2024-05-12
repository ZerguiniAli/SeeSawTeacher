import 'package:flutter/material.dart';
import 'package:seesaw1/utils/ClassCard.dart';
import '../DB/mysqlConnection.dart';
import 'SubClassPage.dart';

class Class extends StatefulWidget {
  final String id;
  const Class({Key? key, required this.id}) : super(key: key);

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  String? Id;
  List<List<dynamic>> Data = [];

  @override
  void initState() {
    super.initState();
    Id = widget.id;
    fetchData(); // Call fetchData
  }

  Future<void> fetchData() async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      var results = await mysql.connection.query(
          'SELECT classe.* FROM classe JOIN classe_enseignant ON classe.classe_id = classe_enseignant.classe_id WHERE classe_enseignant.enseignant_id = ? ORDER BY classe.annees ASC',
          [Id]);
      if (results.isNotEmpty) {
        setState(() {
          Data = results.map((row) {
            return [
              row['classe_id'].toString(),
              row['annees'].toString(),
              row['specialite'].toString(),
              row['numero'].toString(),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              top: screenHeight * 0.02,
              bottom: screenHeight * 0.01),
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
                              Navigator.of(context).pushNamed('/subclass',
                                  arguments: Data[index][0]);
                            },
                            child: ClassCard(
                              id: Data[index][0],
                              annee: Data[index][1],
                              specialite: Data[index][2],
                              numero: Data[index][3],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                case '/subclass':
                  final classId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) => SubClassPage(ClassId: classId),
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
      ),
    );
  }
}
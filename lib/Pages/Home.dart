import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seesaw1/MainPages/Class.dart';
import 'package:seesaw1/MainPages/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DB/mysqlConnection.dart';
import '../MainPages/HomePage.dart';

class Home extends StatefulWidget {
  final String Id;
  const Home({Key? key, required this.Id}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<List<dynamic>> Data = [], Absence =[];
  final PageController _pageController = PageController();
  late String id, etablishment_name = "", NumberOfClasses = "", NumberOfStudents = "";

  @override
  void initState() {
    super.initState();
    id = widget.Id;
    fetchData(); // Call fetchData
  }

  Future<void> fetchData() async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id_user', id);

      var results = await mysql.connection.query('SELECT * FROM enseignant WHERE enseignant_id = ?', [id]);
      if (results.isNotEmpty) {
        setState(() {
          Data = results.map((row) {
            return [
              row['enseignant_id'].toString(),
              row['Nom'].toString(),
              row['Prenom'].toString(),
              row['date_de_naissance'].toString(),
              row['lieu_de_naissance'].toString(),
              row['Num_de_telephone'].toString(),
              row['email'].toString(),
              row['address'].toString(),
              row['Module'].toString(),
              row['etablissement_id'].toString(),
            ];
          }).toList();
        });
      }
      String data_id = Data[0][9];
      print(data_id);
      var result = await mysql.connection.query('SELECT * FROM etablissement WHERE etablissement_id = ?', [data_id]);
      if (result.isNotEmpty) {
        setState(() {
          etablishment_name = result.first['nom'].toString();
          print(etablishment_name);
        });
      };
      var resultNumberOfClasses = await mysql.connection.query('SELECT `enseignant_id`, COUNT(`classe_id`) AS classes_taught FROM classe_enseignant WHERE `enseignant_id` = ? GROUP BY enseignant_id', [Data[0][0]]);
      if (resultNumberOfClasses.isNotEmpty) {
        setState(() {
          NumberOfClasses = resultNumberOfClasses.first['classes_taught'].toString();
        });
      };
      var resultNumberOfStudents = await mysql.connection.query('SELECT COUNT(*) AS total_students_taught FROM eleve e JOIN classe c ON e.classe_id = c.classe_id JOIN classe_enseignant ce ON c.classe_id = ce.classe_id WHERE ce.enseignant_id = ?', [Data[0][0]]);
      if (resultNumberOfStudents.isNotEmpty) {
        setState(() {
          NumberOfStudents = resultNumberOfStudents.first['total_students_taught'].toString();
        });
      }
      var resultAbsents = await mysql.connection.query('SELECT "Total" as Nom, NULL as Prenom, COUNT(*) as total_absences, SUM(CASE WHEN a.justified = 1 THEN 1 ELSE 0 END) as justified_absences, SUM(CASE WHEN a.justified = 0 THEN 1 ELSE 0 END) as non_justified_absences FROM absense a JOIN eleve e ON a.eleve_id = e.eleve_id JOIN classe_enseignant ce ON e.classe_id = ce.classe_id JOIN classe c ON e.classe_id = c.classe_id WHERE ce.enseignant_id = ?', [Data[0][0]]);
      if (resultAbsents.isNotEmpty) {
        setState(() {
          Absence = resultAbsents.map((row) {
            return [
              row['total_absences'].toString(),
              row['justified_absences'].toString(),
              row['non_justified_absences'].toString(),
            ];
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // If Data is empty, show a loading indicator or a placeholder widget
    if (Data.isEmpty || NumberOfClasses.isEmpty || NumberOfStudents.isEmpty || Absence.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ), // Or any loading indicator widget
        ),
      );
    }

    // If Data is not empty, continue building the UI
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePage(Nom: Data[0][1], Prenom: Data[0][2], Email: Data[0][6],Module: Data[0][8] ,id: Data[0][0],NumberOfClasses: NumberOfClasses,NumberOfStudents: NumberOfStudents, TOtalAbsents: Absence[0][0], TotalJustified: Absence[0][1], TotalNonJustified: Absence[0][2],),
          Class(id: id,),
          ProfilePage(Nom: Data[0][1], Prenom: Data[0][2], date_de_naissance: Data[0][3], Lieu_de_naissance: Data[0][4], NumTelephone: Data[0][5], email: Data[0][6], address: Data[0][7], etablissement_id: etablishment_name),
        ],
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.06,
        margin: EdgeInsets.only(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight*0.01, horizontal: screenWidth*0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      _pageController.jumpToPage(0);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: screenHeight*0.006, horizontal: screenWidth*0.08),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0 ? Colors.white : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "lib/icons/homepage.png",
                      color: _selectedIndex == 0 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _pageController.jumpToPage(1);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: screenHeight*0.006, horizontal: screenWidth*0.08),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1 ? Colors.white : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "lib/icons/class.png",
                      color: _selectedIndex == 1 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                      _pageController.jumpToPage(2);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: screenHeight*0.006, horizontal: screenWidth*0.08),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 2 ? Colors.white : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "lib/icons/avatar.png",
                      color: _selectedIndex == 2 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

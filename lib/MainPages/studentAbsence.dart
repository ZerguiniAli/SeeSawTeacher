import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seesaw1/utils/StudentCard.dart';
import 'package:seesaw1/utils/absentCard.dart';
import '../DB/mysqlConnection.dart';

class StudentAbsens extends StatefulWidget {
  final String id;
  final String fName;
  final String lName;
  final String BirthDate;
  final String BirthPlace;
  const StudentAbsens({super.key, required this.id, required this.fName, required this.lName, required this.BirthDate, required this.BirthPlace});

  @override
  State<StudentAbsens> createState() => _StudentAbsensState();
}

class _StudentAbsensState extends State<StudentAbsens> {

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
          'SELECT * FROM absense WHERE eleve_id = ?',
          [widget.id]);
      if (results.isNotEmpty) {
        setState(() {
          Data = results.map((row) {
            return [
              row['absense_id'].toString(),
              row['date_absense'].toString(),
              row['temp_absense'].toString(),
              row['justified'].toString(),
            ];
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> PushData(String Date, String Session, String id) async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      var results = await mysql.connection.query(
          'INSERT INTO `absense` (`absense_id`, `date_absense`, `temp_absense`, `eleve_id`, `justified`) VALUES (NULL, ? , ?, ? , ? );',
          [Date, Session, id, "0"]);
      if (results.isNotEmpty) {
        setState(() {
          Data = results.map((row) {
            return [
              row['absense_id'].toString(),
              row['date_absense'].toString(),
              row['temp_absense'].toString(),
              row['justified'].toString(),
            ];
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> DeleteAbsence(String Absence_id) async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      var results = await mysql.connection.query(
          'DELETE FROM absense WHERE `absense`.`absense_id` = ?',
          [Absence_id]);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> justifyAbsence(String absenceId) async {
    try {
      var mysql = Mysql();
      await mysql.connect();

      await mysql.connection.query(
          'UPDATE absense SET justified = 1 WHERE absense_id = ?',
          [absenceId]);

      // Refresh the data after justification
      await fetchData();
    } catch (e) {
      print('Error justifying absence: $e');
    }
  }


  void _showAbsenceOptionsDialog(String absenceId, String dateAbsence, String session, String justified) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Absence Options'),
          content: Text('What would you like to do with this absence?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Handle the "Delete" action
                await DeleteAbsence(absenceId);
                await fetchData();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the "Justify" action
                await justifyAbsence(absenceId);
                await fetchData();
                Navigator.of(context).pop();
              },
              child: Text('Justify'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAbsenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newAbsenceId = '';
        DateTime? selectedDate; // Initialize with null
        final TextEditingController _dateController = TextEditingController();
        String? selectedSession; // Initialize with null
        String newJustified = '';

        return AlertDialog(
          title: Text('Add Absence'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedSession,
                decoration: InputDecoration(
                  labelText: 'Session',
                ),
                items: List.generate(8, (index) => index + 1)
                    .map((session) => DropdownMenuItem(
                  value: session.toString(),
                  child: Text('Session $session'),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSession = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final selectedDateString = selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : '';
                final selectedSessionString = selectedSession ?? '';

                // Push the data to the database
                await PushData(selectedDateString, selectedSessionString, widget.id);

                // Refresh the page by calling fetchData()
                await fetchData();

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: screenHeight * 0.04,),
        child: Container(
          child: Column(
            children: [
              StudentCard(id: widget.id, fName: widget.fName, lName: widget.lName, birthdate: widget.BirthDate, birthplace: widget.BirthPlace),
              Container(
                width: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  onPressed: (){
                    _showAddAbsenceDialog();
                  },
                  color: Colors.green,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text("Add Absence", style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight*0.02,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: Data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _showAbsenceOptionsDialog(
                              Data[index][0], // absenceId
                              Data[index][1], // dateAbsence
                              Data[index][2], // session
                              Data[index][3], // justified
                            );
                          },
                          child: AbsentCard(
                            id: Data[index][0],
                            date_absence: Data[index][1],
                            session: Data[index][2],
                            justified: Data[index][3],
                          ),
                        );
                      },
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
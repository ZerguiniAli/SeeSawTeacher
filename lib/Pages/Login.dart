import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DB/mysqlConnection.dart';
import 'Home.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String id;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    var db = Mysql(); // Initialize MySQL connection
    await db.connect(); // Connect to the database

    // Fetch username and password from text fields
    String username = usernameController.text;
    String password = passwordController.text;

    // Perform database query to check username and password
    var result = await db.connection.query(
      'SELECT * FROM enseignant WHERE Prenom = ? AND mot_de_passe = ?',
      [username, password],
    );

    // If the query result is not empty, login is successful
    if (result.isNotEmpty) {
      setState(() {
        id = result.first['enseignant_id'].toString();
      });

      // Update shared preferences values
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('start_value', 3);
      await prefs.setString('id_user', id);

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(Id: id)),
      );

      Fluttertoast.showToast(
        msg: "Connected",
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Not Connected",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.white,
          child: Center(
            child: Container(
              height: screenHeight * 0.6,
              width: screenWidth * 0.85,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Let's Sign you in",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.04,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: screenHeight * 0.028,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: screenHeight * 0.07,
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: screenHeight * 0.07,
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    child: MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      onPressed: () {
                        login(context);
                      },
                      color: Colors.black,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  final String Nom;
  final String Prenom;
  final String Email;
  final String Module;
  final String id;
  final String NumberOfClasses;
  final String NumberOfStudents;
  final String TOtalAbsents;
  final String TotalNonJustified;
  final String TotalJustified;
  const HomePage({super.key, required this.Nom, required this.Prenom, required this.Email, required this.id, required this.Module, required this.NumberOfClasses, required this.NumberOfStudents, required this.TOtalAbsents, required this.TotalJustified, required this.TotalNonJustified});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double? Justified;
  double? nonJustified;
  String JUSTIFIED ="", NONJUSTIFIED="";

  @override
  void initState() {
    super.initState();
    double TotalAbsents1 = double.parse(widget.TOtalAbsents);
    double TotalJustified = double.parse(widget.TotalJustified);
    double TotalNonJustified =  double.parse(widget.TotalNonJustified);
    Justified = percentage(TotalAbsents1, TotalJustified);
    nonJustified = percentage(TotalAbsents1, TotalNonJustified);
    JUSTIFIED= ToInt(widget.TotalJustified);
    NONJUSTIFIED = ToInt(widget.TotalNonJustified);
  }

  double percentage (double Total, double Part){
    double result = Part / Total;
    return result;
  }

  String ToInt(String value){
    int Len = value.length;
    String result = "";
    for(int i=0; i< Len-2; i++ ){
      result = result + value[i];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: screenWidth*0.04, right: screenWidth*0.04, top: screenHeight*0.07, bottom: screenHeight*0.01),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.02, horizontal: screenWidth*0.05),
              height: screenHeight*0.2,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: screenWidth*0.003),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenHeight*0.015),
                        alignment: Alignment.center,
                        height: screenHeight*0.1,
                        width: screenHeight*0.1,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset("lib/icons/man.png"),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${widget.Nom} ${widget.Prenom}", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight*0.02,
                          ),),
                          Text("${widget.Module} Teacher", style: TextStyle(
                            fontSize: screenHeight*0.015,
                          ),),
                          Text("${widget.Email}", style: TextStyle(
                            fontSize: screenHeight*0.015,
                          ),),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("${widget.id}", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight*0.03,
                      ),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.022),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.022, horizontal: screenWidth*0.04),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: screenWidth*0.003),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight*0.08,
                              width: screenHeight*0.08,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[400]
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(screenHeight*0.015),
                                child: Image.asset("lib/icons/class.png", color: Colors.black,),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Number of classes", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: screenHeight*0.02
                                ),),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal: screenWidth*0.07),
                                  decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.green, width: screenWidth*0.003)
                                  ),
                                  child: Text(widget.NumberOfClasses, style: TextStyle(
                                    fontWeight: FontWeight.w500,

                                  ),),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.022, horizontal: screenWidth*0.04),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: screenWidth*0.003),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight*0.08,
                              width: screenHeight*0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[400]
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(screenHeight*0.015),
                                child: Image.asset("lib/icons/education.png", color: Colors.black,),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Number of students", style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: screenHeight*0.02
                                ),),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal: screenWidth*0.07),
                                  decoration: BoxDecoration(
                                    color: Colors.green[200],
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.green, width: screenWidth*0.003)
                                  ),
                                  child: Text(widget.NumberOfStudents, style: TextStyle(
                                    fontWeight: FontWeight.w500,

                                  ),),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.022, horizontal: screenWidth*0.04),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: screenWidth*0.003),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight*0.08,
                              width: screenHeight*0.08,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[400]
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(screenHeight*0.015),
                                child: Image.asset("lib/icons/absentism.png", color: Colors.black,),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Justified Absents", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: screenHeight*0.016
                                ),),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.005, horizontal: screenWidth*0.04),
                                  decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.green, width: screenWidth*0.003)
                                  ),
                                  child: Text(JUSTIFIED, style: TextStyle(
                                    fontWeight: FontWeight.w500,

                                  ),),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                                value: Justified,
                                strokeWidth: screenWidth*0.02,
                                backgroundColor: Colors.grey[350],
                                strokeAlign: screenWidth*0.005,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.022, horizontal: screenWidth*0.04),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: screenWidth*0.003),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight*0.08,
                              width: screenHeight*0.08,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[400]
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(screenHeight*0.015),
                                child: Image.asset("lib/icons/absence1.png", color: Colors.black,),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Non Justified Absents", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: screenHeight*0.016
                                ),),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.005, horizontal: screenWidth*0.04),
                                  decoration: BoxDecoration(
                                      color: Colors.red[200],
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.red, width: screenWidth*0.003)
                                  ),
                                  child: Text(NONJUSTIFIED, style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                value: nonJustified,
                                strokeWidth: screenWidth*0.02,
                                backgroundColor: Colors.grey[350],
                                strokeAlign: screenWidth*0.005,

                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String id;
  final String annee;
  final String specialite;
  final String numero;
  const ClassCard({super.key, required this.id, required this.annee, required this.numero, required this.specialite});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight*0.03),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: screenWidth*0.003),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(screenHeight*0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[350],
            ),
            child: Text(annee, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight*0.02
            ),),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Year :$annee", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight*0.015
                ),),
                Text("Classe Number:$numero", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight*0.015
                ),)
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Specialty :", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight*0.015
                ),),
                Text("$specialite", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight*0.015
                ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}

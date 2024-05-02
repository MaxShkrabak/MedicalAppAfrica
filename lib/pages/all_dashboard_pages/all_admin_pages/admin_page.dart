// Admin page, where you can generate and delete access codes in the database
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';


class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
 


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Color.fromARGB(161, 88, 82, 173),
      ),
      body: Scaffold(
        backgroundColor: Color.fromRGBO(76, 90, 137, 1),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Center( 
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 7),
                // Generate Access Code button
                Tiles(
                  onTap: () {
                  },
                  width: 250,
                  height: 120,
                  mainText: 'Generate Access Code',
                  subText: '',
                ),
                SizedBox(height: 15),
                // Delete Access Code button
                Tiles(
                  onTap: () {

                  },
                  width: 250,
                  height: 60,
                  mainText: 'Delete Access Code',
                  subText: '',
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}


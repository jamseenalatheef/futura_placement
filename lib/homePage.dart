import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:futura_placement/employeeModel.dart';
import 'package:http/http.dart' as http;

class EmployeesHomePage extends StatefulWidget {
  @override
  State<EmployeesHomePage> createState() => _EmployeesHomePageState();
}

class _EmployeesHomePageState extends State<EmployeesHomePage> {
  Future<EmployeeModel> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));

    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load employees');
    }
  }

  late Future<EmployeeModel> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade500,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Employees List",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<EmployeeModel>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log("length = " + snapshot.data!.data.length.toString());
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    // elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Text(
                          snapshot.data!.data[index].id.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          snapshot.data!.data[index].employeeName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Age : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900),
                                ),
                                Text(
                                  snapshot.data!.data[index].employeeAge
                                      .toString(),
                                  style:
                                      TextStyle(color: Colors.green.shade900),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Salary : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade900),
                                ),
                                Text(
                                  snapshot.data!.data[index].employeeSalary
                                          .toString() +
                                      " /-",
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

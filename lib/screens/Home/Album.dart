import 'dart:async';
import 'dart:convert';

import 'package:assignment_fluter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=45.4235&longitude=-75.6979&daily=temperature_2m_max&current_weather=true&timezone=America%2FLos_Angeles'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Album {
  final double temperature;
  final double windspeed;
  final String city;

  const Album({
    required this.temperature,
    required this.windspeed,
    required this.city,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      temperature: json['current_weather']['temperature'],
      windspeed: json['current_weather']['windspeed'],
      city: "ottawa",
    );
  }
}

class Album_1 extends StatefulWidget {
  const Album_1({Key? key}) : super(key: key);

  @override
  State<Album_1> createState() => _Album_1State();
}

class _Album_1State extends State<Album_1> {
  // late Future<Album> futureAlbum;

  bool _loading = false;
  double temperature = 0.0;
  double windspeed = 0.0;
  String city = "Ottawa";

  @override
  void initState() {
    super.initState();
    loadlist();
  }

  final AuthService _auth = AuthService();
  void loadlist() async {
    var res = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=45.4235&longitude=-75.6979&daily=temperature_2m_max&current_weather=true&timezone=America%2FLos_Angeles'));
    if (res.statusCode == 200) {
      var jsondata = jsonDecode(res.body);
      // print(jsondata);
      setState(() {
        temperature = jsondata['current_weather']['temperature'];
        windspeed = jsondata['current_weather']['windspeed'];
        _loading = true;
      });
      print(jsondata['current_weather']['temperature']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[500],
        elevation: 0.0,
        title: Text("Weather Ottawa"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
              icon: Icon(Icons.person),
              label: Text("Log Out")),
        ],
      ),
      body: Center(
        child: !_loading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Temperature : " + temperature.toString() + " C",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "City : " + city,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Wind Speed : " + windspeed.toString() + "km/h",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
      ),
    );
  }
}

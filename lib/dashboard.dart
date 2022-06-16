// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/notificationservice.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String humidity = '', temperature = '', btemperature='', hrate='', spo2='';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    firebaseData();
  }
  Future<void> firebaseData() async {
    final firstSensor = FirebaseDatabase.instance
        .ref("DHT22 Testing Data");
    final secondSensor = FirebaseDatabase.instance
        .ref("DS18B20 Testing Data");
    final thirdSensor = FirebaseDatabase.instance
        .ref("MAX30100 Testing Data");
     firstSensor.once().then((event) {
      var data = event.snapshot.children.map((e) {
        var data = e.value as Map<dynamic, dynamic>;
        // print("data ${data}");
        return data;
      }).toList();
      setState(() {
        humidity = data[0]["Humidity"].toString();
        temperature = data[0]["temperature"].toString();
        if (data[0]["Humidity"] > 70 &&  data[0]["temperature"] >=25){
          Notification("Bedwetting Mechanism Occure.");
        }
      });
    });
    secondSensor.once().then((event) {
      var data = event.snapshot.children.map((e) {
        var data = e.value as Map<dynamic, dynamic>;
        return data;
      }).toList();
      setState(() {
        btemperature = data[0]["Body Temperature"].toString();
        if (data[0]["Body Temperature"] > 38 ){
          Notification("Above Normal Temperature.");
        }
      });
    });
    thirdSensor.once().then((event) {
      var data = event.snapshot.children.map((e) {
        var data = e.value as Map<dynamic, dynamic>;
        return data;
      }).toList();
      setState(() {
        hrate = data[0]["Heart Rate"].toString();
        spo2 = data[0]["SPO2"].toString();
        if (data[0]["SPO2"] < 88 &&  data[0]["Heart Rate"] > 130 || data[0]["Heart Rate"] < 80){
          Notification("SPO2 or Heart Rate is not normal.");
        }
      });
    });
  }

  Future<void> Notification(alert){
    return NotificationService().showNotification(1, "Alert", alert, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        backgroundColor: Colors.cyan,
        title: const Center(child: Text('Basics  Vitals')),
        actions: [
          IconButton(
              onPressed: () {
                // FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=> firebaseData(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black, // background color
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors
                            .lightBlueAccent, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.device_thermostat, size: 50),
                          const Text("Body Temperature",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text(btemperature.isNotEmpty?"$btemperature °C":"0 °C",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.opacity, size: 50),
                          const Text("Humidity",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text(humidity.isNotEmpty?"$humidity °C":"0 °C",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // posion the everything to the bottom
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.device_thermostat, size: 50),
                          const Text("Saturation",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text(spo2.isNotEmpty?"$spo2 %":"0 %",
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color:
                            Colors.purpleAccent, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // posion the everything to the bottom
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.monitor_heart, size: 50),
                          const Text("Heart Rate",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text(hrate.isNotEmpty?"$hrate bpm":"0 bpm",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width / 2 - 32,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0.5,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.device_thermostat, size: 50),
                      const Text("Mattress Temperature",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text(temperature.isNotEmpty?"$temperature °C":"0 °C",
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width / 2 - 32,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0.5,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.monitor_weight, size: 50),
                      Text("Weight",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text("4.00 KG",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

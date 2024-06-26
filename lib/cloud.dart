import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CloudStoragePage(),
    );
  }
}

class CloudStoragePage extends StatefulWidget {
  @override
  _CloudStoragePageState createState() => _CloudStoragePageState();
}

class _CloudStoragePageState extends State<CloudStoragePage> {
  late WebSocketChannel channel;
  double temperature = 0.0;
  double humidity = 0.0;
  bool motionDetected = false;
  String soundStatus = "No Sound";

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(
          'ws://172.20.10.7:81', // Replace with your ESP8266 IP address
        ),
      );
      channel.stream.listen(
            (message) {
          print('Received message: $message');
          final data = jsonDecode(message);
          setState(() {
            temperature = data['temperature'];
            humidity = data['humidity'];
            motionDetected = data['motion'];
            soundStatus = data['sound'];
          });
        },
        onError: (error) {
          print('WebSocket Error: $error');
          reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket closed');
          reconnectWebSocket();
        },
      );
    } catch (e) {
      print('WebSocket Connection Error: $e');
      reconnectWebSocket();
    }
  }

  void reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      connectWebSocket();
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.png'), // Background image for the app bar
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Image.asset(
          'assets/logo.png',
          width: 145,
        ), // Using an image as the title
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // Notification icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            iconSize: 35, // Change the size of the notification icon
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(211, 233, 231, 1.0), // Background color
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(211, 233, 231, 1.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Circle Progress for temperature
                                _buildProgressIndicator(
                                  value: temperature / 100,
                                  color: Color.fromARGB(255, 139, 214, 231), // Ubah warna background suhu menjadi pink
                                  iconColor: Color.fromARGB(255, 40, 156, 173),
                                  icon: Icons.thermostat,
                                  label: '${temperature.toStringAsFixed(1)}°C',
                                  labelTitle: 'Temperature',
                                  borderColor: Color.fromARGB(
                                      255, 255, 255, 255), // Sesuaikan dengan warna background
                                ),
                                SizedBox(width: 20),
                                // Circle Progress for humidity
                                _buildProgressIndicator(
                                  value: humidity / 100,
                                  color: Color.fromARGB(255, 139, 214, 231), // Ubah warna background kelembapan menjadi ungu
                                  iconColor: Color.fromARGB(255, 40, 156, 173),
                                  icon: Icons.water_drop,
                                  label: '${humidity.toStringAsFixed(1)}%',
                                  labelTitle: 'Humidity',
                                  borderColor: Color.fromARGB(
                                      255, 255, 255, 255),  // Sesuaikan dengan warna background
                                ),
                              ],
                            ),
                            SizedBox(height: 70),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Sound detection icon
                                _buildIconContainer(
                                  icon: Icons.graphic_eq,
                                  color: soundStatus == "Sound Detected"
                                      ? Color.fromARGB(255, 40, 156, 173) // Ubah warna ikon suara menjadi ungu pastel
                                      : Color.fromARGB(255, 139, 214, 231),
                                  label: 'Voice',
                                  borderColor: soundStatus == "Sound Detected"
                                      ? Color.fromARGB(255, 40, 156, 173) // Sesuaikan dengan warna ikon suara
                                      : Color.fromARGB(
                                      255, 255, 255, 255),
                                ),
                                SizedBox(width: 20),
                                // Motion detection icon
                                _buildIconContainer(
                                  icon: Icons.directions_walk,
                                  color: motionDetected
                                      ? Color.fromARGB(255, 40, 156, 173) // Ubah warna ikon gerakan menjadi kuning muda jika terdeteksi
                                      :Color.fromARGB(255, 139, 214, 231),
                                  label: 'Movement',
                                  borderColor: motionDetected
                                      ? Color.fromARGB(255, 40, 156, 173)// Sesuaikan dengan warna ikon gerakan
                                      : Color.fromARGB(
                                      255, 255, 255, 255),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                  color: Color.fromARGB(134, 139, 214, 231),
                ),
                child: Center(
                  child: Text(
                    '© 2024 Cloud Baby. All rights reserved.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator({
    required double value,
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String label,
    required String labelTitle,
    required Color borderColor,
  }) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: color, // Background color for the progress indicator
            border: Border.all(color: borderColor, width: 3), // Border color
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200], // Background color for the circle progress
                ),
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 40, 156, 173),),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: iconColor,
                  ),
                  SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: 18), // Adjust font size for temperature and humidity text
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          labelTitle,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
    required String label,
    required Color borderColor,
  }) {
    return Column(
      children: [
        Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: color, // Background color for icon container
            border: Border.all(color: borderColor, width: 3), // Border color
          ),
          child: Icon(
            icon,
            size: 70,
            color: Colors.white, // Adjust icon color if needed
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text('No new notifications'),
      ),
    );
  }
}

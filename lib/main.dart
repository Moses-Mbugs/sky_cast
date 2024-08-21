import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyCast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _locationController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  String? _errorMessage;

  Future<void> _fetchWeatherData() async {
    final String apiKey = '9af64933f6829ccf2ee0269b7aad2bd8';
    final String location = _locationController.text;
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
        _errorMessage = null;
      });
    } else {
      setState(() {
        _weatherData = null;
        _errorMessage = 'Failed to fetch weather data for $location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkyCast'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/weather.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputSection(),
            SizedBox(height: 16.0),
            _weatherData != null ? _buildWeatherInfo() : _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchWeatherData,
              child: Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    final String location = _weatherData!['name'];
    final double temperature = _weatherData!['main']['temp'];
    final String description = _weatherData!['weather'][0]['description'];
    final int humidity = _weatherData!['main']['humidity'];
    final double windSpeed = _weatherData!['wind']['speed'];

    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Weather in $location',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.thermostat_outlined, color: Colors.orange),
                SizedBox(width: 8.0),
                Text(
                  'Temperature: $temperature°C',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: Colors.yellow),
                SizedBox(width: 8.0),
                Text(
                  'Description: ${description[0].toUpperCase()}${description.substring(1)}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.water_drop_outlined, color: Colors.blue),
                SizedBox(width: 8.0),
                Text(
                  'Humidity: $humidity%',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.air_outlined, color: Colors.green),
                SizedBox(width: 8.0),
                Text(
                  'Wind Speed: $windSpeed m/s',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage != null) {
      return Card(
        color: Colors.red.withOpacity(0.8),
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

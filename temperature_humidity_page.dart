import 'package:flutter/material.dart';

class TemperatureHumidityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.thermostat, size: 80, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            "Temperature: 25°C",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            "Humidity: 60%",
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

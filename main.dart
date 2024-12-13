import 'package:flutter/material.dart';
import 'relay_control_page.dart';
import 'temperature_humidity_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MẠNG KHÔNG DÂY",
          style: TextStyle(
            fontSize: 24, // Kích cỡ chữ
            fontWeight: FontWeight.bold, // Đậm chữ
            fontFamily: 'Roboto', // Phông chữ (thay thế nếu cần)
            letterSpacing: 2.0, // Giãn cách giữa các ký tự
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, // Đổi màu nền của AppBar
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white, // Màu của dòng chỉ báo
          labelColor: Colors.white, // Màu chữ khi tab được chọn
          unselectedLabelColor: Colors.black45, // Màu chữ khi tab không được chọn
          indicatorWeight: 4.0, // Độ dày của dòng chỉ báo
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.electrical_services), text: "Relay"),
            Tab(icon: Icon(Icons.thermostat), text: "Temp & Humidity"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          MainPage(),
          RelayControlPage(),
          TemperatureHumidityPage(),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/iot1.jpg'), // Đường dẫn ảnh
          fit: BoxFit.cover, // Đặt ảnh nền phủ toàn bộ màn hình
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Đặt nội dung xuống cuối
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0), // Khoảng cách so với mép dưới
            child: Text(
              "Chào mừng",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ trắng để nổi bật trên nền
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54, // Đổ bóng để chữ dễ đọc hơn
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

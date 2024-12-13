import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Thêm gói này vào pubspec.yaml
import 'server.dart';

class RelayControlPage extends StatefulWidget {
  @override
  _RelayControlPageState createState() => _RelayControlPageState();
}

class _RelayControlPageState extends State<RelayControlPage> {
  final ServerController serverController = ServerController();
  String relay1State = "off";
  String relay2State = "off";
  bool isLoading = false;

  // Hàm chuyển trạng thái relay
  void toggleRelay(String relay) {
    final currentState = relay == "relay1" ? relay1State : relay2State;
    final newState = currentState == "on" ? "off" : "on";

    setState(() => isLoading = true);

    serverController.updateRelay(context, relay, newState, (relay, state) {
      setState(() {
        if (relay == "relay1") relay1State = state;
        if (relay == "relay2") relay2State = state;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Relay Control'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hình ảnh header
                Image.asset(
                  'lib/assets/iot 2.jpg',
                  height: 200,
                ),
                SizedBox(height: 20),
                // Các nút relay
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRelayControl("PLUG1", relay1State, () => toggleRelay("relay1")),
                      _buildRelayControl("PLUG2", relay2State, () => toggleRelay("relay2")),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (isLoading) CircularProgressIndicator(),
                SizedBox(height: 20),
                // TextField để nhập địa chỉ server
                TextField(
                  onChanged: (value) => setState(() {
                    serverController.serverAddress = value;
                  }),
                  decoration: InputDecoration(
                    labelText: "Server Address",
                    border: OutlineInputBorder(),
                    hintText: "e.g., 192.168.70.91",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget tạo Relay Control
  Widget _buildRelayControl(String label, String state, VoidCallback onTap) {
    return Column(
      children: [
        RelayBox(
          state: state,
          onTap: onTap,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class RelayBox extends StatelessWidget {
  final String state;
  final VoidCallback onTap;

  RelayBox({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ảnh nền thay đổi dựa trên trạng thái
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  child: Image.asset(
                    state == "on" ? 'lib/assets/lo.webp' : 'lib/assets/lo.webp',
                    fit: BoxFit.cover,
                    color: state == "on" ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                    colorBlendMode: BlendMode.color,
                  ),
                ),
              ),
            ),
            // Text trạng thái hiển thị ở giữa ảnh
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  state == "on" ? "On" : "Off",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

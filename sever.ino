#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Thông tin WiFi
const char* ssid = "Galaxy";
const char* password = "25022004";

// Địa chỉ server
const String serverURLs[] = {
  "http://192.168.24.92:5000/relay1",
  "http://192.168.24.92:5000/relay2"
};

// GPIO relay
const int relayPins[] = {23, 22};   // Relay 1: GPIO23, Relay 2: GPIO22

void setup() {
  // Thiết lập các chân relay
  for (int i = 0; i < 2; i++) {
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], LOW); // Tắt relay mặc định
  }

  Serial.begin(9600);

  // Kết nối WiFi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");
  Serial.println(WiFi.localIP());
}

void controlRelay(const String& url, int relayPin) {
  HTTPClient http;
  http.begin(url);

  int httpResponseCode = http.GET();
  if (httpResponseCode > 0) {
    String payload = http.getString();
    StaticJsonDocument<200> doc;

    if (!deserializeJson(doc, payload)) {
      const char* state = doc["state"];
      if (strcmp(state, "on") == 0) {
        digitalWrite(relayPin, HIGH); // Bật relay
        Serial.printf("Relay on pin %d is ON\n", relayPin);
      } else if (strcmp(state, "off") == 0) {
        digitalWrite(relayPin, LOW); // Tắt relay
        Serial.printf("Relay on pin %d is OFF\n", relayPin);
      }
    } else {
      Serial.println("Failed to parse JSON payload");
    }
  } else {
    Serial.printf("Failed to GET from %s, HTTP response code: %d\n", url.c_str(), httpResponseCode);
  }

  http.end();
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    // Điều khiển các relay theo trạng thái từ server
    for (int i = 0; i < 2; i++) {
      controlRelay(serverURLs[i], relayPins[i]);
    }
  } else {
    Serial.println("WiFi not connected, retrying...");
    WiFi.reconnect();
  }

  delay(100); // Gửi yêu cầu mỗi 0,1 giây
}

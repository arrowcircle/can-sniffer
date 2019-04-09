#include "main.hpp"

bool can_initialized = false;

void print_can(can_message_t message) {
  Serial.printf("%lu, ", millis());
  Serial.print("0x");
  Serial.print(message.identifier, HEX);
  Serial.print(", ");

  for (int i = 0; i < message.data_length_code; i++) {
    Serial.print(message.data[i], HEX);
    Serial.print(" ");
  }

  Serial.println("");
}

void onReceive(int packetSize) {
  can_message_t message;

  message.data_length_code = packetSize;
  message.identifier = CAN.packetId();
  for (int i = 0; i < packetSize; i++) {
    message.data[i] = CAN.read();
  }

  print_can(message);
}

void setup() {
  Serial.begin(115200);
  Serial.println("timestamp, CAN ID, HEX, Comment");
  // CAN.setPins(GPIO_NUM_22, GPIO_NUM_21);
  if (CAN.begin(250E3)) {
  // if (CAN.begin(1000E3)) {  
    can_initialized = true;
  } else {
    can_initialized = false;
  }

  if (can_initialized == true) { CAN.onReceive(onReceive); }
}

void loop() {
}

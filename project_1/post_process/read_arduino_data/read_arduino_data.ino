#include <SPI.h>
#include <SD.h> 
#define FLAG_PIN 2
#define DATA_PIN_0 3
#define DATA_PIN_1 4
#define DATA_PIN_2 5
#define DATA_PIN_3 6
#define DATA_PIN_4 7
#define DATA_PIN_5 8
#define DATA_PIN_6 9
#define DATA_PIN_7 10
#define DATA_PIN_8 11
#define DATA_PIN_9 12
#define DATA_PIN_10 13

void setup() {
  // Configurar pines como entrada digital
  pinMode(DATA_PIN_0, INPUT);
  pinMode(DATA_PIN_1, INPUT);
  pinMode(DATA_PIN_2, INPUT);
  pinMode(DATA_PIN_3, INPUT);
  pinMode(DATA_PIN_4, INPUT);
  pinMode(DATA_PIN_5, INPUT);
  pinMode(DATA_PIN_6, INPUT);
  pinMode(DATA_PIN_7, INPUT);
  pinMode(DATA_PIN_8, INPUT);
  pinMode(DATA_PIN_9, INPUT);
  pinMode(DATA_PIN_10, INPUT);

  pinMode(FLAG_PIN, INPUT);
  
  Serial.begin(9600);
}

void loop() {
  int flag_last_state = LOW;
  while (true) {
    int flag_current_state = digitalRead(FLAG_PIN);
    if (flag_current_state == HIGH && flag_last_state == LOW) {
      String audio_string;
      for (int i = 0; i < 11; i++) {
        audio_string += String(digitalRead(i + 3));
      }
      Serial.println(audio_string);
    }
    flag_last_state = flag_current_state;
  }
  } 
  


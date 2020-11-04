#include <Morse.h>

Morse morse(13);

void setup() { }

void loop() {
  // y -.-- 
  morse.dash(); morse.dot(); morse.dash(); morse.dash();
  // o --- 
  morse.dash(); morse.dash(); morse.dash(); 
  // u ..- 
  morse.dot(); morse.dot(); morse.dash(); 
  // r .-.
  morse.dot(); morse.dash(); morse.dot(); 
  // _ ··--·- 
  morse.dot(); morse.dot(); morse.dash(); morse.dash(); morse.dot();
  // f ..-. 
  morse.dot(); morse.dot(); morse.dash(); morse.dot();
  // l .-.. 
  morse.dot(); morse.dash(); morse.dot(); morse.dot();
  // a .- 
  morse.dot(); morse.dash(); 
  // g --. 
  morse.dash(); morse.dash(); morse.dot(); 
  // _ ··--·-
  morse.dot(); morse.dot(); morse.dash(); morse.dash(); morse.dot(); morse.dash();  
  // i .. 
  morse.dot(); morse.dot(); 
  // s ... 
  morse.dot(); morse.dot(); morse.dot(); 
  // _ ··--·- 
  morse.dot(); morse.dot(); morse.dash(); morse.dash(); morse.dot(); morse.dash(); 
  // i .. 
  morse.dot(); morse.dot(); 
  // n -. 
  morse.dash(); morse.dot(); 
  // _ ··--·- 
  morse.dot(); morse.dot(); morse.dash(); morse.dash(); morse.dot(); morse.dash(); 
  // m -- 
  morse.dash(); morse.dash(); 
  // o --- 
  morse.dash(); morse.dash(); morse.dash(); 
  // r .-. 
  morse.dot(); morse.dash(); morse.dot(); 
  // s ... 
  morse.dot(); morse.dot(); morse.dot(); 
  // e . 
  morse.dot(); 
  // _ ··--·- 
  morse.dot(); morse.dot(); morse.dash(); morse.dash(); morse.dot(); morse.dash(); 
  // c -.-. 
  morse.dash(); morse.dot(); morse.dash(); morse.dot(); 
  // o --- 
  morse.dash(); morse.dash(); morse.dash();
  // d -.. 
  morse.dash(); morse.dot(); morse.dot(); 
  // e .
  morse.dot(); 
  
  delay(3000);
}

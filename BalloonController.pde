// -------------------------------------------------------------------------------------------------
// TBD - TBD
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// Sample usage: this Arduino sketch cycles through each analog multiplexer channel once per second,
// reading the analog value and printing it to the Serial Monitor.

// Define the Arduino pins that the analog multiplexer is connected to.

#define ANALOG_MUX_PIN_S0     0
#define ANALOG_MUX_PIN_S1     1
#define ANALOG_MUX_PIN_S2     2
#define ANALOG_MUX_PIN_S3     3
#define ANALOG_MUX_SIGNAL_PIN 0

// Define a variable to remember the current analog multiplexer channel being read.

int currentAnalogMuxChannel = 0;

// Setup is run once at the beginning of each sketch.  This setup starts the Serial Monitor and 
// tells the analog multiplexer interface which pins to use to talk to the multiplexer.

void setup()
{
  Serial.begin(9600);
  initAnalogMux(ANALOG_MUX_PIN_S0, ANALOG_MUX_PIN_S1, ANALOG_MUX_PIN_S2, ANALOG_MUX_PIN_S3);
}

// Loop runs continuously.  This loop selects the next analog multiplexer channel, reads the value,
// and prints it to the Serial Monitor.  Then it increments the analog multiplexer channel, making
// sure to roll over when the channel number reaches the maximum.

void loop()
{
  selectAnalogMuxChannel(currentAnalogMuxChannel);
  int analogMuxCounts = analogRead(ANALOG_MUX_SIGNAL_PIN);
  
  Serial.print("Channel: ");
  Serial.print(currentAnalogMuxChannel);
  Serial.print(", Value: ");
  Serial.println(analogMuxCounts);
  
  currentAnalogMuxChannel = (currentAnalogMuxChannel + 1) % ANALOG_MUX_CHANNEL_COUNT;
  delay(1000);
}
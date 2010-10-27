// -------------------------------------------------------------------------------------------------
// TBD - TBD
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

// Define the Arduino pins that the analog multiplexer is connected to.

#define ANALOG_MUX_PIN_S0     0
#define ANALOG_MUX_PIN_S1     1
#define ANALOG_MUX_PIN_S2     2
#define ANALOG_MUX_PIN_S3     3
#define ANALOG_MUX_SIGNAL_PIN 0

// Define a variable to remember the current analog multiplexer channel being read.

int currentAnalogMuxChannel = 0;

// Setup is run once at the beginning of each sketch.

void setup()
{ 
  initLog();
  initAnalogMux(ANALOG_MUX_PIN_S0, ANALOG_MUX_PIN_S1, ANALOG_MUX_PIN_S2, ANALOG_MUX_PIN_S3);
  
  char logFilename[15];
  getLogFilename(logFilename);
  
  Serial.begin(9600);
  Serial.println(logFilename);
  logString("------ Begin Logging ------");
}

// Loop runs continuously.

void loop()
{
  selectAnalogMuxChannel(currentAnalogMuxChannel);
  int analogMuxCounts = analogRead(ANALOG_MUX_SIGNAL_PIN);
  
  // TBD: read, log, flush, rinse, repeat
  
  currentAnalogMuxChannel = (currentAnalogMuxChannel + 1) % ANALOG_MUX_CHANNEL_COUNT;
  logFlush();
  delay(5000);
}
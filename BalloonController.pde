// -------------------------------------------------------------------------------------------------
// TBD - TBD
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

// Define the data sampling rate in milliseconds.

#define DATA_SAMPLING_RATE_MS 60000    // 60000 ms = 1 min

// Define the Arduino pins that the analog multiplexer is connected to.

#define ANALOG_MUX_PIN_S0     0
#define ANALOG_MUX_PIN_S1     1
#define ANALOG_MUX_PIN_S2     2
#define ANALOG_MUX_PIN_S3     3
#define ANALOG_MUX_SIGNAL_PIN 0

// Define the analog multiplexer channels for each sensor.

#define ANALOG_MUX_CHANNEL_ACCELEROMETER_X 0
#define ANALOG_MUX_CHANNEL_ACCELEROMETER_Y 1
#define ANALOG_MUX_CHANNEL_ACCELEROMETER_Z 2

// Setup is run once at the beginning of each sketch, loop runs continuously -----------------------

void setup()
{ 
  initLog();
  logString("------ Begin Logging ------");
  
  initAnalogMux(ANALOG_MUX_PIN_S0, ANALOG_MUX_PIN_S1, ANALOG_MUX_PIN_S2, ANALOG_MUX_PIN_S3);
  accel_init(ANALOG_MUX_SIGNAL_PIN);
  
  char logFilename[15];
  getLogFilename(logFilename);
  
  Serial.begin(9600);
  Serial.println(logFilename);
}

void loop()
{
  logAccelerometerData();
  
  logFlush();    
  delay(DATA_SAMPLING_RATE_MS);
}

// Helper functions --------------------------------------------------------------------------------

void logAccelerometerData()
{
  Serial.println("Logging accelerometer data");
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_X);
  accel_sample_x();
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_Y);
  accel_sample_y();
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_Z);
  accel_sample_z();
  
  char dataString[255];
  accel_get_all(dataString);
  logString(dataString);
}
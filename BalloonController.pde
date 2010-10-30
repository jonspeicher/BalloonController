// -------------------------------------------------------------------------------------------------
// BalloonController - Flight data collection and logging system for a near-space balloon
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

// Define the data sampling rate in milliseconds.

//#define DATA_SAMPLING_RATE_MS 60000    // 60000 ms = 1 min
#define DATA_SAMPLING_RATE_MS 5000

// Define the transmit and receive pins that the GPS module is connected to.

#define GPS_RECEIVE_PIN  6
#define GPS_TRANSMIT_PIN 7

// Define the Arduino digital pins that the analog multiplexer is connected to.

#define ANALOG_MUX_PIN_S0     2
#define ANALOG_MUX_PIN_S1     3
#define ANALOG_MUX_PIN_S2     4
#define ANALOG_MUX_PIN_S3     5
#define ANALOG_MUX_SIGNAL_PIN 0

// Define the analog multiplexer channels for each sensor.

#define ANALOG_MUX_CHANNEL_ACCELEROMETER_X     2
#define ANALOG_MUX_CHANNEL_ACCELEROMETER_Y     1
#define ANALOG_MUX_CHANNEL_ACCELEROMETER_Z     0
#define ANALOG_MUX_CHANNEL_TEMPERATURE_INSIDE  13
#define ANALOG_MUX_CHANNEL_TEMPERATURE_OUTSIDE 14
#define ANALOG_MUX_CHANNEL_TEMPERATURE_BATTERY 15

// Define the maximium data string length in characters.  This includes the terminating null.

#define MAX_DATA_STRING_LENGTH 255

// Define a variable to keep track of the last log time in milliseconds.

uint32_t s_lastLogMillis = 0;

// Setup is run once at the beginning of each sketch, loop runs continuously -----------------------

void setup()
{ 
  //initLog();
  //logString("------ Begin Logging ------");
  
  initGps(GPS_RECEIVE_PIN, GPS_TRANSMIT_PIN);
  initAnalogMux(ANALOG_MUX_PIN_S0, ANALOG_MUX_PIN_S1, ANALOG_MUX_PIN_S2, ANALOG_MUX_PIN_S3);
  accel_init(ANALOG_MUX_SIGNAL_PIN);
  
  char logFilename[15];
  getLogFilename(logFilename);
  
  Serial.begin(9600);
  Serial.println("- BALLOON CONTROLLER RUNNING -");
  Serial.println(logFilename);
}

void loop()
{
  feedgps();
  
  if (millis() >= s_lastLogMillis + DATA_SAMPLING_RATE_MS)
  { 
    logGpsData();
    logAccelerometerData();
    logTemperatureData();
    //logFlush();  
    
    s_lastLogMillis = millis();
    Serial.println();
  }
}

// Helper functions --------------------------------------------------------------------------------

void logGpsData()
{
  Serial.println("-> Logging GPS data...");
  
  gpsdump();
  
  char dataString[MAX_DATA_STRING_LENGTH];
  GetGPSDataCSV(dataString);
  
  Serial.println(dataString);
  //logString(dataString);
}

void logAccelerometerData()
{
  Serial.println("-> Logging accelerometer data...");
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_X);
  accel_sample_x();
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_Y);
  accel_sample_y();
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_ACCELEROMETER_Z);
  accel_sample_z();
  
  char dataString[MAX_DATA_STRING_LENGTH];
  accel_get_all(dataString);
  
  Serial.println(dataString);
  //logString(dataString);
}

void logTemperatureData()
{
  Serial.println("-> Logging temperature data...");
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_TEMPERATURE_INSIDE);
  int insideTemp = Temperature(ANALOG_MUX_SIGNAL_PIN);
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_TEMPERATURE_OUTSIDE);
  int outsideTemp = Temperature(ANALOG_MUX_SIGNAL_PIN);
  
  selectAnalogMuxChannel(ANALOG_MUX_CHANNEL_TEMPERATURE_BATTERY);
  int batteryTemp = Temperature(ANALOG_MUX_SIGNAL_PIN);
  
  char dataString[MAX_DATA_STRING_LENGTH];
  sprintf(dataString, "%04X,%04X,%04X", insideTemp, outsideTemp, batteryTemp);
  
  Serial.println(dataString);
  //logString(dataString);
}

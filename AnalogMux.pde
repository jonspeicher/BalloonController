// -------------------------------------------------------------------------------------------------
// AnalogMux - Interface to a SparkFun 16-Channel Analog Multiplexer (using the TI CD74HC4067)
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

// Define the number of analog channels the multiplexer supports.

#define ANALOG_MUX_CHANNEL_COUNT 16

// Define local variables to remember the pins the multiplexer is connected to.

static int s_analogMuxPinS0, s_analogMuxPinS1, s_analogMuxPinS2, s_analogMuxPinS3;

// Initializes the analog multiplexer interface.  The Arduino pins connected to the multiplexer's
// S0, S1, S2, and S3 inputs must be specified.

void initAnalogMux(int pinS0, int pinS1, int pinS2, int pinS3)
{
  s_analogMuxPinS0 = pinS0; 
  s_analogMuxPinS1 = pinS1;
  s_analogMuxPinS2 = pinS2;
  s_analogMuxPinS3 = pinS3;
  
  pinMode(s_analogMuxPinS0, OUTPUT);
  pinMode(s_analogMuxPinS1, OUTPUT);
  pinMode(s_analogMuxPinS2, OUTPUT);
  pinMode(s_analogMuxPinS3, OUTPUT);
}

// Selects one of the multiplexed analog channels.

void selectAnalogMuxChannel(int channel)
{
  digitalWrite(s_analogMuxPinS0, bitRead(channel, 0));
  digitalWrite(s_analogMuxPinS1, bitRead(channel, 1));
  digitalWrite(s_analogMuxPinS2, bitRead(channel, 2));
  digitalWrite(s_analogMuxPinS3, bitRead(channel, 3));
}

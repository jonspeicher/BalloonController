/* Code to work with high-altitude GPS for the HackPGH balloon project.
   Written by Chris Yohe
*/

#include <NewSoftSerial.h>
#include <TinyGPS.h>
#include <String.h>

/* This code is a modification of the Test_with_GPS from the TinyGPS Library.
 We have addded a few variables for easy return of resdings and some serial logging.
 It requires the use of NewSoftSerial, and assumes that you have a
 4800-baud serial GPS device hooked up on pins 2(rx) and 3(tx).
 */

TinyGPS gps;

//change these pins if you use different for gps  
//2 is yellow 3 is blue  red is 5V and blk is gnd

NewSoftSerial nss(6, 7);

//we have static variables so we can track current position as well as max height and time

static long s_latitude, s_longitude, s_altitude, s_maxAltitude = 0;
static unsigned long s_fixAge, s_date, s_time, s_maxDate, s_maxTime;

void initGps(int receivePin, int transmitPin)
{
  nss.setRX(receivePin);
  nss.setTX(transmitPin);
  nss.begin(4800);
}

void gpsdump()
{
  unsigned long chars;
  unsigned short sentences, failed;

  feedgps(); // If we don't feed the gps during this long routine, we may drop characters and get checksum errors

  gps.get_position(&s_latitude, &s_longitude, &s_fixAge);

  feedgps();

  gps.get_datetime(&s_date, &s_time, &s_fixAge);  
 
  feedgps();

  s_altitude = gps.altitude();
  
  if (s_altitude > s_maxAltitude) 
  {
    s_maxAltitude = s_altitude;
    s_maxTime = s_time;
    s_maxDate = s_date;
  }

  feedgps();
}

bool feedgps()
{
  while (nss.available())
  {
    if (gps.encode(nss.read()))
    {
      return true;
    }
  }
  return false;
}

void GetGPSDataCSV(char userString[])
{
  sprintf(userString, "ARDSENSE %ld,%ld,%lu,%lu,%ld,%ld,%lu,%lu", 
    s_latitude, s_longitude, s_date, s_time, s_altitude, s_maxAltitude, s_maxDate, s_maxTime);
}

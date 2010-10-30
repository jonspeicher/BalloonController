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

static long Glat, Glon, GMaxLat, GMaxLong, Galt, GMaxAlt;
static unsigned long Gage, Gdate, Gtime, GMaxAge, GMaxTime, GMaxDate;

void initGps(int receivePin, int transmitPin)
{
  nss.setRX(receivePin);
  nss.setTX(transmitPin);
  nss.begin(4800);
}

void gpsdump()
{
  long lat, lon;
  float flat, flon;
  unsigned long age, date, time, chars;
  int year;
  byte month, day, hour, minute, second, hundredths;
  unsigned short sentences, failed;

  gps.get_position(&lat, &lon, &age);
  Glat = lat;
  Glon = lon;
  Gage = age;  

  feedgps(); // If we don't feed the gps during this long routine, we may drop characters and get checksum errors

  gps.f_get_position(&flat, &flon, &age);

  feedgps();

  gps.get_datetime(&date, &time, &age);  
  Gdate = date;
  Gtime = time;

  feedgps();

  gps.crack_datetime(&year, &month, &day, &hour, &minute, &second, &hundredths, &age);

  feedgps();

  Galt = gps.altitude();
  if (Galt > GMaxAlt) 
  {
    GMaxAlt = Galt;
    GMaxTime = Gtime;
    GMaxDate = Gdate;
  }


  feedgps();

  gps.stats(&chars, &sentences, &failed);
}

bool feedgps()
{
  while (nss.available())
  {
    if (gps.encode(nss.read()))
      return true;
  }
  return false;
}

void GetGPSDataCSV(char userString[])
{
  sprintf(userString, "ARDSENSE %ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld", Glat, Glon, Gdate, Gtime, Galt, GMaxAlt, GMaxDate, GMaxTime);
}

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

NewSoftSerial nss(7, 6);

//we ahve global variables so we can track current position as well as max height and time

long Glat, Glon, GMaxLat, GMaxLong, Galt, GMaxAlt;
unsigned long Gage, Gdate, Gtime, GMaxAge, GMaxTime, GMaxDate;

void printFloat(double number, int digits)
{
  // Handle negative numbers
  if (number < 0.0)
  {
    Serial.print('-');
    number = -number;
  }

  // Round correctly so that print(1.999, 2) prints as "2.00"
  double rounding = 0.5;
  for (uint8_t i=0; i<digits; ++i)
    rounding /= 10.0;

  number += rounding;

  // Extract the integer part of the number and print it
  unsigned long int_part = (unsigned long)number;
  double remainder = number - (double)int_part;
  Serial.print(int_part);

  // Print the decimal point, but only if there are digits beyond
  if (digits > 0)
    Serial.print("."); 

  // Extract digits from the remainder one at a time
  while (digits-- > 0)
  {
    remainder *= 10.0;
    int toPrint = int(remainder);
    Serial.print(toPrint);
    remainder -= toPrint; 
  } 
}

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
/*
  Serial.println("*******************OFFICIAL******************");
  Serial.print("Lat/Long(10^-5 deg): "); 
  Serial.print(lat); 
  Serial.print(", "); 
  Serial.println(lon); 
  Serial.print("Date(ddmmyy): "); 
  Serial.print(date); 
  Serial.print(" Time(hhmmsscc): "); 
  Serial.println(time);
  Serial.print("Alt(cm): "); 
  Serial.print(gps.altitude()); 
  Serial.print(" Course(10^-2 deg): "); 
  Serial.print(gps.course()); 
  Serial.print(" Speed(10^-2 knots): "); 
  Serial.println(gps.speed());
  Serial.print("Alt(float): "); 
  printFloat(gps.f_altitude(), 2); 
  Serial.print(" Course(float): "); 
  printFloat(gps.f_course(), 2); 
  Serial.println();
  Serial.print("Speed(knots): "); 
  printFloat(gps.f_speed_knots(), 2); 
  Serial.print(" (mph): ");  
  printFloat(gps.f_speed_mph(), 2);
  Serial.print(" (mps): "); 
  printFloat(gps.f_speed_mps(), 2); 
  Serial.print(" (kmph): "); 
  printFloat(gps.f_speed_kmph(), 2); 
  Serial.println();
  Serial.print("Stats: characters: "); 
  Serial.print(chars); 
  Serial.print(" sentences: "); 
  Serial.print(sentences); 
  Serial.print(" failed checksum: "); 
  Serial.println(failed);
  Serial.println();
  Serial.println("*******************US******************");
  Serial.println("GPS US");
  Serial.println(GetGPSData());
  Serial.println("GPSCSV US");
  Serial.println(GetGPSDataCSV());
  Serial.println("ALT US");
  Serial.println(GetCurrentAltitude());
  Serial.println("***************************************");
*/
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

String GetAlt()
{
  String temp;
  temp = Galt;
  return temp;
}
String GetLon()
{
  String temp;
  temp = Glon;
  return temp;
}
String GetLat()
{
  String temp;
  temp = Glat;
  return temp;
}
String GetMaxAlt()
{
  String temp;
  temp = GMaxAlt;
  return temp;
}
String GetDate()
{
  String temp;
  temp = Gdate;
  return temp;
}
String GetTime()
{
  String temp;
  temp = Gtime;
  return temp;
}
String GetMaxDate()
{
  String temp;
  temp = GMaxDate;
  return temp;
}
String GetMaxTime()
{
  String temp;
  temp = GMaxTime;
  return temp;
}

String GetGPSData()
{
  String LGPS;
  LGPS = "ARDSENSE Lead Balloon GPS : LAT ";
  LGPS += GetLat();
  LGPS += " LON ";
  LGPS += GetLon();
  LGPS += " Date/Time ";
  LGPS += GetDate();
  LGPS += "  / ";
  LGPS += GetTime();
  LGPS += " ALT ";
  LGPS += GetAlt();
  LGPS += " MAX ALT Date/Time ";
  LGPS += GetMaxAlt();
  LGPS += "   ";
  LGPS += GetMaxDate();
  LGPS += " / ";
  LGPS += GetMaxTime();  
  return LGPS;
}

String GetGPSDataCSV()
{
  String LGPS;
  LGPS = "ARDSENSE ";
  LGPS += GetLat();
  LGPS += ",";
  LGPS += GetLon();
  LGPS += ",";
  LGPS += GetDate();
  LGPS += ",";
  LGPS += GetTime();
  LGPS += ",";
  LGPS += GetAlt();
  LGPS += ",";
  LGPS += GetMaxAlt();
  LGPS += ",";
  LGPS += GetMaxDate();
  LGPS += ",";
  LGPS += GetMaxTime();
  return LGPS;
}

String GetCurrentAltitude()
{
  return "ALT " + GetAlt();
}  



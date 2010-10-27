/* Code to work with analog accelerometers for the HackPGH balloon project.
   Written by Matthew Beckler - matthew at mbeckler dot org

   Code released into the public domain, GPL, or MIT. Pick your poison.
 
 
 
unsigned int accel_x;
unsigned int accel_y;
unsigned int accel_z;
byte accel_analog_pin;

void accel_init(byte analog_pin)
{
  accel_x = 0;
  accel_y = 0;
  accel_z = 0;
  accel_analog_pin = analog_pin;
}

void accel_sample_x(void)
{
  accel_x = analogRead(accel_analog_pin);
}
void accel_sample_y(void)
{
  accel_y = analogRead(accel_analog_pin);
}
void accel_sample_z(void)
{
  accel_z = analogRead(accel_analog_pin);
}

// A customized version of itoa for base 16 with leading zero padding.
// This may be useful outside of the accel module.
void accel_itoa(unsigned int value, char* buf)
{
  buf[4] = '\0'; // null terminate
  
  byte i = 4;
  do
  {
    i--;
    buf[i] = '0' + (value & 0x000F);
    if (buf[i] > '9')
      buf[i] += 7; // = '9' = 57, 'A' = 65, so to make 58 into 65, we add 7
    value >>= 4;
  } while (i != 0);
}

// For these next three functions, ensure that buf has at least 5 spaces in it (4 hex digits + null terminator)
void accel_get_x(char* buf)
{
  accel_itoa(accel_x, buf);
}
void accel_get_y(char* buf)
{
  accel_itoa(accel_y, buf);
}
void accel_get_z(char* buf)
{
  accel_itoa(accel_z, buf);
}

// Ensure that buf is at least 3 * 4 + 2 + 1 = 15 bytes in size.
void accel_get_all(char* buf)
{
  accel_itoa(accel_x, buf);
  buf[4] = ',';
  accel_itoa(accel_y, buf + 5);
  buf[9] = ',';
  accel_itoa(accel_z, buf + 10);
  // just in case:
  buf[15] = '\0';
}

// ------------------------------------------------

void setup()
{
  Serial.begin(9600);
  accel_init(0);
}

void loop()
{
  // mux select accelerometer x
  accel_sample_x();
  
  // mux select accelerometer y
  accel_sample_y();
  
  // mux select accelerometer z
  accel_sample_z();
  
  // Three ways to get the data in string form:
  // 1. Individual buffers:
  char x[5];
  char y[5];
  char z[5];
  
  accel_get_x(x);
  accel_get_y(y);
  accel_get_z(z);
  
  Serial.print(x);
  Serial.print(y);
  Serial.println(z);
  
  // 2. As one big string: XXXX,YYYY,ZZZZ
  char accel[15];
  
  accel_get_all(accel);
  
  Serial.println(accel);
  
  // 3. As part of a larger string: "GPS:40.323,80.235...etc
  char status_str[140];
  
  // gps_get_string(status_str + 10); // fills to position 24
  
  accel_get_all(status_str + 25);
  
  //Serial.println(status_str);
  
  delay(10);
}

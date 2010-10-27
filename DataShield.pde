// -------------------------------------------------------------------------------------------------
// DataShield - Interface to an Adafruit Data Logging shield
// A project of HackPittsburgh (http://www.hackpittsburgh.org)
//
// Copyright (c) 2010 Jonathan Speicher (jonathan@hackpittsburgh.org)
// Licensed under the MIT license: http://creativecommons.org/licenses/MIT
// -------------------------------------------------------------------------------------------------

#include <Wire.h>
#include "RTClib.h"
#include "SdFat.h"

// Define the base log file name, its extension, the maximum number of log files that may be present
// on the SD card before it is declared to be "full", the maximum length of a file name, and the log
// file open mode.  It is important that the maximum file name length be large enough to hold the
// number of characters specified in the base log file name, its extension, and the number of digits
// required by the maximum log file count, plus one additional character (for the null).

#define BASE_LOG_FILE_NAME   "log"
#define LOG_FILE_EXTENSION   ".csv"
#define MAX_LOG_FILE_COUNT   99
#define MAX_FILE_NAME_LENGTH 15
#define LOG_FILE_MODE        O_CREAT | O_EXCL | O_WRITE

// Define local objects to represent the realtime clock and the interface to the SD card.

static RTC_DS1307 s_realTimeClock;
static Sd2Card    s_sdCard;
static SdVolume   s_fatVolume;
static SdFile     s_rootDirectory;
static SdFile     s_logFile;

// Define local variables to remember the current log file name, as well as a flag to remind us 
// whether the log file was successfully opened or not.

static char       s_filename[MAX_FILE_NAME_LENGTH];
static boolean    s_open = false;

// Initializes the data logger.  Note that if a failure to initialize the data logger occurs, this 
// function will silently return and future calls to log data will do nothing.  This is by design 
// in that if a failure occurs, the rest of the sketch won't be held up by a failure to log data.

void initLog()
{
  Wire.begin();
  s_realTimeClock.begin();

  if (!s_sdCard.init()) return;
  if (!s_fatVolume.init(s_sdCard)) return;
  if (!s_rootDirectory.openRoot(s_fatVolume)) return;
  
  for (int index = 0; index < MAX_LOG_FILE_COUNT + 1; index++) 
  {
    sprintf(s_filename, "%s%d%s", BASE_LOG_FILE_NAME, index, LOG_FILE_EXTENSION);
    
    if (s_logFile.open(s_rootDirectory, s_filename, LOG_FILE_MODE))
    {
      s_open = true;
      break;
    }
  }
}

// Writes the specified string to the log file with a timestamp from the real-time clock.  This
// function will perform no operation if the log file has not been initialized or if the log file
// initialization has failed.  THe string must be null-terminated or bad things will happen.

void logString(char userString[])
{
  if (!s_open) return;
  
  char timeString[40];
  DateTime wall = s_realTimeClock.now();
  
  sprintf(timeString, "%ld, \"%02d-%02d-%04d %d:%02d:%02d\", ", 
    millis(), wall.month(), wall.day(), wall.year(), wall.hour(), wall.minute(), wall.second());
    
  s_logFile.print(timeString);
  s_logFile.println(userString);
}

// Flushes the log.  Note that logged data is not actually written to the log file until this
// function is called.

void logFlush()
{
  if (!s_open) return;
  s_logFile.sync();
}

// Returns the name of the currently-selected log file.  Note that this function will return a log
// file name even if the log was not properly opened.  The supplied string must have enough 
// allocated space to hold the log filename string.

void getLogFilename(char userString[])
{
  strcpy(userString, s_filename);
}
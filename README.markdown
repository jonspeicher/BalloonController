BalloonController
=================

BalloonController is a flight computer data collection and logging system for a near-space balloon.

Description
===========

[HackPittsburgh](http://www.hackpittsburgh.org) has launched several high-altitude balloon projects.
From the third launch forward, the payload is anticipated to include a number of sensors not
previously flown.  This requires a controller that knows about the layout of the flight computer
circuit, the data to be logged, how to retrieve it, and how to log it.

This software package contains that controller (which by extension includes the Arduino sketch's
`setup` and `loop` functions).  This package also includes libraries contributed by other
HackPittsburgh participants to interface with the various flight computer subsystems.

Previous balloon launch photos are available at the
[HackPittsburgh Flickr Pool](http://www.flickr.com/groups/hackpgh).  My favorites, plus my ground
photos, are in [My Flickr set](http://www.flickr.com/photos/jonspeicher/sets/72157624683638916/).

Minimum Requirements
====================

* An Arduino (http://arduino.cc)
* SparkFun Analog Mux Breakout (http://www.sparkfun.com/commerce/product_info.php?products_id=9056)
* SparkFun 3-Axis Accelerometer (http://www.sparkfun.com/commerce/product_info.php?products_id=9156)
* Adafruit Data Logging Shield (http://www.ladyada.net/make/logshield)
* Argent High-Altitude GPS (https://www.argentdata.com/catalog/product_info.php?products_id=144)
* Arduino 0021 (http://arduino.cc)
* SdFatLib 10-10-2010 (http://code.google.com/p/sdfatlib)
* Adafruit's fork of RTClib (http://github.com/adafruit/RTClib)
* NewSoftSerial 10c (http://arduiniana.org/libraries/newsoftserial)
* TinyGPS 9 (http://arduiniana.org/libraries/tinygps)

Installation
============

Refer to the installation instructions on the Arduino website to install the development
environment.  To install the required libraries, assuming you are using a modern Arduino
environment, simply unzip them to their own directories within:

    [your_sketchbook_directory]/libraries

There should be plenty of online documentation describing this process.

Usage
=====

To use BalloonController in your project, you must ensure that a few preprocessor definitions are
accurate, and you must of course wire up the proper circuit.  The best place to see what is required
is in the code itself.  If you have any questions, email me.

Tests
=====

BalloonController has been bench-tested with the flight computer.  GPS, accelerometer, and logging
have been verified to work.  Temperature sensing is thought to work in the software but we believe
that there is a bug in the circuit itself.

The individual units upon which BalloonController relies have also been tested, and I tried to be
careful with the coding and design.

Improvements
============

* The code could be made consistent from a naming and formatting standpoint
* Some interfaces return strings, others return ints/floats
* Some modules have initialization functions, some don't
* Encapsulation and packaging isn't the greatest
* An object-oriented solution might feel better
* And many, many, many more...

Contributors
============

* Matthew Beckler
* Ed Paradis
* Jon Speicher ([jonathan@hackpittsburgh.org](mailto:jonathan@hackpittsburgh.org))
* Matthew Stultz
* Chris Yohe

History
=======

0.1
---

* Initial release (totally untested)

0.2
---

* Update pins to match the balloon flight computer layout
* Add logging
* Code cleanup

0.3
---

* Update logging interval to one minute

License
=======

    The MIT License

    Copyright (c) 2010 HackPittsburgh, LLC

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
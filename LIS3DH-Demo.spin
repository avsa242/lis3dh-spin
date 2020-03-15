{
    --------------------------------------------
    Filename: LIS3DH-Demo.spin
    Author: Jesse Burt
    Description: Demo of the LIS3DH driver
    Copyright (c) 2020
    Started Mar 15, 2020
    Updated Mar 15, 2020
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' User-modifiable constants
    LED         = cfg#LED1
    SER_RX      = 31
    SER_TX      = 30
    SER_BAUD    = 115_200

    CS_PIN      = 8
    SCL_PIN     = 11
    SDA_PIN     = 10
    SDO_PIN     = 9
    SCL_DELAY   = 1

OBJ

    cfg     : "core.con.boardcfg.flip"
    ser     : "com.serial.terminal.ansi"
    time    : "time"
    io      : "io"
    lis3dh  : "sensor.accel.3dof.lis3dh.spi"

VAR

    byte _ser_cog

PUB Main

    Setup
    ser.position(0, 3)
    ser.hex(lis3dh.deviceid, 8)
    flashled(led, 100)

PUB Setup

    repeat until _ser_cog := ser.Start (115_200)
    time.MSleep(30)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#CR, ser#LF))
    if lis3dh.Startx(CS_PIN, SCL_PIN, SDA_PIN, SDO_PIN, SCL_DELAY)
        ser.str(string("LIS3DH driver started", ser#CR, ser#LF))
    else
        ser.str(string("LIS3DH driver failed to start - halting", ser#CR, ser#LF))
        lis3dh.Stop
        time.MSleep(5)
        ser.Stop
        FlashLED(LED, 500)

#include "lib.utility.spin"

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}

{
----------------------------------------------------------------------------------------------------
    Filename:       LIS3DH-Demo.spin
    Description:    Demo of the LIS3DH driver
        * 3DoF data output
    Author:         Jesse Burt
    Started:        Mar 15, 2020
    Updated:        Jun 21, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

' Uncomment the following two lines to use the driver in SPI mode
'#define LIS3DH_SPI
'#pragma exportdef(LIS3DH_SPI)

' Uncomment the following two lines to use the driver with a bytecode-based SPI engine
'#define LIS3DH_SPI_BC
'#pragma exportdef(LIS3DH_SPI_BC)

' Uncomment the following two lines to use the driver with a bytecode-based I2C engine
'#define LIS3DH_I2C_BC
'#pragma exportdef(LIS3DH_I2C_BC)


CON

    _clkmode    = cfg._clkmode
    _xinfreq    = cfg._xinfreq


OBJ

    cfg:    "boardcfg.flip"
    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    sensor: "sensor.accel.3dof.lis3dh" |    {I2C} SCL=28, SDA=29, I2C_FREQ=400_000, I2C_ADDR=0, ...
                                            {SPI} CS=0, SCK=1, MOSI=2, MISO=3, SPI_FREQ=1_000_000
'   NOTE: If LIS3DH_SPI is #defined, and MOSI_PIN and MISO_PIN are the same,
'   the driver will attempt to start in 3-wire SPI mode.


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( sensor.start() )
        ser.strln(@"LIS3DH driver started")
    else
        ser.strln(@"LIS3DH driver failed to start - halting")
        repeat

    sensor.preset_active()

    repeat
        ser.pos_xy(0, 3)
        show_accel_data()
        if ( ser.rx_check() == "c" )
            cal_accel()

#include "acceldemo.common.spinh"                 ' code common to all IMU demos


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


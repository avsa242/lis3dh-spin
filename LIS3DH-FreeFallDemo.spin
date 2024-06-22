{
----------------------------------------------------------------------------------------------------
    Filename:       LIS3DH-FreeFallDemo.spin
    Description:    Demo of the LIS3DH driver
        * Free-fall detection functionality
    Author:         Jesse Burt
    Started:        Dec 22, 2021
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

' -- User-modifiable constants
    LED1        = cfg.LED1
    INT1        = 24
' --


OBJ

    cfg:    "boardcfg.flip"
    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    sensor: "sensor.accel.3dof.lis3dh" |    {I2C} SCL=28, SDA=29, I2C_FREQ=400_000, I2C_ADDR=0, ...
                                            {SPI} CS=0, SCK=1, MOSI=2, MISO=3, SPI_FREQ=1_000_000
'   NOTE: If LIS3DH_SPI is #defined, and MOSI_PIN and MISO_PIN are the same,
'   the driver will attempt to start in 3-wire SPI mode.


VAR

    long _isr_stack[50]                         ' stack for ISR core
    long _intflag                               ' interrupt flag


PUB main() | intsource

    setup()
    sensor.preset_freefall()                     ' default settings, but enable
                                                ' sensors, set scale factors,
                                                ' and free-fall parameters

    ser.pos_xy(0, 3)
    ser.puts(@"Waiting for free-fall condition...")

    ' When the sensor detects free-fall, a message is displayed and
    '   is cleared after the user presses a key
    ' The preset for free-fall detection sets a free-fall threshold of
    '   0.320g's for a minimum time of 100ms. This can be tuned using
    '   sensor.freefall_set_thresh() and sensor.freefall_set_time():
    sensor.freefall_set_thresh(0_320000)         ' 0.320g's
    sensor.freefall_set_time(100_000)            ' 100_000us/100ms

    repeat
        if (_intflag)                           ' interrupt triggered?
            intsource := sensor.accel_int()      ' read & clear interrupt flags
            if (intsource & %01_01_01)          ' free-fall event?
                ser.pos_xy(0, 4)
                ser.puts(@"Sensor in free-fall!")
                ser.clear_line()
                ser.newline()
                ser.puts(@"Press any key to reset")
                ser.getchar()
                ser.pos_x(0)
                ser.clear_line()
                ser.pos_xy(0, 4)
                ser.puts(@"Sensor stable")
                ser.clear_line()
        if (ser.getchar_noblock() == "c")       ' press the 'c' key in the demo
            calibrate()                         ' to calibrate sensor offsets


PUB calibrate()
' Calibrate sensor/set bias offsets
    ser.pos_xy(0, 7)
    ser.str(@"Calibrating...")
    sensor.calibrate_accel()
    ser.pos_x(0)
    ser.clear_line()


PRI cog_isr()
' Interrupt service routine
    dira[INT1] := 0                             ' INT1 as input
    dira[LED1] := 1                             ' LED as output

    repeat
        waitpeq(|< INT1, |< INT1, 0)            ' wait for INT1 (active high)
        outa[LED1] := 1                         ' light LED
        _intflag := 1                           '   set flag

        waitpne(|< INT1, |< INT1, 0)            ' now wait for it to clear
        outa[LED1] := 0                         ' turn off LED
        _intflag := 0                           '   clear flag


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

    cognew(cog_isr(), @_isr_stack)                  ' start ISR in another core


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


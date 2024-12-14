{
----------------------------------------------------------------------------------------------------
    Filename:       LIS3DH-ClickDemo.spin
    Description:    Demo of the LIS3DH driver
        * click-detection functionality
    Author:         Jesse Burt
    Started:        Jul 11, 2020
    Updated:        Dec 14, 2024
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

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    sensor: "sensor.accel.3dof.lis3dh" |    {I2C} SCL=28, SDA=29, I2C_FREQ=400_000, I2C_ADDR=0, ...
                                            {SPI} CS=0, SCK=1, MOSI=2, MISO=3, SPI_FREQ=1_000_000
'   NOTE: If LIS3DH_SPI is #defined, and MOSI_PIN and MISO_PIN are the same,
'   the driver will attempt to start in 3-wire SPI mode.


PUB main() | click_src, int_act, dclicked, sclicked, z_clicked, y_clicked, x_clicked

    setup()
    sensor.preset_clickdet()                    ' preset settings for click-detection

    ser.hide_cursor()                           ' hide terminal cursor

    repeat until (ser.getchar_noblock() == "q") ' press q to quit
        click_src := sensor.clicked_int()
        int_act := ((click_src >> 6) & 1)
        dclicked := ((click_src >> 5) & 1)
        sclicked := ((click_src >> 4) & 1)
        z_clicked := ((click_src >> 2) & 1)
        y_clicked := ((click_src >> 1) & 1)
        x_clicked := (click_src & 1)
        ser.pos_xy(0, 3)
        ser.printf(@"Click interrupt: %s\n\r", yesno(int_act))
        ser.printf(@"Double-clicked:  %s\n\r", yesno(dclicked))
        ser.printf(@"Single-clicked:  %s\n\r", yesno(sclicked))
        ser.printf(@"Z-axis clicked:  %s\n\r", yesno(z_clicked))
        ser.printf(@"Y-axis clicked:  %s\n\r", yesno(y_clicked))
        ser.printf(@"X-axis clicked:  %s\n\r", yesno(x_clicked))

    ser.show_cursor()                           ' restore terminal cursor
    repeat


PRI yesno(val): resp
' Return pointer to string "Yes" or "No" depending on value called with
    case val
        0:
            return @"No "
        1:
            return @"Yes"


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


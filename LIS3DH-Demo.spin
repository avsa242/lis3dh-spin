{
    --------------------------------------------
    Filename: LIS3DH-Demo.spin
    Author: Jesse Burt
    Description: Demo of the LIS3DH driver
    Copyright (c) 2021
    Started Aug 12, 2017
    Updated Jan 27, 2021
    See end of file for terms of use.
    --------------------------------------------
}
' Uncomment one of the following to choose which interface the LIS3DH is connected to
#define LIS3DH_I2C
'#define LIS3DH_SPI

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-modifiable constants
    LED         = cfg#LED1
    SER_BAUD    = 115_200

    CS_PIN      = 0                             ' SPI
    SCL_PIN     = 1                             ' SPI, I2C
    SDA_PIN     = 2                             ' SPI, I2C
    SDO_PIN     = 3                             ' SPI
    I2C_HZ      = 400_000                       ' I2C
    SLAVE_OPT   = 0                             ' I2C
' --

    DAT_X_COL   = 20
    DAT_Y_COL   = DAT_X_COL + 15
    DAT_Z_COL   = DAT_Y_COL + 15

OBJ

    cfg     : "core.con.boardcfg.flip"
    ser     : "com.serial.terminal.ansi"
    time    : "time"
    int     : "string.integer"
    accel   : "sensor.accel.3dof.lis3dh.i2cspi"

PUB Main{}

    setup{}
    accel.preset_active{}

    repeat
        ser.position(0, 3)
        accelcalc{}

        if ser.rxcheck{} == "c"                 ' press the 'c' key in the demo
            calibrate{}                         ' to calibrate sensor offsets

PUB AccelCalc{} | ax, ay, az

    repeat until accel.acceldataready{}         ' wait for new sensor data set
    accel.accelg(@ax, @ay, @az)                 ' read calculated sensor data
    ser.str(string("Accel (g):"))
    ser.positionx(DAT_X_COL)
    decimal(ax, 1000000)                        ' data is in micro-g's; display
    ser.positionx(DAT_Y_COL)                    ' it as if it were a float
    decimal(ay, 1000000)
    ser.positionx(DAT_Z_COL)
    decimal(az, 1000000)
    ser.clearline{}
    ser.newline{}

PUB Calibrate{}

    ser.position(0, 7)
    ser.str(string("Calibrating..."))
    accel.calibrateaccel{}
    ser.positionx(0)
    ser.clearline{}

PRI Decimal(scaled, divisor) | whole[4], part[4], places, tmp, sign
' Display a scaled up number as a decimal
'   Scale it back down by divisor (e.g., 10, 100, 1000, etc)
    whole := scaled / divisor
    tmp := divisor
    places := 0
    part := 0
    sign := 0
    if scaled < 0
        sign := "-"
    else
        sign := " "

    repeat
        tmp /= 10
        places++
    until tmp == 1
    scaled //= divisor
    part := int.deczeroed(||(scaled), places)

    ser.char(sign)
    ser.dec(||(whole))
    ser.char(".")
    ser.str(part)
    ser.chars(" ", 5)

PUB Setup{}

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear{}
    ser.strln(string("Serial terminal started"))
#ifdef LIS3DH_SPI
    if accel.startx(CS_PIN, SCL_PIN, SDA_PIN, SDO_PIN)
        ser.strln(string("LIS3DH driver started (SPI)"))
#elseifdef LIS3DH_I2C
    if accel.startx(SCL_PIN, SDA_PIN, I2C_HZ, SLAVE_OPT)
        ser.strln(string("LIS3DH driver started (I2C)"))
#endif
    else
        ser.strln(string("LIS3DH driver failed to start - halting"))
        accel.stop{}
        time.msleep(5)
        ser.stop{}

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

{
    --------------------------------------------
    Filename: sensor.accel.3dof.lis3dh.spi.spin
    Author: Jesse Burt
    Description: Driver for the ST LIS3DH 3DoF accelerometer
    Copyright (c) 2020
    Started Mar 15, 2020
    Updated Mar 15, 2020
    See end of file for terms of use.
    --------------------------------------------
}

CON

' Operating modes


VAR

    long _aRes
    byte _CS, _MOSI, _MISO, _SCK

OBJ

    spi : "com.spi.4w"                                          'PASM SPI Driver
    core: "core.con.lis3dh"
    time: "time"                                                'Basic timing functions
    io  : "io"

PUB Null
''This is not a top-level object

PUB Start(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN) : okay

    okay := Startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN, core#SCK_DELAY)

PUB Startx(CS_PIN, SCL_PIN, SDA_PIN, SDO_PIN, SCL_DELAY): okay
    if lookdown(CS_PIN: 0..31) and lookdown(SCL_PIN: 0..31) and lookdown(SDA_PIN: 0..31) and lookdown(SDO_PIN: 0..31)
        if SCL_DELAY => 1
            if okay := spi.start (SCL_DELAY, core#CPOL)         'SPI Object Started?
                time.MSleep (1)
                _CS := CS_PIN
                _MOSI := SDA_PIN
                _MISO := SDO_PIN
                _SCK := SCL_PIN

                io.High(_CS)
                io.Output(_CS)
                if DeviceID == core#WHO_AM_I_RESP
                    return okay
    return FALSE                                                'If we got here, something went wrong

PUB Stop

    spi.Stop

PUB Defaults
' Factory defaults
{
PUB AccelADCRes(bits) | tmp
' Set accelerometer ADC resolution, in bits
'   Valid values:
'
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#REG, 1, @tmp)
    case bits
        min..max:
        OTHER:
            return tmp

    tmp &= core#MASK_
    tmp := (tmp | bits) & core#_MASK
    writeReg(core#REG, 1, @tmp)

PUB AccelData(ptr_x, ptr_y, ptr_z) | tmp[2]
' Reads the Accelerometer output registers
    bytefill(@tmp, $00, 8)
    readReg(core#XYZREG, 6, @tmp)

    long[ptr_x] := tmp.word[0]
    long[ptr_y] := tmp.word[1]
    long[ptr_z] := tmp.word[2]

    if long[ptr_x] > 32767
        long[ptr_x] := long[ptr_x]-65536
    if long[ptr_y] > 32767
        long[ptr_y] := long[ptr_y]-65536
    if long[ptr_z] > 32767
        long[ptr_z] := long[ptr_z]-65536

PUB AccelDataOverrun
' Indicates previously acquired data has been overwritten
'   Returns: TRUE (-1) if data has overflowed/been overwritten, FALSE otherwise
    result := $00
    readReg(core#OVR_REG, 1, @result)
    result := (result & %1) * TRUE

PUB AccelDataRate(Hz) | tmp
' Set accelerometer output data rate, in Hz
'   Valid values: See case table below
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#RATE_REG, 1, @tmp)
    case Hz
        min..max:
        OTHER:
            return tmp

    tmp &= core#MASK_
    tmp := (tmp | Hz) & core#_MASK
    writeReg(core#RATE_REG, 1, @tmp)

PUB AccelDataReady
' Indicates data is ready
'   Returns: TRUE (-1) if data ready, FALSE otherwise
    result := $00
    readReg(core#DRDY_REG, 1, @result)
    result := ((result >> core#FLD_) & %1) * TRUE

PUB AccelG(ptr_x, ptr_y, ptr_z) | tmpX, tmpY, tmpZ
' Reads the Accelerometer output registers and scales the outputs to micro-g's (1_000_000 = 1.000000 g = 9.8 m/s/s)
    AccelData(@tmpX, @tmpY, @tmpZ)
    long[ptr_x] := tmpX * _aRes
    long[ptr_y] := tmpY * _aRes
    long[ptr_z] := tmpZ * _aRes

PUB AccelScale(g) | tmp
' Set measurement range of the accelerometer, in g's
'   Valid values:
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#SCALE_REG, 1, @tmp)
    case g
        min..max:
            g := lookdownz(g: min, max)
            _aRes := lookup(g: scale1, scale2)    '   it depends on the range
            g <<= core#FLD_
        OTHER:
            tmp &= core#BITS_
            return tmp

    tmp &= core#MASK_
    tmp := (tmp | g)
    writeReg(core#SCALE_REG, 1, @tmp)

PUB AccelSelfTest(enabled) | tmp
' Enable self-test mode
'   Valid values: TRUE (-1 or 1), FALSE (0)
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#ST_REG, 1, @tmp)
    case ||enabled
        0, 1:
            enabled := ||enabled << core#FLD_
        OTHER:
            tmp >>= core#FLD_
            return (tmp & %1) * TRUE

    tmp &= core#MASK_
    tmp := (tmp | enabled) & core#ST_REG_MASK
    writeReg(core#ST_REG, 1, @tmp)


PUB Calibrate | tmpX, tmpY, tmpZ
' Calibrate the accelerometer
'   NOTE: The accelerometer must be oriented with the package top facing up for this method to be successful
    repeat 3
        AccelData(@tmpX, @tmpY, @tmpZ)
        tmpX += 2 * -tmpX
        tmpY += 2 * -tmpY
        tmpZ += 2 * -(tmpZ-(_aRes/1000))

    writeReg(core#XOFFREG, 2, @tmpX)
    writeReg(core#YOFFREG, 2, @tmpY)
    writeReg(core#ZOFFREG, 2, @tmpZ)
    time.MSleep(200)
}
PUB DeviceID
' Read device identification
    result := $00
    readReg(core#WHO_AM_I, 1, @result)
{
PUB IntMask(mask) | tmp
' Set interrupt mask
'   Bits:   76543210
'
'   Valid values: %00000000..%11111111
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#INTMASK_REG, 1, @tmp)
    case mask
        %0000_0000..%1111_1111:
        OTHER:
            return tmp

    writeReg(core#INTMASK_REG, 1, @mask)

PUB OpMode(mode) | tmp
' Set operating mode
'   Valid values:
'
'   Any other value polls the chip and returns the current setting
    tmp := $00
    readReg(core#OPMODE_REG, 1, @tmp)
    case mode
        mode1, mode2, modeN:
            mode <<= core#FLD_
        OTHER:
            result := (tmp >> core#FLD_) & %1
            return

    tmp &= core#MASK_
    tmp := (tmp | mode) & core#OPMODE_REG_MASK
    writeReg(core#OPMODE_REG, 1, @tmp)
}
PRI readReg(reg, nr_bytes, buff_addr) | tmp
' Read nr_bytes from register 'reg' to address 'buff_addr'
    case reg
'        $07..$0D, $0F, $1E..$3F:
        $0F:
        OTHER:
            return FALSE

    io.Low(_CS)
    spi.SHIFTOUT(_MOSI, _SCK, core#MOSI_BITORDER, 8, reg | core#R)

    repeat tmp from 0 to nr_bytes-1
        byte[buff_addr][tmp] := spi.SHIFTIN(_MISO, _SCK, core#MISO_BITORDER, 8)
    io.High(_CS)

PRI writeReg(reg, nr_bytes, buff_addr) | tmp
' Write nr_bytes to register 'reg' stored at buff_addr
    case reg
        $1E..$26, $2E, $30, $32..$34, $36..$38, $3A..$3F:
        OTHER:
            return FALSE

    io.Low(_CS)
    spi.SHIFTOUT(_MOSI, _SCK, core#MOSI_BITORDER, 8, reg)

    repeat tmp from 0 to nr_bytes-1
        spi.SHIFTOUT(_MOSI, _SCK, core#MOSI_BITORDER, 8, byte[buff_addr][tmp])
    io.High(_CS)

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

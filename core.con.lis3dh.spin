{
    --------------------------------------------
    Filename: core.con.lis3dh.spin
    Author: Jesse Burt
    Description: Low-level constants
    Copyright (c) 2020
    Started Mar 15, 2020
    Updated Mar 15, 2020
    See end of file for terms of use.
    --------------------------------------------
}

CON

' I2C Configuration
    I2C_MAX_FREQ                = 400_000

' SPI Configuration
    CPOL                        = 0             ' Datasheet diagrams imply it's 1, but it doesn't work
    MOSI_BITORDER               = 5             ' MSBFIRST
    MISO_BITORDER               = 0             ' MSBPRE
    SCK_DELAY                   = 1             ' P1/SPIN1
    SCK_MAX_FREQ                = 10_000_000    ' P2/SPIN2

    W                           = 0
    R                           = 1 << 7
    MS                          = 1 << 6

    TPOR                        = 5             ' ms

' Register definitions
    STATUS_REG_AUX              = $07
    OUT_ADC1_L                  = $08
    OUT_ADC1_H                  = $09
    OUT_ADC2_L                  = $0A
    OUT_ADC2_H                  = $0B
    OUT_ADC3_L                  = $0C
    OUT_ADC3_H                  = $0D

    WHO_AM_I                    = $0F
    WHO_AM_I_RESP               = $33

    CTRL_REG0                   = $1E
    TEMP_CFG_REG                = $1F

    CTRL_REG1                   = $20
    CTRL_REG1_MASK              = $FF
        FLD_ODR                 = 4
        FLD_LPEN                = 3
        FLD_XYZEN               = 0
        BITS_ODR                = %1111
        BITS_XYZEN              = %111
        MASK_ODR                = CTRL_REG1_MASK ^ (BITS_ODR << FLD_ODR)
        MASK_LPEN               = CTRL_REG1_MASK ^ (1 << FLD_LPEN)
        MASK_XYZEN              = CTRL_REG1_MASK ^ (BITS_XYZEN << FLD_XYZEN)

    CTRL_REG2                   = $21
    CTRL_REG3                   = $22

    CTRL_REG4                   = $23
    CTRL_REG4_MASK              = $FF
        FLD_BDU                 = 7
        FLD_BLE                 = 6
        FLD_FS                  = 4
        FLD_HR                  = 3
        FLD_ST                  = 1
        FLD_SIM                 = 0
        BITS_FS                 = %11
        BITS_ST                 = %11
        MASK_BDU                = CTRL_REG4_MASK ^ (1 << FLD_BDU)
        MASK_BLE                = CTRL_REG4_MASK ^ (1 << FLD_BLE)
        MASK_FS                 = CTRL_REG4_MASK ^ (BITS_FS << FLD_FS)
        MASK_HR                 = CTRL_REG4_MASK ^ (1 << FLD_HR)
        MASK_ST                 = CTRL_REG4_MASK ^ (BITS_ST << FLD_ST)
        MASK_SIM                = CTRL_REG4_MASK ^ (1 << FLD_SIM)

    CTRL_REG5                   = $24
    CTRL_REG6                   = $25
    REFERENCE                   = $26

    STATUS_REG                  = $27
        FLD_ZYXOR               = 7
        FLD_ZOR                 = 6
        FLD_YOR                 = 5
        FLD_XOR                 = 4
        FLD_ZYXDA               = 3
        FLD_ZDA                 = 2
        FLD_YDA                 = 1
        FLD_XDA                 = 0

    OUT_X_L                     = $28
    OUT_X_H                     = $29
    OUT_Y_L                     = $2A
    OUT_Y_H                     = $2B
    OUT_Z_L                     = $2C
    OUT_Z_H                     = $2D

    FIFO_CTRL_REG               = $2E
    FIFO_SRC_REG                = $2F
    INT1_CFG                    = $30
    INT1_SRC                    = $31
    INT1_THS                    = $32
    INT1_DURATION               = $33
    INT2_CFG                    = $34
    INT2_SRC                    = $35
    INT2_THS                    = $36
    INT2_DURATION               = $37
    CLICK_CFG                   = $38
    CLICK_SRC                   = $39
    CLICK_THS                   = $3A
    TIME_LIMIT                  = $3B
    TIME_LATENCY                = $3C
    TIME_WINDOW                 = $3D
    ACT_THS                     = $3E
    ACT_DUR                     = $3F



PUB Null
' This is not a top-level object

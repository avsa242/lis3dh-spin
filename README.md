# lis3dh-spin 
-------------

This is a P8X32A/Propeller, P2X8C4M64P driver object for the ST LIS3DH 3DoF accelerometer

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* I2C connection at up to 400kHz (P1, P2)
* SPI connection (3w, 4w) at ~4MHz (P1), up to 5MHz (P2)
* Read raw or scaled accelerometer data output
* Set output data rate
* Set full-scale range
* Enable per-axis output
* Flags to indicate data is ready, or has overrun
* Set calibration offsets
* FIFO control and flag reading (empty, full, number of unread samples)
* Set interrupt sources by mask, set threshold level, read interrupt flags
* Single and double-click detection
* Free-fall detection


## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM I2C or SPI engine (none, if bytecode engine is used)
* sensor.imu.common.spinh (provided by spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* sensor.imu.common.spin2h (provided by p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.8.0)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.8.0)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.8.0)       | NuCode       | OK                    |
| P2        | SPIN2    | FlexSpin (6.8.0)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Limitations

* TBD


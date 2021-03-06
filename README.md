# lis3dh-spin 
-------------

This is a P8X32A/Propeller, P2X8C4M64P driver object for the ST LIS3DH 3DoF accelerometer

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* I2C connection at up to 400kHz (P1, P2)
* SPI connection (4w) at up to 4MHz (P1), ~5MHz (P2)
* Read raw or scaled accelerometer data output
* Set output data rate
* Set full-scale range
* Enable per-axis output
* Flags to indicate data is ready, or has overrun
* Set calibration offsets
* FIFO control and flag reading (empty, full, number of unread samples)
* Set interrupt sources by mask, set threshold level, read interrupt flags
* Single and double-click detection

## Requirements

P1/SPIN1:
* spin-standard-library
* P1/SPIN1/SPI: 1 extra core/cog for the PASM SPI driver
 (or)
* P1/SPIN1/I2C: 1 extra core/cog for the PASM I2C driver

P2/SPIN2:
* p2-spin-standard-library

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)
* P2/SPIN2: FlexSpin (tested with 5.0.6-beta)
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* Very early in development - may malfunction, or outright fail to build

## TODO

- [x] Implement P2/SPIN2 driver
- [x] Implement calibration
- [x] Implement click detection
- [ ] Implement free-fall detection
- [ ] Add method to perform self-test
- [x] Add support for setting interrupt masks and reading flags
- [ ] Add 3-wire SPI driver variant
- [x] Add I2C driver variant (combined with SPI driver)
- [ ] Add support for temperature sensor
- [ ] Add support for auxilliary ADC
- [ ] Add support for interrupt pin

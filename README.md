# lis3dh-spin 
-------------

This is a P8X32A/Propeller driver object for the ST LIS3DH 3DoF accelerometer

## Salient Features

* SPI connection at up to 1MHz (P1), ~5MHz (P2)
* Read raw accelerometer data output
* Set output data rate
* Set full-scale range
* Enable per-axis output
* Flags to indicate data is ready, or has overrun
* Set calibration offsets

## Requirements

* P1/SPIN1: 1 extra core/cog for the PASM SPI driver
* P2/SPIN2: N/A

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)
* P2/SPIN2: FastSpin (tested with 4.1.4-beta)

## Limitations

* Very early in development - may malfunction, or outright fail to build

## TODO

- [x] Implement P2/SPIN2 driver
- [x] Implement calibration
- [ ] Add method to perform self-test
- [ ] Add support for setting interrupt masks and reading flags
- [ ] Add 3-wire SPI driver variant
- [ ] Add I2C driver variant
- [ ] Add support for temperature sensor
- [ ] Add support for auxilliary ADC

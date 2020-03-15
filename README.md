# lis3dh-spin 
-------------

This is a P8X32A/Propeller driver object for the ST LIS3DH 3DoF accelerometer

## Salient Features

* SPI connection at up to 1MHz (P1), _TBD_ (P2)
* Read raw accelerometer data output
* Set output data rate
* Set full-scale range
* Enable per-axis output

## Requirements

* P1/SPIN1: 1 extra core/cog for the PASM SPI driver

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)
* P2/SPIN2: FastSpin (tested with 4.1.4-beta)

## Limitations

* Very early in development - may malfunction, or outright fail to build
* Limitation 2

## TODO

- [ ] Task item 1
- [ ] Task item 2

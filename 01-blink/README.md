# 01: Blink

Toggles the LED every 27,000,000 clock cycles, which is once a second on the Tang Nano 20K's 27 MHz clock.

- `blink.v`: a 25-bit counter that flips the LED and resets when it hits 26,999,999
- `tangnano20k.cst`: pin constraints (clock on pin 4, LED on pin 15)

## Build

```
yosys -p "read_verilog blink.v; synth_gowin -top blink -json blink.json"
nextpnr-himbaechel --json blink.json --write pnr.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=tangnano20k.cst
gowin_pack -d GW2A-18C -o blink.fs pnr.json
openFPGALoader -b tangnano20k blink.fs
```

## What I learned

<!-- write a couple lines here -->

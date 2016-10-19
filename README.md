# Minimal VNC2 programmer

Let's use a low-cost FT232R 3.3V TTL usbserial
module (red PCB from ebay) as VNC2DEBUG module 
with a small help of FPGA.

![FT232R-usbserial](/pic/usb-ttl-ft232rl-pinout.png)

Using FT_PROG, reprogram the module with XML template file:
"VII Debugger Module v1.1.xml"

If FT_PROG can't change USB product name of the module
that module probably has counterfeit FTDI chip with read-only
EEPROM and it will not work.

If module changed its product name, launch v2prog windows 
application and make sure that it recognizes the module now
as V2DEBUG module.

# FPGA

Original V2DEBUG module uses 2 simple 3-state gates from 74LV124
to combine RX and TX with TXEN into single-wire DEBUG signal. 
FPGA in Reverse-U16 can be used instead of 74LV124.

    DEBUG <= TXD when TXEN='1' else 'Z';
    RXD <= DEBUG when TXEN='0' else 'Z';


# Connecting

On FT232R module set 5V/3.3V jumper into 3.3V position.
Programming circuit can be assembled from 10 color wires with 
female-female 1-pin sockets and a 10k resistor.

    Module FT232R USBSERIAL
    physical   chip   v2debug    10k                  program    wire
    label      pin    signal     pull   uBUS   pin    header     color
    ---------  ----   ------     ----   ----------    ---------  ------
                                        AN  X8   6    DEBUG  6   violet
    SLEEP      12     TXEN       down   AP  X8   4               brown
    TEN        13     PROG#                           PROG#  7   green
    PWREN      14     PWREN#       
    RXL        22     RESET#                          RESET# 8   blue
    TXL        23     TXRXLED#     
    RXD               RXD               DP  X10  4               gray
    TXD               TXD               DN  X10  3               white
    GND               GND               GND X10  2               black
    RTS         3     RTS               CTS
    CTS        11     CTS               RTS       
    DTR         2     DTR               RSD
    RSD         9     DSR               DTR

Connect on FT232R module (direct wires):

    RTS-CTS
    DTR-RSD (RSD is misnamed DSR)

Some pinouts on reverse-u16:

    --- edge of reverse-u16 board ---
    --- near power       --- near usb
    X8         X10       X3      
    ---------- -----     ------------------
    CP 1 5V  2 5V  1        GND 10 9  TDI     
    CN 3 AP  4 GND 2     RESET#  8 7  PROG#
    BP 5 AN  6 DN  3      DEBUG  6 5  TMS
    BN 7 GND 8 DP  4      +3.3V  4 3  TDO
                            GND  2 1  TCK

# Programming

First compile the FPGA 3-state DEBUG multiplexer:

    make clean; make

Upload it into the FPGA

    make program

While the ReVerSE-u16 board is constantly powered,
disconnect Altera-USB-blaster cable and connect VNC2
programming cable (it needs only 3 pins: PROG#, RESET# and DEBUG).

Launch V2PROG, select VNC2 ROM file and click "Program".
TX led will start blinking fast and messages will appear
in the window:

    Erasing Flash...
    Writing Flash...
    Done

In about half a minute it should be done.

# Troubleshooting

If programming win V2PROG won't start, try to run FT900 Programming 
utility first and then V2PROG. Maybe some pullup resistors are missing...

Pin labeled "SLEEP" (actually FTDI chip pin 12, TXEN) 
should be pulled down to GND with external 10k resistor.
It can work even without this resistor if you don't
mind retrying several times.

#PLL from 50MHZ to 100MHZ
create_clock -name "PLL100MHZ" -period 10 [get_ports CLOCK_50]
 
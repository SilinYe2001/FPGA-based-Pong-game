# FPGA-based-Pong-game
Implement Pong game on Altera DE2-115 board

Game example:![FPGA-based-Pong-game](doc/gameimage.png)
## Key features:
1. Hierarchical system structure design

   ### Flow and Components: ![FPGA-based-Pong-game](doc/flowchart.png)
   ### Source code:
   * Ps2: keyboard input signal capture, 3 speed signals for tank, 1 shoot signal for bullet.
   * Tank 1&2: tanks speed and coordinate control.
   * Bullet 1&2: bullets shooting control and score control.
   * Pixel_generator: generate pixels from tanks' and bullets' coordinates.
   * Start_signal: generate 25HZ start signal for tanks and Bullet FSM.
   * PLL: phase-locked loop to increase the system clock from 50MHZ to 100MHZ for tanks and bullets  FSM.
   * VGA_top_level: Top level module to 
   
3. Finite State Machine(FSM) controls tank movement and bullet movement
   
5. Phase-locked loop(PLL) implementation to improve clock frequency
6. Scripts for simulation automation

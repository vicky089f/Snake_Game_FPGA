# Snake Game on FPGA
 Snake game implemented on FPGA using VGA interface

## Introduction
The Video Graphics Array (VGA) is an analog video interface between a computer and a monitor, and it was very popular until the digital interfaces like DVI and HDMI started replacing it. The VGA cable has 15 pins of which only 5 are of interest to us: RED, GREEN, BLUE, HSYNC and VSYNC. RED, GREEN and BLUE are used to light the pixel with the desired colour, while HSYNC and VSYNC are synchronization signals given to the VGA monitor. When the raster beam reaches the right end of a line, the HSYNC pulse tells it to go to the next line and start displaying pixels again from the left end. When the raster beam reaches the bottom right corner of the screen, the VSYNC signal tells it to go back to the top left corner and start printing from the first pixel again.
### Movement of Raster beam
![](https://github.com/vicky089f/Snake_Game_FPGA/blob/main/Images/raster-scan.png)

### Display Area
![](https://github.com/vicky089f/Snake_Game_FPGA/blob/main/Images/display-timings.png)
The best application involving a VGA display is a game, and in particular the snake game was chosen for its moderately complex implementation. The HDL used was Verilog and the FPGA board used was Zync ZedBoard.

## Game Descriptiom
The game starts off with a snake of length 3 blocks present in the middle of the screen, and the user must press any of the 3 push buttons, RIGHT, UP or DOWN, to start the game. Since the snake is facing towards the right initially, it cannot move towards the left. The snake cannot move to the direction exactly opposite to the current direction of motion.
As the game progresses and the snake continues to eat the food, it keeps growing in length, and the maximum length it can reach is 15. The score, which depicts how many times the snake has eaten the food will be displayed using a VIO.
If the snake goes out of the right end of the screen, it will come in from the left end, and vice versa. And if it goes out of the bottom of the screen, it will come in from the top, and vice versa. For generating the next location of the food, a counter has been used which points to a random location at each clock cycle. So, when the snake eats the food, a new food block will be generated at the location pointed by the counter. Finally, if the snake collides into itself, the screen goes blue indicating that the game is over. The user can press the reset button to start over and play again.

## Snake FSM
### Stage Diagram
![](https://github.com/vicky089f/Snake_Game_FPGA/blob/main/Images/FSM.png)
```
Inputs tp FSM
 W: Button to move snake upward
 A: button to move the snake to the left
 S: button to move the snake downward
 D: button to move the snake to the right
 X: becomes 1 when the snake collides with itself

Outputs of FSM
 The state itself is the output. It is used to determine the direction of motion of the snake.
 The Over state signifies that the snake has collided with itself, and the game is over.
```

## FPGA Post-Implementation Reports
### Resource Utilization

### Power Consumption
![](https://github.com/vicky089f/Snake_Game_FPGA/blob/main/Images/Power.png)

### Timing Summary
![](https://github.com/vicky089f/Snake_Game_FPGA/blob/main/Images/Timing.png)

## Video of Snake Game
The game demo can be found here: [Demo](https://www.youtube.com/watch?v=zLEhHw5FrRo)

## References
1. https://projectf.io/posts/fpga-graphics/
2. http://www.cse.cuhk.edu.hk/~mcyang/ceng3430/2020S/Lec07%20Driving%20VGA%20Display%20with%20ZedBoard.pdf

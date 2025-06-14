# Tic-Tac-Toe Hardware Implementation in Verilog

A complete hardware implementation of Tic-Tac-Toe game logic using Verilog HDL, featuring modular design with custom cell modules and comprehensive game state management.

## Project Overview

This project implements a digital hardware version of the classic Tic-Tac-Toe game. Unlike software implementations, this design is optimized for FPGA/ASIC deployment and uses synchronous digital logic to manage game state, validate moves, and determine winners.

The implementation consists of two main components:
- **TCell**: Individual cell module representing each board position
- **TBox**: Main game controller that orchestrates the entire game

## Understanding the Problem

### Game Requirements
1. **3×3 Board Management**: Track the state of 9 individual cells
2. **Player Alternation**: Automatically switch between players (X and O)
3. **Move Validation**: Prevent overwriting occupied cells
4. **Win Detection**: Check for 3-in-a-row combinations (horizontal, vertical, diagonal)
5. **Game State Tracking**: Monitor if game is ongoing, won, or drawn
6. **Reset Capability**: Clear board and restart game

### Hardware Design Challenges
- **Synchronous Operation**: All updates must happen on clock edges
- **State Persistence**: Game state must remain stable between clock cycles
- **Combinational Logic**: Win detection and move validation must be instant
- **Resource Efficiency**: Minimize hardware resources while maintaining functionality

## Architecture Overview

### TCell Module Structure

The TCell module is the fundamental building block - each instance represents one cell of the 3×3 board.

```verilog
module TCell(
    input clk,           // System clock
    input set,           // Enable signal to place symbol
    input reset,         // Clear the cell
    input set_symbol,    // Symbol to place (1=X, 0=O)
    output reg valid,    // 1 if cell is occupied, 0 if empty
    output reg symbol    // The symbol stored (1=X, 0=O)
);

always @(posedge clk) begin
    // TODO: Implement synchronous reset logic (reset takes precedence)
    // TODO: Implement set logic (only if cell is empty)
    // TODO: Maintain state if neither reset nor valid set
end

endmodule
```

**Key Design Points:**
- **Synchronous Reset**: Reset only takes effect on clock edge
- **Write Protection**: Cannot overwrite occupied cells
- **Priority Logic**: Reset has higher priority than set operation

### TBox Module Structure

The TBox module integrates 9 TCell instances and implements the game logic.

```verilog
module TBox(
    input clk,
    input set,
    input reset,
    input [1:0] row,        // Row coordinate (1-3)
    input [1:0] col,        // Column coordinate (1-3)
    output [8:0] valid,     // Validity of all 9 cells
    output [8:0] symbol,    // Symbols in all 9 cells
    output [1:0] game_state // Current game state
);

// Internal signal declarations
wire [3:0] cell_index;      // Selected cell (0-8)
wire current_player;        // Current player's symbol
wire [8:0] cell_set;        // Set signals for each cell
wire game_active;           // Game is still ongoing
wire x_wins, o_wins, is_draw;

// TODO: Convert 2D coordinates to 1D cell index
// Hint: cell_index = (row - 1) * 3 + (col - 1)

// TODO: Determine current player based on number of occupied cells
// Hint: Count total occupied cells, even count = X turn, odd count = O turn

// TODO: Check if game is still active (no winner, not draw)

// TODO: Generate set signals for each of the 9 cells
// Hint: Use generate loop to create cell_set[i] for each cell

// TODO: Instantiate 9 TCell modules using generate loop

// TODO: Implement win detection logic for X
// Check all 8 winning combinations (3 rows, 3 columns, 2 diagonals)

// TODO: Implement win detection logic for O
// Similar to X but check for symbol = 0

// TODO: Implement draw detection
// All cells valid AND no winner

// TODO: Assign final game_state based on win/draw conditions

endmodule
```

## Game State Machine

| State Code | State Name | Description |
|------------|------------|-------------|
| `2'b00` | GAME_ACTIVE | Game is ongoing, accepting moves |
| `2'b01` | X_WINS | Player X has won |
| `2'b10` | O_WINS | Player O has won |
| `2'b11` | DRAW | All cells filled, no winner |

## Board Coordinate System

The game uses 1-indexed coordinates for intuitive player interaction:

```
     Column
     1   2   3
   ┌───┬───┬───┐
1  │ 0 │ 1 │ 2 │
   ├───┼───┼───┤
2  │ 3 │ 4 │ 5 │  Row
   ├───┼───┼───┤
3  │ 6 │ 7 │ 8 │
   └───┴───┴───┘
```

**Coordinate to Cell Index Conversion:**
```
cell_index = (row - 1) * 3 + (col - 1)
```

## Implementation Strategy

### Step 1: Implement TCell Module
1. **Basic Structure**: Set up the module with proper I/O
2. **Synchronous Logic**: Implement always block with posedge clk
3. **Reset Logic**: Handle synchronous reset with proper precedence
4. **Set Logic**: Allow setting only when cell is empty
5. **State Maintenance**: Keep current values when no operation

### Step 2: Build TBox Framework
1. **Module Declaration**: Set up all inputs and outputs
2. **Internal Signals**: Declare necessary wires and regs
3. **Coordinate Conversion**: Implement row/col to cell_index mapping
4. **Cell Instantiation**: Use generate loops to create 9 TCell instances

### Step 3: Add Player Management
1. **Turn Tracking**: Determine current player based on occupied cells
2. **Move Validation**: Ensure moves only happen when game is active
3. **Cell Selection**: Route set signal to correct cell based on coordinates

### Step 4: Implement Game Logic
1. **Win Detection**: Create logic for all 8 winning combinations
2. **Draw Detection**: Check if board is full with no winner
3. **Game State**: Combine win/draw logic to set game_state output
4. **Game Lockout**: Prevent further moves after game completion

## Key Implementation Hints

### TCell Module
```verilog
// Reset has priority over set
if (reset) begin
    // Clear the cell
end
else if (set && !valid) begin
    // Set the cell only if empty
end
// Otherwise maintain current state
```

### Current Player Logic
```verilog
// Count occupied cells to determine turn
wire [3:0] occupied_count;
// Sum all valid bits
// Even count = X's turn, odd count = O's turn
```

### Win Detection Pattern
```verilog
// Example for one winning combination (top row for X)
wire top_row_x = valid[0] && valid[1] && valid[2] && 
                 symbol[0] && symbol[1] && symbol[2];

// Repeat for all 8 combinations for both X and O
```

### Cell Selection Logic
```verilog
// Use generate loop to create set signals
genvar i;
generate
    for (i = 0; i < 9; i = i + 1) begin
        assign cell_set[i] = /* condition for selecting cell i */;
    end
endgenerate
```

## Testing Strategy

### Basic Test Sequence
1. **Reset Test**: Verify all cells clear on reset
2. **Single Move**: Test placing X in center
3. **Alternating Players**: Verify X and O alternate
4. **Invalid Move**: Try to overwrite occupied cell
5. **Win Condition**: Create a winning line
6. **Draw Condition**: Fill board without winner
7. **Post-Game**: Verify no moves accepted after completion

### Testbench Structure
```verilog
module tb_tictactoe;
    // Signal declarations
    reg clk, set, reset;
    reg [1:0] row, col;
    wire [8:0] valid, symbol;
    wire [1:0] game_state;
    
    // Module instantiation
    TBox dut (/* connections */);
    
    // Clock generation
    // Test sequence
    // Helper tasks for moves and checking
endmodule
```

## Common Pitfalls to Avoid

1. **Coordinate System**: Remember 1-indexed input, 0-indexed internal
2. **Reset Priority**: Always check reset before other conditions
3. **Game State Logic**: Ensure game locks after win/draw
4. **Player Turn**: Base on total moves, not last player
5. **Win Logic**: Check both valid AND symbol bits
6. **Generate Loops**: Use proper indexing in generated instances

## Debugging Tips

### Signal Monitoring
- Watch `game_state` for state transitions
- Monitor `valid` and `symbol` arrays for board state
- Check `current_player` for turn alternation
- Observe individual cell `set` signals

### Common Debug Scenarios
- **Moves not registering**: Check coordinate conversion and cell selection
- **Wrong player symbol**: Verify current_player calculation
- **Game not ending**: Debug win detection logic
- **Invalid moves accepted**: Check game_active and cell validity


## File Organization

```
tic-tac-toe-verilog/
├── src/
│   ├── TCell.v           # Individual cell module
│   └── TBox.v            # Main game controller
├── tb/
│   ├── tb_TCell.v        # TCell testbench
│   └── tb_TBox.v         # Complete game testbench
└── README.md             # This documentation
```
Use the test benches available to test the modules.(You can download the test benches and add your own test cases!)

The finished design will be a fully functional hardware Tic-Tac-Toe game ready for FPGA implementation!

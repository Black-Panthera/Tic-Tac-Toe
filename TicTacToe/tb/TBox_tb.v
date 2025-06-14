`include "TBox.v"
`timescale 1ns / 1ns

module tb_TicTacToe;
    reg clk, set, reset;
    reg [1:0] row, col;
    wire [8:0] valid, symbol;
    wire [1:0] game_state;

    // Instantiate the main TBox module
    TBox uut (
        .clk(clk),
        .set(set),
        .reset(reset),
        .row(row),
        .col(col),
        .valid(valid),
        .symbol(symbol),
        .game_state(game_state)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to perform a move by setting row and col
    task make_move(input [1:0] t_row, input [1:0] t_col);
        begin
            set <= 1;
            row <= t_row;
            col <= t_col;
            #10;
            set = 0;
            #10;
        end
    endtask

    // Task to reset the board
    task reset_board;
        begin
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
    endtask

    // Task to display the current game state
    task check_game_state(input[1:0] game_state);
        begin
            case (game_state)
                2'b01: $display("Player X wins!");
                2'b10: $display("Player O wins!");
                2'b11: $display("It's a draw!");
                2'b00: $display("Game in progress");
                default: $display("Unknown state");
            endcase
        end
    endtask

    // Test sequence
    initial begin
        $dumpfile("tb_TicTacToe.vcd");
        $dumpvars(0,tb_TicTacToe);
        // Test 1: Row win (Player X wins)
        $display("Test 1: Row Win");
        reset_board();
        make_move(2'b01, 2'b01); // X: Top-left
        make_move(2'b10, 2'b01); // O: Middle-left
        make_move(2'b01, 2'b10); // X: Top-center
        make_move(2'b10, 2'b10); // O: Middle-center
        make_move(2'b01, 2'b11); // X: Top-right (Win)
        #10;
        check_game_state(game_state);

        // Test 2: Column win (Player X wins)
        $display("Test 2: Column Win");
        reset_board();
        make_move(2'b01, 2'b01); // X: Top-left
        make_move(2'b01, 2'b10); // O: Top-center
        make_move(2'b10, 2'b01); // X: Middle-left
        make_move(2'b10, 2'b10); // O: Middle-center
        make_move(2'b11, 2'b01); // X: Bottom-left (Win)
        make_move(2'b11, 2'b10); // O: Bottom-center 
        #10;
        check_game_state(game_state);

        // Test 3: Diagonal win (Player X wins)
        $display("Test 3: Diagonal Win");
        reset_board();
        make_move(2'b01, 2'b01); // X: Top-left
        make_move(2'b01, 2'b10); // O: Top-center
        make_move(2'b10, 2'b10); // X: Center (Diagonal)
        make_move(2'b10, 2'b01); // O: Middle-left
        make_move(2'b11, 2'b11); // X: Bottom-right (Win)
        #10;
        check_game_state(game_state);

        // Test 4: Anti- Diagonal win (Player O wins)
        $display("Test 4:Anti Diagonal Win");
        reset_board();
        make_move(2'b01, 2'b01); // X: Top-left
        make_move(2'b01, 2'b11); // O: Top-right
        make_move(2'b10, 2'b11); // X: Center-right
        make_move(2'b10, 2'b10); // O: Center
        make_move(2'b11, 2'b10); // X: Bottom-center
        make_move(2'b11, 2'b01); // O: Bottom-left (Win)
        #10;
        check_game_state(game_state);

         $display("Test 5: Game on");
        reset_board();
        make_move(2'b01, 2'b11); // X: Top-right
        make_move(2'b01, 2'b01); // O: Top-left
        make_move(2'b10, 2'b11); // X: Center-right
        make_move(2'b10, 2'b10); // O: Center
        make_move(2'b11, 2'b10); // X: Bottom-center
        make_move(2'b11, 2'b01); // O: Bottom-left 
        #10;
        check_game_state(game_state);

        // Test 6: Draw condition
        $display("Test 6: Draw");
        reset_board();
        make_move(2'b01, 2'b01); // X: Top-left
        make_move(2'b01, 2'b10); // O: Top-center
        make_move(2'b01, 2'b11); // X: Top-right
        make_move(2'b10, 2'b01); // O: Center-left
        make_move(2'b10, 2'b11); // X: Center-right
        make_move(2'b10, 2'b10); // O: Center
        make_move(2'b11, 2'b10); // X: Bottom-center
        make_move(2'b11, 2'b11); // O: Bottom-right
        make_move(2'b11, 2'b01); // X: Bottom-left (Draw)
        #10;
        check_game_state(game_state);

        // End simulation
        #20;
        $stop;
    end
endmodule
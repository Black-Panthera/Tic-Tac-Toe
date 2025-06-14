`include "TCell.v"

module TBox(input clk, set, reset, input [1:0] row, input [1:0] col,
output [8:0] valid, output [8:0] symbol, output [1:0] game_state);
    
wire set_symbol;


wire [8:0] setter;


assign setter[0]= ~row[1] &  row[0] & ~col[1] &  col[0] & set ;
assign setter[1]= ~row[1] &  row[0] &  col[1] & ~col[0] & set ;
assign setter[2]= ~row[1] &  row[0] &  col[1] &  col[0] & set ;
assign setter[3]=  row[1] & ~row[0] & ~col[1] &  col[0] & set ;
assign setter[4]=  row[1] & ~row[0] &  col[1] & ~col[0] & set ;
assign setter[5]=  row[1] & ~row[0] &  col[1] &  col[0] & set ;
assign setter[6]=  row[1] &  row[0] & ~col[1] &  col[0] & set ;
assign setter[7]=  row[1] &  row[0] &  col[1] & ~col[0] & set ;
assign setter[8]=  row[1] &  row[0] &  col[1] &  col[0] & set ;

curr_set_symbol css(clk,reset,valid,set_symbol);

TCell cells [8:0] (clk, setter, reset, set_symbol, valid, symbol);

wire [1:0] pg;
 
check_win checker(clk,valid,symbol,reset,game_state);

endmodule



module check_win(input clk, input [8:0] valid,input [8:0] symbol,input res,  output reg [1:0]cg);
initial begin
    cg<=2'b00;
end
reg row1valid,row2valid,row3valid;
reg state;
reg col1valid,col2valid,col3valid;
reg dia1valid,dia2valid;


always @(posedge clk) begin
    if(res) begin
        cg<=2'b00;
    end
    else if(~cg[1]&&~cg[0]) begin
         row1valid = valid[0] & valid[1] & valid[2];
         row2valid = valid[3] & valid[4] & valid[5];
         row3valid = valid[6] & valid[7] & valid[8];
         state = row1valid & row2valid & row3valid;
         col1valid = valid[0] & valid[3] & valid[6];
         col2valid = valid[1] & valid[4] & valid[7];
         col3valid = valid[2] & valid[5] & valid[8];
         dia1valid = valid[0] & valid[4] & valid[8];
         dia2valid = valid[2] & valid[4] & valid[6];

        if(row1valid && (symbol[0]==symbol[1]) && (symbol[1]==symbol[2]) ) begin
                // $display("row1");
                cg[0]<= symbol[0];
                cg[1]<= ~symbol[0];
  end

 else  if(row2valid && (symbol[3]==symbol[4]) && (symbol[4]==symbol[5]) ) begin
             // $display("row2");
                cg[0]<= symbol[3];
                cg[1]<= ~symbol[3];
    end

else  if(row3valid && (symbol[6]==symbol[7]) && (symbol[7]==symbol[8])) begin
            // $display("row3");
                cg[0]<= symbol[6];
                cg[1]<= ~symbol[6];
  end
   
else  if(col1valid && (symbol[0]==symbol[3]) && (symbol[3]==symbol[6])) begin
            // $display("col1");
                cg[0]<= symbol[3];
                cg[1]<= ~symbol[3];
  end

 else  if(col2valid && (symbol[1]==symbol[4]) && (symbol[4]==symbol[7])) begin
               // $display("col2");
                cg[0]<= symbol[1];
                cg[1]<= ~symbol[1];
    end

 else  if(col3valid && (symbol[2]==symbol[5]) && (symbol[5]==symbol[8])) begin
         // $display("col3");
                cg[0]<= symbol[2];
                cg[1]<= ~symbol[2];
    end

 else   if(dia1valid && (symbol[0]==symbol[4]) && (symbol[4]==symbol[8])) begin
                // $display("dia1");
                cg[0]<= symbol[0];
                cg[1]<= ~symbol[0];
    end

 else   if(dia2valid && (symbol[2]==symbol[4]) && (symbol[4]==symbol[6])) begin
                // $display("dia2");
                cg[0]<= symbol[2];
                cg[1]<= ~symbol[2];
    end
 else  if(state==1'b1) begin
    // $display("draw");
        cg<=2'b11;
    end
    end
    end

endmodule

module curr_set_symbol(input clk, input reset, input [8:0] valid, output reg ss);

wire a,b,c;
xor(a,valid[0],valid[1],valid[2]);
xor(b,valid[3],valid[4],valid[5]);
xor(c,valid[6],valid[7],valid[8]);

wire valid_count;

xor(valid_count,a,b,c);

initial begin
    ss<=1'b1;
end

always @(posedge clk) begin
    if(reset) begin
        ss<=1'b1;
    end
   else begin if(valid_count==1'b1) begin
        ss<=1'b0;
    end
    else begin
        ss<=1'b1;
    end
end
end
endmodule
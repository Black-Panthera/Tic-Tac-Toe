 `include "edge_detector.v"
 module TCell(input clk,input  set,input  reset, input set_symbol, output reg valid,output reg symbol);

wire clkedge;
edge_detector clktrigger(clk,clkedge);

initial begin
    valid=1'b0;
end

always @(*) begin
    if(clkedge==1'b1) begin
        if(reset==1'b1) begin
            valid=1'b0;
        end
        else begin
            if(set==1'b1) begin
                if(valid==1'b0) begin
                    valid=1'b1;
                    symbol= set_symbol;
                end
            end
        end
    end
end

endmodule
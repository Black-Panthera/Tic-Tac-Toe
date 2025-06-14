module edge_detector(input i,output o);

wire t;
not(t,i);

and(o,i,t);

endmodule
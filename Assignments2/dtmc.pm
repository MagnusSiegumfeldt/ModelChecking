dtmc 

module DTMC

s : [0..3] init 0;

[] s = 0 -> 0.6:(s'=3) + 0.4:(s'=1);
[] s = 1 -> 0.5:(s'=2) + 0.5:(s'=1);
[] s = 2 -> 0.4:(s'=0) + 0.4:(s'=3) + 0.2:(s'=2);
[] s = 3 -> (s'=2);


endmodule
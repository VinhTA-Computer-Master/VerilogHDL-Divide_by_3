/* Description: A divide-by-3 logic using behavioral Verilog. 
 * Author: Vinh TA
 */


// 1-bit divider module

module divide1(input X, input [1:0] Yin, output Z, output [1:0] f);
  reg Z;
  reg [2:0] out;
  wire [2:0] Yout;
  reg [1:0] f;
  assign Yout[2:1]=Yin[1:0];
  assign Yout[0]=X;

  always@(*)
    begin
    out=Yout;
    if(out>=3)
      begin
      Z=1;
      out=out-3;
      end
    else
      Z=0;
    f=out[1:0];
    end
endmodule


// N-bit parameterized divider module

module divideN #(parameter integer WIDTH=4) 
(input [WIDTH-1:0] X, input [1:0] in, output [WIDTH-1:0] Z, output [1:0] out);

  wire [WIDTH-1:0] [1:0] Yin,Yout;
  divide1 g1 [WIDTH-1:0] (X,Yin,Z,Yout);
  assign Yin[WIDTH-1]=in;
  assign Yin[WIDTH-2:0]=Yout[WIDTH-1:1];
  assign out=Yout[0];
endmodule



// Testbench for N-bit divider

module tb;
  parameter integer WIDTH=6;
  reg [WIDTH-1:0] X=6'b0;
  reg [1:0] in=2'b0;
  wire [WIDTH-1:0] Z;
  wire [1:0] out;
  divideN #(.WIDTH(WIDTH)) g1(X,in,Z,out);

  initial
  begin
    repeat(63)
      #15 X=X+1;
  end

  initial
      $monitor("X=%d, quotient=%d, remainder=%d @ time=%d", X,Z,out,$time);

endmodule

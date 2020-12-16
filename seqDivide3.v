/* Description: A sequential divide-by-3 logic circuit using Verilog.
 * Author: Vinh TA
 */

module clk(output clk);
  reg clk=0;
  always@(clk)
    #10 clk<=~clk;
endmodule

module div3 #(parameter integer WIDTH=4) 
  (input [WIDTH-1:0] X, output Q2,Q1,Q0, output [WIDTH-1:0] Z);
  reg Q2N, Q1N, Q0N;
  reg [WIDTH-1:0] Z;
  reg Q2=0,Q1=0,Q0=0;
  wire [WIDTH-1:0] X;
  wire clk;
  clk g1(clk);
  reg [WIDTH-1:0] i=WIDTH-1;

  always@(clk)
    if(i>0)
      #2 i=i-1;
    else
      $finish;

  always@(i)
  begin
    Q2N = (~X[i]&&Q1)||(X[i]&&Q2);
    Q1N = (~X[i]&&Q2)||(X[i]&&~Q2&&~Q1);
    Q0N = (X[i]&&Q1)||Q2;
  end

  always@(*)
  begin
    Q2 <= Q2N;
    Q1 <= Q1N;
    Q0 <= Q0N;
  end

  always@(*)
    Z[i] = Q0;
endmodule


module tb;
  parameter integer WIDTH = 10;
  reg [WIDTH-1:0] X=10'b1101010000;
  wire [WIDTH-1:0] Z;
  wire [2:0] Q;
  div3 #(.WIDTH(WIDTH)) g1(X,Q[2],Q[1],Q[0],Z);
   
  initial
    $monitor("X=%b, Z=%b, Remainder=%b @ time=%d",X,Z,Q[2:1],$time);
endmodule
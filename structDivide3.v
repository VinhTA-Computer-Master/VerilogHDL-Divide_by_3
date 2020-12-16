/* Description: A divide-by-3 logic using structural Verilog
 * Author: Vinh TA
 */

module fullAdder(input A,B,cin, output cout,S);
  wire A,B,cin;
  wire AxorB, a1,a2;
  wire S, cout;
  XOR2X1 g1 (A,AxorB,B);
  XOR2X1 g2 (AxorB,S,cin);
  AND2X1 g3 (cin,AxorB,a1);
  AND2X1 g4 (A,B,a2);
  OR2X1 g5 (a1,a2,cout);
endmodule


module sub3(input [2:0] X, output [1:0] Z);
  reg [2:0] Bcomp=3'b101;
  reg c0=0;
  wire Z;
  wire [2:0] S,cin,carry;
  fullAdder g1 [2:0] (.A(X),.B(Bcomp),.cin(cin),.cout(carry),.S(S));
  assign cin[0] = c0;
  assign cin[2:1] = carry[1:0];
  assign Z=S[1:0];
endmodule

module divide1(input X, input [1:0] Yin, output Z, output [1:0] Yout);

  wire Z;
  wire [2:0] Rem;
  wire [1:0] Temp; 
  wire [1:0] TempR;
  assign Z = Yin[1]||(X&&Yin[0]);
  assign Rem[2:1] = Yin;
  assign Rem[0] = X;
  sub3 g1(.X(Rem),.Z(Temp));  // Temp-=3
  assign TempR[1] = Yin[0];
  assign TempR[0] = X;
  MUX2X1 g2 [1:0] (.A(Temp),.Y(Yout),.S(Z),.B(TempR));
endmodule



// N-bit parameterized divider

module divideN #(parameter integer WIDTH=4)
(input [WIDTH-1:0] X, input [1:0] in, output [WIDTH-1:0] Z, output [1:0] out);

  wire [WIDTH-1:0] [1:0] Yin,Yout;
  divide1 g1 [WIDTH-1:0] (X,Yin,Z,Yout);
  assign Yin[WIDTH-1]=in;
  assign Yin[WIDTH-2:0]=Yout[WIDTH-1:1];
  assign out=Yout[0];
endmodule


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
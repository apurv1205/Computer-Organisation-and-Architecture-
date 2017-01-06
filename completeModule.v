/*Test Bench*/
module tb;

	// Inputs
	reg [7:0] sw1;
	reg [7:0] sw2;
	reg clk;

	// Outputs
	wire [15:0] Z;
	wire over;
	wire [4:0] state;
 
	// Instantiate the Unit Under Test (UUT)
	topModule_group10 uut ( 
		.sw1(sw1), 
		.sw2(sw2), 
		.Z(Z), 
		.clk1(clk), 
		.over(over),.state(state)
	);
 
	initial begin
		sw1 = 1;
		sw2 = 1;
		clk = 0; 

		// Wait 100 ns for global reset to finish
		#100;
    
		  end
		always begin
		#2;
		clk=~clk;
		end

      
endmodule

/************************************************************************************************************************/
/*top module*/

module topModule_group10(input[15:0] sw1,input [15:0] sw2,output[15:0] Z,input clk1,output over,output[4:0] state
    );
integer count=0;
reg clk=0;
integer counter=0;

always @(posedge clk1)
begin
if(counter==1) begin
clk=~clk;
counter=0;
end
else
counter=counter+1;
end
reg go=0;
always@(posedge clk) begin
count=count+1;
if(count==1) begin
go=~go;
count =0;
end
end
wire x,y,z,ldcount,tcount,tsw1,ta,lda,tx,ldx,ty,ldy,tz,ldz,tb,ldb,tone,tsw2,bo;
wire[3:0] f;
datapath_group10 datapath(.clk(clk),.sw1(sw1),.sw2(sw2),.ldcount(ldcount),.tcount(tcount),.tsw1(tsw1),.ta(ta),.lda(lda),.ldx(ldx),.tx(tx),.ty(ty),.ldy(ldy),.tz(tz),.ldz(ldz),.tb(tb),.ldb(ldb),.tone(tone),.tsw2(tsw2),.f(f),.bo(bo),.Z(Z),.x(x),.y(y),.z1(z));
controller_gr10 controller(.state(state),.go(go),.clk(clk),.bo(bo),.over(over),.f(f),.ldcount(ldcount),.tcount(tcount),.tsw1(tsw1),.ta(ta),.lda(lda),.tx(tx),.ldx(ldx),.ty(ty),.ldy(ldy),.tz(tz),.ldz(ldz),.tb(tb),.ldb(ldb),.tone(tone),.tsw2(tsw2)
    ,.x(x),.y(y),.z(z));
endmodule

/*********************************************************************************************************************/
/*datapath*/
module register_1bit(output reg [15:0] rg,input[15:0] in,output reg[15:0] out,input t,input ld);
initial rg=0;
always@* begin
if(t==1) out=rg;
else out=0;
if(ld==1) rg=in;
end
endmodule

module register_3bit(input[15:0] in,output reg[15:0] out,input t,input ld);
reg [15:0] rg=0;
always@* begin
if(t==1) out=rg;
else out=0;
if(ld==1) rg=in;
end
endmodule

module register_16bit(input[15:0] in,output reg[15:0] out,input t,input ld);
reg[15:0] rg=0;
always@* begin
if(t==1) out=rg;
else out=0;
if(ld==1) rg=in;
end
endmodule

module datapath_group10(
    input clk,input[15:0] sw1,input[15:0] sw2,input ldcount,input tcount,input tsw1,input ta,input lda,input ldx,input tx,input ty,input ldy,input tz,input ldz,input tb,input ldb,input tone,input tsw2,input [3:0] f,output bo,output[15:0] Z,output[15:0] x,output[15:0] y,output[15:0] z1);
reg[15:0] X,Y;
wire[15:0] X1,X2,X3,X4,Y1,Y2,Y3,Y4,Y5;
always@(*)begin
X=X1|X2|X3|X4;
Y=Y1|Y2|Y3|Y4|Y5;
end 

register_16bit SW1(.in(sw1<<8),.out(X1),.ld(1),.t(tsw1));
register_16bit A(.in(Z),.out(X3),.ld(lda),.t(ta));
register_1bit one(.in(1),.out(X2),.ld(1),.t(tone));
register_1bit x1(.rg(x),.in(Z),.out(X4),.ld(ldx),.t(tx));
 
register_1bit y1(.rg(y),.in(Z),.out(Y1),.ld(ldy),.t(ty));
register_1bit z12(.rg(z1),.in(Z),.out(Y2),.ld(ldz),.t(tz));
register_16bit B(.in(Z),.out(Y3),.ld(ldb),.t(tb));
register_3bit count(.in(Z),.out(Y4),.ld(ldcount),.t(tcount));
register_16bit SW2(.in((sw2<<8)>>8),.out(Y5),.ld(1),.t(tsw2));

ALU_group10 ALU(.X(X),.Y(Y),.clk(clk),.Z(Z),.f(f),.bo(bo));
endmodule
/***********************************************************************************************************************/
/*controller*/



module controller_gr10(input go,input clk,input bo,output reg over,output reg [3:0] f,output reg ldcount,output reg tcount,output reg tsw1,output reg ta,output reg lda,output reg tx,output reg ldx,output reg ty,output reg ldy,output reg tz,output reg ldz,output reg tb,output reg ldb,output reg tone,output reg tsw2
    ,input[15:0] x,input[15:0] y,input[15:0] z,output reg [4:0] state);
initial begin
 over=0;
state=0;
end
reg [2:0] xyz;
integer i=0;
always@(negedge clk)
begin
if(state==0)
begin
     if(go==1)
	     state=1;
	  else
        state=0;	  
end
else if(state==1)
begin
     if(go==1)
	     state=1;
	  else
        state=2;
		  
end
else if(state==2)
begin
     if(go==1)
	     state=3;
	  else
        state=2;	  
end
else if(state==3)
begin
     if(go==1)
	     state=3;
	  else
        state=4;	  
end
else if(state==4)
begin
     if(go==1)
	     state=5;
	  else
        state=4;	  
end
else if(state==5)
begin
     if(go==1)
	     state=5;
	  else
        state=6;	  
end
else if(state==6)
begin
     if(go==1)
	     state=7;
	  else
        state=6;	  
end
else if(state==7)
begin
     if(go==1)
	     state=7;
	  else
        state=8;	  
end
else if(state==8)
begin
	xyz[0]=z[0];
	xyz[1]=y[0];
	xyz[2]=x[0];
     if(xyz==3)
	     state=9;
	  else if(xyz==1||xyz==2)
        state=10;
      else if(xyz==0||xyz==7)
        state=13;
     else if(xyz==5||xyz==6)
        state=11;
     else
        state=12;	  
end
else if(state==9)
begin
     state=13;	  
end
else if(state==10)
     state=13;
else if(state==11)
     state=13;
else if(state==12)
     state=13;	  
else if(state==13)
      state=14;
else if(state==14)
      state=15;
else if(state==15)
      state=16;
else if(state==16)
      state=17;
else if(state==17) state=18;
else if(state==18)
      begin
            if(bo==0)
				   state=8;
				else
               state=19;				
      end		
else
    state=19;

case(state)
0	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=0;
		tsw2=0;
		f=0;
		over=0;
		end 
1	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=1;
		ta=0;
		lda=1;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=0;
		tsw2=0;
		f=0;
		end	
2	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=1;
		tone=0;
		tsw2=1;
		f=1;
		end		
3	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=1;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=9;
		end
4	:begin 
	ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=1;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=9;
		end		
 5	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=1;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=8;
		end
6	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=1;
		tb=0;
		ldb=0;
		tone=0;
		tsw2=0;
		f=12;
		end
7	:begin 
		ldcount=1;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=0;
		tsw2=0;
		f=2;
		end
8	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=1;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=0;
		tsw2=0;
		f=0;
		end	
9	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=1;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=1;
		tone=0;
		tsw2=0;
		f=6;
		end
10	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=1;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=1;
		tone=0;
		tsw2=0;
		f=5;
		end	
11	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=1;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=1;
		tone=0;
		tsw2=0;
		f=3;
		end
12	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=1;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=1;
		tone=0;
		tsw2=0;
		f=4;
		end
13	:begin 
		ldcount=1;
		tcount= 1;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=1;
		tsw2=0;
		f=4;
		end	
14	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=1;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=11;
		end
15	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=1;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=10;
		end	
16	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=1;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=9;
		end
17	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=1;
		tone=0;
		tsw2=0;
		f=7;
		end		
18	:begin 
		ldcount=0;
		tcount= 1;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=0;
		ldb=0;
		tone=1;
		tsw2=0;
		f=3;
		end
19	:begin 
		ldcount=0;
		tcount= 0;
		tsw1=0;
		ta=0;
		lda=0;
		tx=0;
		ldx=0;
		ty=0;
		ldy=0;
		tz=0;
		ldz=0;
		tb=1;
		ldb=0;
		tone=0;
		tsw2=0;
		f=1;
		over=1;
		end		
endcase
	 
end
endmodule
/************************************************************************************************************************/
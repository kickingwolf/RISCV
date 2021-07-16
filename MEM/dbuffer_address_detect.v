`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:47 05/17/2021 
// Design Name: 
// Module Name:    dbuffer_address_detect 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`include "../parameter/define.vh"
module dbuffer_address_detect(

input [31:0] address,           //�����ַ
input [1:0]  func2,          //�����ж�ָ������,func3�����Ϊ���ж�ʱ����Ҫ��

input        load,              
input        store,

output       er_load_n,  // load_nonalign loadʱ�Ƕ���
output       er_load_c,  // load_crossborder loadʱ��ַԽ��
output       er_store_n, //storeʱ�Ƕ���
output       er_store_c, //storeʱ��ַԽ��

output       addr_ok ,  //��ַ���� 
output       load_error //��ַ���쳣������һ������֪�õ�ַ����Ҫд���������ģ��
);

wire error_nonalign_1;
wire error_crossborder_1;
assign error_nonalign_1 = ((!func2[1] &  func2[0] &  address[0])           //half
				         |( func2[1] & !func2[0] & (address[1] | address[0])));//word,��ַ�ĺ���λֻҪ��һ��1�����1������0ʱ���쳣
assign error_crossborder_1 = !((`D_BASE_ADDR == address[31:10]) | ((/*`D_BASE_ADDR[21:1]*/21'b0 == address[31:11]) & (address[9:8]==2'b00))); //�û���ַ���ַ��λ���бȽϣ��������Խ�����1�������Խ�����0
						 

assign er_load_n =  error_nonalign_1    & load;
assign er_load_c =  error_crossborder_1 & load;
assign er_store_n = error_nonalign_1    & store;
assign er_store_c = error_crossborder_1 & store;

assign load_error =(error_nonalign_1 | error_crossborder_1 ) & load ;

assign addr_ok = (~(error_nonalign_1 | error_crossborder_1 )) & ( load | store );//��ַû���쳣


endmodule

/*always @(*)       
 begin
  case(func3)
     3'b000 : error_nonalign <= 1'b0;                               //loadfunc=000��100ʱ��lb��lbu���߽�һ�����롣
	 3'b100 : error_nonalign <= 1'b0;
	 3'b001 : begin                                                 //loadfunc=001��101ʱ��lh��lhu�����λΪ0ʱ����
	             if (address[0]) error_nonalign <= 1'b1;
			     else            error_nonalign <= 1'b0;
			end
	 3'b101 : begin 
	             if (address[0]) error_nonalign <= 1'b1;
			     else            error_nonalign <= 1'b0;
			  end
	 3'b010 : begin                                                 //loadfunc=010ʱ��lw������λ��Ϊ0ʱ����
	             if      (address[1:0] == 2'b00) error_nonalign <= 1'b0;
			     else if (address[1:0] == 2'b01) error_nonalign <= 1'b1;
			     else if (address[1:0] == 2'b10) error_nonalign <= 1'b1;
			     else    (address[1:0] == 2'b11) error_nonalign <= 1'b1;
			    end
	 default : error_nonalign <= 1'b0 ;
  endcase
 end */
 
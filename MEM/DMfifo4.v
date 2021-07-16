`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:04:06 05/20/2021 
// Design Name: 
// Module Name:    DMfifo4 
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
module DMfifo4(
     input clk,
     input rst_n,
     input  [73:0] fifo_data_in,
     input fifo_wr_en,
 
     input fifo_rd_en,
     output  [73:0] fifo_data_out,
     output reg fifo_empty,
     output reg fifo_full
);  



reg [73:0] ram [0:3];//�洢��
reg [1:0]rp,wp;//�����дָ��
//д������din
always@(posedge clk or negedge rst_n)  
   begin
	 if(!rst_n)
	 begin
	 ram[0] <= 74'b0;
	 ram[1] <= 74'b0;
	 ram[2] <= 74'b0;
	 ram[3] <= 74'b0;
	 end
	 else if((fifo_wr_en & ~fifo_full) || (fifo_full & fifo_wr_en & fifo_rd_en))// ����ʱ��д�� ���� ����ʱ��ͬʱ��д
      begin
      ram[wp]<= fifo_data_in;
      end
   end
//��������dout
assign fifo_data_out = (/*fifo_rd_en &*/ ~fifo_empty)?ram[rp]:74'b0; //����ʱ�ɶ� 
//дָ��wp
always@(posedge clk or negedge rst_n)
   begin
      if(!rst_n)begin
      wp <= 1'b0;
				end
	else if(fifo_wr_en & ~fifo_full) begin//����ʱ��дָ��+1
		wp <= wp + 1'b1;
							end
	else if(fifo_full && (fifo_wr_en & fifo_rd_en)) begin
		wp <= wp + 1'b1;
									end
end
//��ָ��rp
always@(posedge clk or negedge rst_n) 
	begin
		if(!rst_n) begin
		rp <= 1'b0;
				end
	else if(fifo_rd_en & ~fifo_empty) begin
		rp <= rp + 1'b1;
							end
	end
//����־full
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
		fifo_full <= 1'b0;
			end
		else if((fifo_wr_en & ~fifo_rd_en) && (wp == rp + 2'b11)) begin
		fifo_full <= 1'b1;
											end
		else if(fifo_full & fifo_rd_en) begin
			fifo_full <= 1'b0;
		end
end 
//�ձ�־empty
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	fifo_empty <= 1'b1;
		end
	else if(fifo_wr_en & fifo_empty) begin
	fifo_empty <= 1'b0;
	end
	else if((fifo_rd_en & ~fifo_wr_en) && (rp == wp-2'b01 )) begin
	fifo_empty <= 1'b1;
			end
end

endmodule


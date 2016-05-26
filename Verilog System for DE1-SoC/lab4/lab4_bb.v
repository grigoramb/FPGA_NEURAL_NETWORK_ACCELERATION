
module lab4 (
	clk_65_clk,
	clocked_video_export_vid_clk,
	clocked_video_export_vid_data,
	clocked_video_export_underflow,
	clocked_video_export_vid_datavalid,
	clocked_video_export_vid_v_sync,
	clocked_video_export_vid_h_sync,
	clocked_video_export_vid_f,
	clocked_video_export_vid_h,
	clocked_video_export_vid_v,
	done2_export,
	done3_export,
	done_to_hps_export,
	hps_0_h2f_reset_reset_n,
	hps_io_hps_io_sdio_inst_CMD,
	hps_io_hps_io_sdio_inst_D0,
	hps_io_hps_io_sdio_inst_D1,
	hps_io_hps_io_sdio_inst_CLK,
	hps_io_hps_io_sdio_inst_D2,
	hps_io_hps_io_sdio_inst_D3,
	hps_io_hps_io_usb1_inst_D0,
	hps_io_hps_io_usb1_inst_D1,
	hps_io_hps_io_usb1_inst_D2,
	hps_io_hps_io_usb1_inst_D3,
	hps_io_hps_io_usb1_inst_D4,
	hps_io_hps_io_usb1_inst_D5,
	hps_io_hps_io_usb1_inst_D6,
	hps_io_hps_io_usb1_inst_D7,
	hps_io_hps_io_usb1_inst_CLK,
	hps_io_hps_io_usb1_inst_STP,
	hps_io_hps_io_usb1_inst_DIR,
	hps_io_hps_io_usb1_inst_NXT,
	hps_io_hps_io_uart0_inst_RX,
	hps_io_hps_io_uart0_inst_TX,
	layer1_control_done,
	layer1_control_ready,
	layer1_control_state,
	layer2_control_done,
	layer2_control_ready,
	layer2_control_state,
	layer3_control_done,
	layer3_control_ready,
	layer3_control_state,
	led_export_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	ready2_export,
	ready3_export,
	ready_from_hps_export,
	s1_l1_s1_adr,
	s1_l1_s1_d,
	s1_l1_s1_q,
	s1_l1_s1_cs,
	s1_l1_s1_w,
	s1_l2_s1_adr,
	s1_l2_s1_d,
	s1_l2_s1_q,
	s1_l2_s1_cs,
	s1_l2_s1_w,
	s1_l3_s1_adr,
	s1_l3_s1_d,
	s1_l3_s1_q,
	s1_l3_s1_cs,
	s1_l3_s1_w,
	s1_m1_address,
	s1_m1_clken,
	s1_m1_chipselect,
	s1_m1_write,
	s1_m1_readdata,
	s1_m1_writedata,
	s1_m2_address,
	s1_m2_clken,
	s1_m2_chipselect,
	s1_m2_write,
	s1_m2_readdata,
	s1_m2_writedata,
	s1_m3_address,
	s1_m3_clken,
	s1_m3_chipselect,
	s1_m3_write,
	s1_m3_readdata,
	s1_m3_writedata,
	s2_l1_s2_adr,
	s2_l1_s2_d,
	s2_l1_s2_q,
	s2_l1_s2_cs,
	s2_l1_s2_w,
	s2_l2_s2_adr,
	s2_l2_s2_d,
	s2_l2_s2_q,
	s2_l2_s2_cs,
	s2_l2_s2_w,
	s2_l3_s2_adr,
	s2_l3_s2_d,
	s2_l3_s2_q,
	s2_l3_s2_cs,
	s2_l3_s2_w,
	s2_m1_address,
	s2_m1_chipselect,
	s2_m1_clken,
	s2_m1_write,
	s2_m1_readdata,
	s2_m1_writedata,
	s2_m2_address,
	s2_m2_chipselect,
	s2_m2_clken,
	s2_m2_write,
	s2_m2_readdata,
	s2_m2_writedata,
	s2_m3_address,
	s2_m3_chipselect,
	s2_m3_clken,
	s2_m3_write,
	s2_m3_readdata,
	s2_m3_writedata,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	sw_export_export,
	system_ref_clk_clk,
	system_ref_reset_reset);	

	output		clk_65_clk;
	input		clocked_video_export_vid_clk;
	output	[31:0]	clocked_video_export_vid_data;
	output		clocked_video_export_underflow;
	output		clocked_video_export_vid_datavalid;
	output		clocked_video_export_vid_v_sync;
	output		clocked_video_export_vid_h_sync;
	output		clocked_video_export_vid_f;
	output		clocked_video_export_vid_h;
	output		clocked_video_export_vid_v;
	input	[6:0]	done2_export;
	input		done3_export;
	input	[6:0]	done_to_hps_export;
	output		hps_0_h2f_reset_reset_n;
	inout		hps_io_hps_io_sdio_inst_CMD;
	inout		hps_io_hps_io_sdio_inst_D0;
	inout		hps_io_hps_io_sdio_inst_D1;
	output		hps_io_hps_io_sdio_inst_CLK;
	inout		hps_io_hps_io_sdio_inst_D2;
	inout		hps_io_hps_io_sdio_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D0;
	inout		hps_io_hps_io_usb1_inst_D1;
	inout		hps_io_hps_io_usb1_inst_D2;
	inout		hps_io_hps_io_usb1_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D4;
	inout		hps_io_hps_io_usb1_inst_D5;
	inout		hps_io_hps_io_usb1_inst_D6;
	inout		hps_io_hps_io_usb1_inst_D7;
	input		hps_io_hps_io_usb1_inst_CLK;
	output		hps_io_hps_io_usb1_inst_STP;
	input		hps_io_hps_io_usb1_inst_DIR;
	input		hps_io_hps_io_usb1_inst_NXT;
	input		hps_io_hps_io_uart0_inst_RX;
	output		hps_io_hps_io_uart0_inst_TX;
	output	[6:0]	layer1_control_done;
	input		layer1_control_ready;
	output	[3:0]	layer1_control_state;
	output	[6:0]	layer2_control_done;
	input	[6:0]	layer2_control_ready;
	output	[3:0]	layer2_control_state;
	output		layer3_control_done;
	input	[6:0]	layer3_control_ready;
	output	[3:0]	layer3_control_state;
	output	[9:0]	led_export_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output	[6:0]	ready2_export;
	output	[6:0]	ready3_export;
	output		ready_from_hps_export;
	output	[16:0]	s1_l1_s1_adr;
	output	[7:0]	s1_l1_s1_d;
	input	[7:0]	s1_l1_s1_q;
	output		s1_l1_s1_cs;
	output		s1_l1_s1_w;
	output	[15:0]	s1_l2_s1_adr;
	output	[7:0]	s1_l2_s1_d;
	input	[7:0]	s1_l2_s1_q;
	output		s1_l2_s1_cs;
	output		s1_l2_s1_w;
	output	[10:0]	s1_l3_s1_adr;
	output	[7:0]	s1_l3_s1_d;
	input	[7:0]	s1_l3_s1_q;
	output		s1_l3_s1_cs;
	output		s1_l3_s1_w;
	input	[16:0]	s1_m1_address;
	input		s1_m1_clken;
	input		s1_m1_chipselect;
	input		s1_m1_write;
	output	[7:0]	s1_m1_readdata;
	input	[7:0]	s1_m1_writedata;
	input	[15:0]	s1_m2_address;
	input		s1_m2_clken;
	input		s1_m2_chipselect;
	input		s1_m2_write;
	output	[7:0]	s1_m2_readdata;
	input	[7:0]	s1_m2_writedata;
	input	[10:0]	s1_m3_address;
	input		s1_m3_clken;
	input		s1_m3_chipselect;
	input		s1_m3_write;
	output	[7:0]	s1_m3_readdata;
	input	[7:0]	s1_m3_writedata;
	output	[16:0]	s2_l1_s2_adr;
	output	[7:0]	s2_l1_s2_d;
	input	[7:0]	s2_l1_s2_q;
	output		s2_l1_s2_cs;
	output		s2_l1_s2_w;
	output	[15:0]	s2_l2_s2_adr;
	output	[7:0]	s2_l2_s2_d;
	input	[7:0]	s2_l2_s2_q;
	output		s2_l2_s2_cs;
	output		s2_l2_s2_w;
	output	[10:0]	s2_l3_s2_adr;
	output	[7:0]	s2_l3_s2_d;
	input	[7:0]	s2_l3_s2_q;
	output		s2_l3_s2_cs;
	output		s2_l3_s2_w;
	input	[16:0]	s2_m1_address;
	input		s2_m1_chipselect;
	input		s2_m1_clken;
	input		s2_m1_write;
	output	[7:0]	s2_m1_readdata;
	input	[7:0]	s2_m1_writedata;
	input	[15:0]	s2_m2_address;
	input		s2_m2_chipselect;
	input		s2_m2_clken;
	input		s2_m2_write;
	output	[7:0]	s2_m2_readdata;
	input	[7:0]	s2_m2_writedata;
	input	[10:0]	s2_m3_address;
	input		s2_m3_chipselect;
	input		s2_m3_clken;
	input		s2_m3_write;
	output	[7:0]	s2_m3_readdata;
	input	[7:0]	s2_m3_writedata;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input	[9:0]	sw_export_export;
	input		system_ref_clk_clk;
	input		system_ref_reset_reset;
endmodule

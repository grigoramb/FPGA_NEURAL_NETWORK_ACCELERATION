module lab4_toplevel (
	  // FPGA Pins
	  // Clock Pins
    input CLOCK_50,

	 
	 output[12:0] DRAM_ADDR,
    output[1:0] DRAM_BA,
    output DRAM_CAS_N,
    output DRAM_CKE,
	 output DRAM_CLK,
    output DRAM_CS_N,
    inout[15:0] DRAM_DQ,
    output DRAM_UDQM,
    output DRAM_LDQM,
    output DRAM_RAS_N,
    output DRAM_WE_N,

    output[0:6] HEX0,
	 output[0:6] HEX1,
	 output[0:6] HEX2,
	 output[0:6] HEX3, 
	 output[0:6] HEX4, 
	 output[0:6] HEX5,


	  // HPS Pins

	  // DDR3 SDRAM
    output[14:0] HPS_DDR3_ADDR,
    output[2:0] HPS_DDR3_BA,
    output HPS_DDR3_CAS_N,
    output HPS_DDR3_CKE,
    output HPS_DDR3_CK_N,
    output HPS_DDR3_CK_P,
    output HPS_DDR3_CS_N,
    output[3:0] HPS_DDR3_DM,
    inout[31:0] HPS_DDR3_DQ,
    inout[3:0] HPS_DDR3_DQS_N,
    inout[3:0] HPS_DDR3_DQS_P,
    output HPS_DDR3_ODT,
    output HPS_DDR3_RAS_N,
    output HPS_DDR3_RESET_N,
    input HPS_DDR3_RZQ,
    output HPS_DDR3_WE_N,
	 
	 
	 
	 output 	HPS_SD_CLK,
	 inout	HPS_SD_CMD,
	 inout [3:0]	HPS_SD_DATA,
	 
	 input	HPS_UART_RX,
	 output 	HPS_UART_TX,
	 
	 input	HPS_USB_CLKOUT,
	 inout	[7:0] HPS_USB_DATA,
	 input	HPS_USB_DIR,
	 input	HPS_USB_NXT,
	 output	HPS_USB_STP,
	
	 
	 
	 
	  // Pushbuttons
	  input [3:0] KEY,
	  // LEDs
	  output [9:0] LEDR,
	  
	  input [9:0] SW,
	  
	  output [7:0]	VGA_B,
	  output 		VGA_BLANK_N,
	  output 		VGA_CLK,
	  output [7:0]	VGA_G,
	  output 		VGA_HS,
	  output [7:0]	VGA_R,
	  output 		VGA_SYNC_N,
	  output 		VGA_VS
	  );

wire 		hps_fpga_reset_n;
wire 		clk_65;
wire [7:0]	vid_r,vid_g,vid_b;
wire 			vid_v_sync;
wire 			vid_h_sync;
wire 			vid_datavalid;

assign	VGA_BLANK_N	= 1'b1;
assign	VGA_SYNC_N	= 1'b0;
assign	VGA_CLK		= clk_65;
assign	{VGA_B,VGA_G,VGA_R} = {vid_b,vid_g,vid_r};
assign	VGA_VS		= vid_v_sync;
assign	VGA_HS		= vid_h_sync;

wire[15:0] inputnum;
hex_7seg hex0 (inputnum[3:0], HEX0);
hex_7seg hex1 (inputnum[7:4], HEX1);
hex_7seg hex2 (inputnum[11:8], HEX2);

    lab4 u0 (
        .clk_65_clk                         (clk_65),                         //               clk_65.clk
        .memory_mem_a                       (HPS_DDR3_ADDR),										//               memory.mem_a
        .memory_mem_ba                      (HPS_DDR3_BA),                      //                     .mem_ba
        .memory_mem_ck                      (HPS_DDR3_CK_P),                      //                     .mem_ck
        .memory_mem_ck_n                    (HPS_DDR3_CK_N),                    //                     .mem_ck_n
        .memory_mem_cke                     (HPS_DDR3_CKE),                     //                     .mem_cke
        .memory_mem_cs_n                    (HPS_DDR3_CS_N),                    //                     .mem_cs_n
        .memory_mem_ras_n                   (HPS_DDR3_RAS_N),                   //                     .mem_ras_n
        .memory_mem_cas_n                   (HPS_DDR3_CAS_N),                   //                     .mem_cas_n
        .memory_mem_we_n                    (HPS_DDR3_WE_N),                    //                     .mem_we_n
        .memory_mem_reset_n                 (HPS_DDR3_RESET_N),                 //                     .mem_reset_n
        .memory_mem_dq                      (HPS_DDR3_DQ),                      //                     .mem_dq
        .memory_mem_dqs                     (HPS_DDR3_DQS_P),                     //                     .mem_dqs
        .memory_mem_dqs_n                   (HPS_DDR3_DQS_N),                   //                     .mem_dqs_n
        .memory_mem_odt                     (HPS_DDR3_ODT),                     //                     .mem_odt
        .memory_mem_dm                      (HPS_DDR3_DM),                      //                     .mem_dm
        .memory_oct_rzqin                   (HPS_DDR3_RZQ),                   //                     .oct_rzqin
        .hps_io_hps_io_sdio_inst_CMD        (HPS_SD_CMD),        //               hps_io.hps_io_sdio_inst_CMD
        .hps_io_hps_io_sdio_inst_D0         (HPS_SD_DATA[0]),         //                     .hps_io_sdio_inst_D0
        .hps_io_hps_io_sdio_inst_D1         (HPS_SD_DATA[1]),         //                     .hps_io_sdio_inst_D1
        .hps_io_hps_io_sdio_inst_CLK        (HPS_SD_CLK),        //                     .hps_io_sdio_inst_CLK
        .hps_io_hps_io_sdio_inst_D2         (HPS_SD_DATA[2]),         //                     .hps_io_sdio_inst_D2
        .hps_io_hps_io_sdio_inst_D3         (HPS_SD_DATA[3]),         //                     .hps_io_sdio_inst_D3
        .hps_io_hps_io_usb1_inst_D0         (HPS_USB_DATA[0]),         //                     .hps_io_usb1_inst_D0
        .hps_io_hps_io_usb1_inst_D1         (HPS_USB_DATA[1]),         //                     .hps_io_usb1_inst_D1
        .hps_io_hps_io_usb1_inst_D2         (HPS_USB_DATA[2]),         //                     .hps_io_usb1_inst_D2
        .hps_io_hps_io_usb1_inst_D3         (HPS_USB_DATA[3]),         //                     .hps_io_usb1_inst_D3
        .hps_io_hps_io_usb1_inst_D4         (HPS_USB_DATA[4]),         //                     .hps_io_usb1_inst_D4
        .hps_io_hps_io_usb1_inst_D5         (HPS_USB_DATA[5]),         //                     .hps_io_usb1_inst_D5
        .hps_io_hps_io_usb1_inst_D6         (HPS_USB_DATA[6]),         //                     .hps_io_usb1_inst_D6
        .hps_io_hps_io_usb1_inst_D7         (HPS_USB_DATA[7]),         //                     .hps_io_usb1_inst_D7
        .hps_io_hps_io_usb1_inst_CLK        (HPS_USB_CLKOUT),        //                     .hps_io_usb1_inst_CLK
        .hps_io_hps_io_usb1_inst_STP        (HPS_USB_STP),        //                     .hps_io_usb1_inst_STP
        .hps_io_hps_io_usb1_inst_DIR        (HPS_USB_DIR),        //                     .hps_io_usb1_inst_DIR
        .hps_io_hps_io_usb1_inst_NXT        (HPS_USB_NXT),        //                     .hps_io_usb1_inst_NXT
        .hps_io_hps_io_uart0_inst_RX        (HPS_UART_RX),        //                     .hps_io_uart0_inst_RX
        .hps_io_hps_io_uart0_inst_TX        (HPS_UART_TX),        //                     .hps_io_uart0_inst_TX
        .led_export_export                  (),                  //           led_export.export
        .sw_export_export                   (),                   //            sw_export.export
        .clocked_video_export_vid_clk       (~clk_65),       // clocked_video_export.vid_clk
        .clocked_video_export_vid_data      ({vid_r,vid_g,vid_b}),      //                     .vid_data
        .clocked_video_export_underflow     (),     //                     .underflow
        .clocked_video_export_vid_datavalid (vid_datavalid), //                     .vid_datavalid
        .clocked_video_export_vid_v_sync    (vid_v_sync),    //                     .vid_v_sync
        .clocked_video_export_vid_h_sync    (vid_h_sync),    //                     .vid_h_sync
        .clocked_video_export_vid_f         (),         //                     .vid_f
        .clocked_video_export_vid_h         (),         //                     .vid_h
        .clocked_video_export_vid_v         (),          //                     .vid_v
        .hps_0_h2f_reset_reset_n            (hps_fpga_reset_n),             //      hps_0_h2f_reset.reset_n   );
	
		  .sdram_wire_addr                    (DRAM_ADDR),                    //           sdram_wire.addr
        .sdram_wire_ba                      (DRAM_BA),                      //                     .ba
        .sdram_wire_cas_n                   (DRAM_CAS_N),                   //                     .cas_n
        .sdram_wire_cke                     (DRAM_CKE),                     //                     .cke
        .sdram_wire_cs_n                    (DRAM_CS_N),                    //                     .cs_n
        .sdram_wire_dq                      (DRAM_DQ),                      //                     .dq
        .sdram_wire_dqm                     ({DRAM_UDQM,DRAM_LDQM}),                     //                     .dqm
        .sdram_wire_ras_n                   (DRAM_RAS_N),                   //                     .ras_n
        .sdram_wire_we_n                    (DRAM_WE_N),                    //                     .we_n
		  

		 
        .sdram_clk_clk                      (DRAM_CLK),                      //            sdram_clk.clk
        .system_ref_clk_clk                 (CLOCK_50),                 //       system_ref_clk.clk
        .system_ref_reset_reset             (),              //     system_ref_reset



		  
		  
		  
		  .s1_l1_s1_adr                       (l1_s1_adr),                       //                s1_l1.s1_adr
        .s1_l1_s1_d                         (l1_s1_d),                         //                     .s1_d
        .s1_l1_s1_q                         (l1_s1_q),                         //                     .s1_q
        .s1_l1_s1_cs                        (l1_s1_cs),                        //                     .s1_cs
        .s1_l1_s1_w                         (l1_s1_w),                         //                     .s1_w
        .s2_l1_s2_adr                       (l1_s2_adr),                       //                s2_l1.s2_adr
        .s2_l1_s2_d                         (l1_s2_d),                         //                     .s2_d
        .s2_l1_s2_q                         (l1_s2_q),                         //                     .s2_q
        .s2_l1_s2_cs                        (l1_s2_cs),                        //                     .s2_cs
        .s2_l1_s2_w                         (l1_s2_w),    

		  .s1_l2_s1_adr                       (l2_s1_adr),                       //                s1_l1.s1_adr
        .s1_l2_s1_d                         (l2_s1_d),                         //                     .s1_d
        .s1_l2_s1_q                         (l2_s1_q),                         //                     .s1_q
        .s1_l2_s1_cs                        (l2_s1_cs),                        //                     .s1_cs
        .s1_l2_s1_w                         (l2_s1_w),                         //                     .s1_w
        .s2_l2_s2_adr                       (l2_s2_adr),                       //                s2_l1.s2_adr
        .s2_l2_s2_d                         (l2_s2_d),                         //                     .s2_d
        .s2_l2_s2_q                         (l2_s2_q),                         //                     .s2_q
        .s2_l2_s2_cs                        (l2_s2_cs),                        //                     .s2_cs
        .s2_l2_s2_w                         (l2_s2_w),    
		  
		  .s2_m1_address        (l1_s1_adr),        //  onchip_memory2_0_s1.address
        .s2_m1_chipselect     (1'b1),          //                     .clken
        .s2_m1_clken     		(l1_s1_cs),     //                     .chipselect
        .s2_m1_write          (l1_s1_w),          //                     .write
        .s2_m1_readdata       (l1_s1_q),       //                     .readdata
        .s2_m1_writedata      (l1_s1_d),      //                     .writedata
        .s1_m1_address        (l1_s2_adr),        //  onchip_memory2_0_s2.address
        .s1_m1_chipselect     (l1_s2_cs),     //                     .chipselect
        .s1_m1_clken          (1'b1),          //                     .clken
        .s1_m1_write          (l1_s2_w),          //                     .write
        .s1_m1_readdata       (l1_s2_q),       //                     .readdata
        .s1_m1_writedata      (l1_s2_d),       //                     .writedata
		  
		  .s2_m2_address        (l2_s1_adr),        //  onchip_memory2_0_s1.address
        .s2_m2_chipselect     (1'b1),          //                     .clken
        .s2_m2_clken     		(l2_s1_cs),     //                     .chipselect
        .s2_m2_write          (l2_s1_w),          //                     .write
        .s2_m2_readdata       (l2_s1_q),       //                     .readdata
        .s2_m2_writedata      (l2_s1_d),      //                     .writedata
        .s1_m2_address        (l2_s2_adr),        //  onchip_memory2_0_s2.address
        .s1_m2_chipselect     (l2_s2_cs),     //                     .chipselect
        .s1_m2_clken          (1'b1),          //                     .clken
        .s1_m2_write          (l2_s2_w),          //                     .write
        .s1_m2_readdata       (l2_s2_q),       //                     .readdata
        .s1_m2_writedata      (l2_s2_d),       //                     .writedata
		  
		  .s2_m3_address        (l3_s1_adr),        //  onchip_memory2_0_s1.address
        .s2_m3_chipselect     (1'b1),          //                     .clken
        .s2_m3_clken     		(l3_s1_cs),     //                     .chipselect
        .s2_m3_write          (l3_s1_w),          //                     .write
        .s2_m3_readdata       (l3_s1_q),       //                     .readdata
        .s2_m3_writedata      (l3_s1_d),      //                     .writedata
        .s1_m3_address        (l3_s2_adr),        //  onchip_memory2_0_s2.address
        .s1_m3_chipselect     (l3_s2_cs),     //                     .chipselect
        .s1_m3_clken          (1'b1),          //                     .clken
        .s1_m3_write          (l3_s2_w),          //                     .write
        .s1_m3_readdata       (l3_s2_q),       //                     .readdata
        .s1_m3_writedata      (l3_s2_d),       //                     .writedata

		  .layer1_control_done              (l1_done),              //     layer1_0_control.done
        .layer1_control_ready             (ready),             //                     .ready
        .layer1_control_state             (inputnum[3:0]),              //                     .state
		  // TO HPS:
		  .done_to_hps_export                 (l1_done),                 //          done_to_hps.export
        .ready_from_hps_export              (ready),              //       ready_from_hps.export
			    
		  
        .layer2_control_done                (l2_done),                //       layer2_control.done
        .layer2_control_ready               (l1_done),               //                     .ready
        .layer2_control_state               (inputnum[7:4]),               //                     .state

			// TO HPS:
        .done2_export                       (l2_done),                       //                done2.export
        .ready2_export                      (),                       //               ready2.export

		  
		  .layer3_control_done                (l3_done),                //       layer2_control.done
        .layer3_control_ready               (l2_done),               //                     .ready
        .layer3_control_state               (inputnum[11:8]),               //                     .state


			// TO HPS:
        .done3_export                       (l3_done),                       //                done2.export
        .ready3_export                      ()                       //               ready2.export
		  
		  
		  
		  
		  );
			
		  wire [6:0] l1_done;
		  wire [6:0] l2_done;
		  wire l3_done;
		  wire [16:0] l1_s1_adr;
		  wire [16:0] l1_s2_adr;
		  wire [15:0] l2_s1_adr;
		  wire [15:0] l2_s2_adr;
		  wire [10:0] l3_s1_adr;
		  wire [10:0] l3_s2_adr;
		  wire [7:0] l1_s1_d, l1_s1_q, l1_s2_d, l1_s2_q;
		  wire [7:0] l2_s1_d, l2_s1_q, l2_s2_d, l2_s2_q;
		  wire [7:0] l3_s1_d, l3_s1_q, l3_s2_d, l3_s2_q;


endmodule

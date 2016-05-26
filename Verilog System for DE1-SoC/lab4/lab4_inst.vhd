	component lab4 is
		port (
			clk_65_clk                         : out   std_logic;                                        -- clk
			clocked_video_export_vid_clk       : in    std_logic                     := 'X';             -- vid_clk
			clocked_video_export_vid_data      : out   std_logic_vector(31 downto 0);                    -- vid_data
			clocked_video_export_underflow     : out   std_logic;                                        -- underflow
			clocked_video_export_vid_datavalid : out   std_logic;                                        -- vid_datavalid
			clocked_video_export_vid_v_sync    : out   std_logic;                                        -- vid_v_sync
			clocked_video_export_vid_h_sync    : out   std_logic;                                        -- vid_h_sync
			clocked_video_export_vid_f         : out   std_logic;                                        -- vid_f
			clocked_video_export_vid_h         : out   std_logic;                                        -- vid_h
			clocked_video_export_vid_v         : out   std_logic;                                        -- vid_v
			done2_export                       : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- export
			done3_export                       : in    std_logic                     := 'X';             -- export
			done_to_hps_export                 : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- export
			hps_0_h2f_reset_reset_n            : out   std_logic;                                        -- reset_n
			hps_io_hps_io_sdio_inst_CMD        : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK        : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP        : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX        : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX        : out   std_logic;                                        -- hps_io_uart0_inst_TX
			layer1_control_done                : out   std_logic_vector(6 downto 0);                     -- done
			layer1_control_ready               : in    std_logic                     := 'X';             -- ready
			layer1_control_state               : out   std_logic_vector(3 downto 0);                     -- state
			layer2_control_done                : out   std_logic_vector(6 downto 0);                     -- done
			layer2_control_ready               : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- ready
			layer2_control_state               : out   std_logic_vector(3 downto 0);                     -- state
			layer3_control_done                : out   std_logic;                                        -- done
			layer3_control_ready               : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- ready
			layer3_control_state               : out   std_logic_vector(3 downto 0);                     -- state
			led_export_export                  : out   std_logic_vector(9 downto 0);                     -- export
			memory_mem_a                       : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                      : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                      : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                    : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                     : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                    : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                   : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                   : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                    : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                 : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                     : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                   : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                     : out   std_logic;                                        -- mem_odt
			memory_mem_dm                      : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                   : in    std_logic                     := 'X';             -- oct_rzqin
			ready2_export                      : out   std_logic_vector(6 downto 0);                     -- export
			ready3_export                      : out   std_logic_vector(6 downto 0);                     -- export
			ready_from_hps_export              : out   std_logic;                                        -- export
			s1_l1_s1_adr                       : out   std_logic_vector(16 downto 0);                    -- s1_adr
			s1_l1_s1_d                         : out   std_logic_vector(7 downto 0);                     -- s1_d
			s1_l1_s1_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s1_q
			s1_l1_s1_cs                        : out   std_logic;                                        -- s1_cs
			s1_l1_s1_w                         : out   std_logic;                                        -- s1_w
			s1_l2_s1_adr                       : out   std_logic_vector(15 downto 0);                    -- s1_adr
			s1_l2_s1_d                         : out   std_logic_vector(7 downto 0);                     -- s1_d
			s1_l2_s1_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s1_q
			s1_l2_s1_cs                        : out   std_logic;                                        -- s1_cs
			s1_l2_s1_w                         : out   std_logic;                                        -- s1_w
			s1_l3_s1_adr                       : out   std_logic_vector(10 downto 0);                    -- s1_adr
			s1_l3_s1_d                         : out   std_logic_vector(7 downto 0);                     -- s1_d
			s1_l3_s1_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s1_q
			s1_l3_s1_cs                        : out   std_logic;                                        -- s1_cs
			s1_l3_s1_w                         : out   std_logic;                                        -- s1_w
			s1_m1_address                      : in    std_logic_vector(16 downto 0) := (others => 'X'); -- address
			s1_m1_clken                        : in    std_logic                     := 'X';             -- clken
			s1_m1_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s1_m1_write                        : in    std_logic                     := 'X';             -- write
			s1_m1_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s1_m1_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			s1_m2_address                      : in    std_logic_vector(15 downto 0) := (others => 'X'); -- address
			s1_m2_clken                        : in    std_logic                     := 'X';             -- clken
			s1_m2_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s1_m2_write                        : in    std_logic                     := 'X';             -- write
			s1_m2_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s1_m2_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			s1_m3_address                      : in    std_logic_vector(10 downto 0) := (others => 'X'); -- address
			s1_m3_clken                        : in    std_logic                     := 'X';             -- clken
			s1_m3_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s1_m3_write                        : in    std_logic                     := 'X';             -- write
			s1_m3_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s1_m3_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			s2_l1_s2_adr                       : out   std_logic_vector(16 downto 0);                    -- s2_adr
			s2_l1_s2_d                         : out   std_logic_vector(7 downto 0);                     -- s2_d
			s2_l1_s2_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s2_q
			s2_l1_s2_cs                        : out   std_logic;                                        -- s2_cs
			s2_l1_s2_w                         : out   std_logic;                                        -- s2_w
			s2_l2_s2_adr                       : out   std_logic_vector(15 downto 0);                    -- s2_adr
			s2_l2_s2_d                         : out   std_logic_vector(7 downto 0);                     -- s2_d
			s2_l2_s2_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s2_q
			s2_l2_s2_cs                        : out   std_logic;                                        -- s2_cs
			s2_l2_s2_w                         : out   std_logic;                                        -- s2_w
			s2_l3_s2_adr                       : out   std_logic_vector(10 downto 0);                    -- s2_adr
			s2_l3_s2_d                         : out   std_logic_vector(7 downto 0);                     -- s2_d
			s2_l3_s2_q                         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- s2_q
			s2_l3_s2_cs                        : out   std_logic;                                        -- s2_cs
			s2_l3_s2_w                         : out   std_logic;                                        -- s2_w
			s2_m1_address                      : in    std_logic_vector(16 downto 0) := (others => 'X'); -- address
			s2_m1_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s2_m1_clken                        : in    std_logic                     := 'X';             -- clken
			s2_m1_write                        : in    std_logic                     := 'X';             -- write
			s2_m1_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s2_m1_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			s2_m2_address                      : in    std_logic_vector(15 downto 0) := (others => 'X'); -- address
			s2_m2_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s2_m2_clken                        : in    std_logic                     := 'X';             -- clken
			s2_m2_write                        : in    std_logic                     := 'X';             -- write
			s2_m2_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s2_m2_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			s2_m3_address                      : in    std_logic_vector(10 downto 0) := (others => 'X'); -- address
			s2_m3_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			s2_m3_clken                        : in    std_logic                     := 'X';             -- clken
			s2_m3_write                        : in    std_logic                     := 'X';             -- write
			s2_m3_readdata                     : out   std_logic_vector(7 downto 0);                     -- readdata
			s2_m3_writedata                    : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			sdram_clk_clk                      : out   std_logic;                                        -- clk
			sdram_wire_addr                    : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                      : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n                   : out   std_logic;                                        -- cas_n
			sdram_wire_cke                     : out   std_logic;                                        -- cke
			sdram_wire_cs_n                    : out   std_logic;                                        -- cs_n
			sdram_wire_dq                      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                     : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n                   : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                    : out   std_logic;                                        -- we_n
			sw_export_export                   : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			system_ref_clk_clk                 : in    std_logic                     := 'X';             -- clk
			system_ref_reset_reset             : in    std_logic                     := 'X'              -- reset
		);
	end component lab4;

	u0 : component lab4
		port map (
			clk_65_clk                         => CONNECTED_TO_clk_65_clk,                         --               clk_65.clk
			clocked_video_export_vid_clk       => CONNECTED_TO_clocked_video_export_vid_clk,       -- clocked_video_export.vid_clk
			clocked_video_export_vid_data      => CONNECTED_TO_clocked_video_export_vid_data,      --                     .vid_data
			clocked_video_export_underflow     => CONNECTED_TO_clocked_video_export_underflow,     --                     .underflow
			clocked_video_export_vid_datavalid => CONNECTED_TO_clocked_video_export_vid_datavalid, --                     .vid_datavalid
			clocked_video_export_vid_v_sync    => CONNECTED_TO_clocked_video_export_vid_v_sync,    --                     .vid_v_sync
			clocked_video_export_vid_h_sync    => CONNECTED_TO_clocked_video_export_vid_h_sync,    --                     .vid_h_sync
			clocked_video_export_vid_f         => CONNECTED_TO_clocked_video_export_vid_f,         --                     .vid_f
			clocked_video_export_vid_h         => CONNECTED_TO_clocked_video_export_vid_h,         --                     .vid_h
			clocked_video_export_vid_v         => CONNECTED_TO_clocked_video_export_vid_v,         --                     .vid_v
			done2_export                       => CONNECTED_TO_done2_export,                       --                done2.export
			done3_export                       => CONNECTED_TO_done3_export,                       --                done3.export
			done_to_hps_export                 => CONNECTED_TO_done_to_hps_export,                 --          done_to_hps.export
			hps_0_h2f_reset_reset_n            => CONNECTED_TO_hps_0_h2f_reset_reset_n,            --      hps_0_h2f_reset.reset_n
			hps_io_hps_io_sdio_inst_CMD        => CONNECTED_TO_hps_io_hps_io_sdio_inst_CMD,        --               hps_io.hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D0,         --                     .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D1,         --                     .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK        => CONNECTED_TO_hps_io_hps_io_sdio_inst_CLK,        --                     .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D2,         --                     .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3         => CONNECTED_TO_hps_io_hps_io_sdio_inst_D3,         --                     .hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D0,         --                     .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D1,         --                     .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D2,         --                     .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D3,         --                     .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D4,         --                     .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D5,         --                     .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D6,         --                     .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7         => CONNECTED_TO_hps_io_hps_io_usb1_inst_D7,         --                     .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK        => CONNECTED_TO_hps_io_hps_io_usb1_inst_CLK,        --                     .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP        => CONNECTED_TO_hps_io_hps_io_usb1_inst_STP,        --                     .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR        => CONNECTED_TO_hps_io_hps_io_usb1_inst_DIR,        --                     .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT        => CONNECTED_TO_hps_io_hps_io_usb1_inst_NXT,        --                     .hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX        => CONNECTED_TO_hps_io_hps_io_uart0_inst_RX,        --                     .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX        => CONNECTED_TO_hps_io_hps_io_uart0_inst_TX,        --                     .hps_io_uart0_inst_TX
			layer1_control_done                => CONNECTED_TO_layer1_control_done,                --       layer1_control.done
			layer1_control_ready               => CONNECTED_TO_layer1_control_ready,               --                     .ready
			layer1_control_state               => CONNECTED_TO_layer1_control_state,               --                     .state
			layer2_control_done                => CONNECTED_TO_layer2_control_done,                --       layer2_control.done
			layer2_control_ready               => CONNECTED_TO_layer2_control_ready,               --                     .ready
			layer2_control_state               => CONNECTED_TO_layer2_control_state,               --                     .state
			layer3_control_done                => CONNECTED_TO_layer3_control_done,                --       layer3_control.done
			layer3_control_ready               => CONNECTED_TO_layer3_control_ready,               --                     .ready
			layer3_control_state               => CONNECTED_TO_layer3_control_state,               --                     .state
			led_export_export                  => CONNECTED_TO_led_export_export,                  --           led_export.export
			memory_mem_a                       => CONNECTED_TO_memory_mem_a,                       --               memory.mem_a
			memory_mem_ba                      => CONNECTED_TO_memory_mem_ba,                      --                     .mem_ba
			memory_mem_ck                      => CONNECTED_TO_memory_mem_ck,                      --                     .mem_ck
			memory_mem_ck_n                    => CONNECTED_TO_memory_mem_ck_n,                    --                     .mem_ck_n
			memory_mem_cke                     => CONNECTED_TO_memory_mem_cke,                     --                     .mem_cke
			memory_mem_cs_n                    => CONNECTED_TO_memory_mem_cs_n,                    --                     .mem_cs_n
			memory_mem_ras_n                   => CONNECTED_TO_memory_mem_ras_n,                   --                     .mem_ras_n
			memory_mem_cas_n                   => CONNECTED_TO_memory_mem_cas_n,                   --                     .mem_cas_n
			memory_mem_we_n                    => CONNECTED_TO_memory_mem_we_n,                    --                     .mem_we_n
			memory_mem_reset_n                 => CONNECTED_TO_memory_mem_reset_n,                 --                     .mem_reset_n
			memory_mem_dq                      => CONNECTED_TO_memory_mem_dq,                      --                     .mem_dq
			memory_mem_dqs                     => CONNECTED_TO_memory_mem_dqs,                     --                     .mem_dqs
			memory_mem_dqs_n                   => CONNECTED_TO_memory_mem_dqs_n,                   --                     .mem_dqs_n
			memory_mem_odt                     => CONNECTED_TO_memory_mem_odt,                     --                     .mem_odt
			memory_mem_dm                      => CONNECTED_TO_memory_mem_dm,                      --                     .mem_dm
			memory_oct_rzqin                   => CONNECTED_TO_memory_oct_rzqin,                   --                     .oct_rzqin
			ready2_export                      => CONNECTED_TO_ready2_export,                      --               ready2.export
			ready3_export                      => CONNECTED_TO_ready3_export,                      --               ready3.export
			ready_from_hps_export              => CONNECTED_TO_ready_from_hps_export,              --       ready_from_hps.export
			s1_l1_s1_adr                       => CONNECTED_TO_s1_l1_s1_adr,                       --                s1_l1.s1_adr
			s1_l1_s1_d                         => CONNECTED_TO_s1_l1_s1_d,                         --                     .s1_d
			s1_l1_s1_q                         => CONNECTED_TO_s1_l1_s1_q,                         --                     .s1_q
			s1_l1_s1_cs                        => CONNECTED_TO_s1_l1_s1_cs,                        --                     .s1_cs
			s1_l1_s1_w                         => CONNECTED_TO_s1_l1_s1_w,                         --                     .s1_w
			s1_l2_s1_adr                       => CONNECTED_TO_s1_l2_s1_adr,                       --                s1_l2.s1_adr
			s1_l2_s1_d                         => CONNECTED_TO_s1_l2_s1_d,                         --                     .s1_d
			s1_l2_s1_q                         => CONNECTED_TO_s1_l2_s1_q,                         --                     .s1_q
			s1_l2_s1_cs                        => CONNECTED_TO_s1_l2_s1_cs,                        --                     .s1_cs
			s1_l2_s1_w                         => CONNECTED_TO_s1_l2_s1_w,                         --                     .s1_w
			s1_l3_s1_adr                       => CONNECTED_TO_s1_l3_s1_adr,                       --                s1_l3.s1_adr
			s1_l3_s1_d                         => CONNECTED_TO_s1_l3_s1_d,                         --                     .s1_d
			s1_l3_s1_q                         => CONNECTED_TO_s1_l3_s1_q,                         --                     .s1_q
			s1_l3_s1_cs                        => CONNECTED_TO_s1_l3_s1_cs,                        --                     .s1_cs
			s1_l3_s1_w                         => CONNECTED_TO_s1_l3_s1_w,                         --                     .s1_w
			s1_m1_address                      => CONNECTED_TO_s1_m1_address,                      --                s1_m1.address
			s1_m1_clken                        => CONNECTED_TO_s1_m1_clken,                        --                     .clken
			s1_m1_chipselect                   => CONNECTED_TO_s1_m1_chipselect,                   --                     .chipselect
			s1_m1_write                        => CONNECTED_TO_s1_m1_write,                        --                     .write
			s1_m1_readdata                     => CONNECTED_TO_s1_m1_readdata,                     --                     .readdata
			s1_m1_writedata                    => CONNECTED_TO_s1_m1_writedata,                    --                     .writedata
			s1_m2_address                      => CONNECTED_TO_s1_m2_address,                      --                s1_m2.address
			s1_m2_clken                        => CONNECTED_TO_s1_m2_clken,                        --                     .clken
			s1_m2_chipselect                   => CONNECTED_TO_s1_m2_chipselect,                   --                     .chipselect
			s1_m2_write                        => CONNECTED_TO_s1_m2_write,                        --                     .write
			s1_m2_readdata                     => CONNECTED_TO_s1_m2_readdata,                     --                     .readdata
			s1_m2_writedata                    => CONNECTED_TO_s1_m2_writedata,                    --                     .writedata
			s1_m3_address                      => CONNECTED_TO_s1_m3_address,                      --                s1_m3.address
			s1_m3_clken                        => CONNECTED_TO_s1_m3_clken,                        --                     .clken
			s1_m3_chipselect                   => CONNECTED_TO_s1_m3_chipselect,                   --                     .chipselect
			s1_m3_write                        => CONNECTED_TO_s1_m3_write,                        --                     .write
			s1_m3_readdata                     => CONNECTED_TO_s1_m3_readdata,                     --                     .readdata
			s1_m3_writedata                    => CONNECTED_TO_s1_m3_writedata,                    --                     .writedata
			s2_l1_s2_adr                       => CONNECTED_TO_s2_l1_s2_adr,                       --                s2_l1.s2_adr
			s2_l1_s2_d                         => CONNECTED_TO_s2_l1_s2_d,                         --                     .s2_d
			s2_l1_s2_q                         => CONNECTED_TO_s2_l1_s2_q,                         --                     .s2_q
			s2_l1_s2_cs                        => CONNECTED_TO_s2_l1_s2_cs,                        --                     .s2_cs
			s2_l1_s2_w                         => CONNECTED_TO_s2_l1_s2_w,                         --                     .s2_w
			s2_l2_s2_adr                       => CONNECTED_TO_s2_l2_s2_adr,                       --                s2_l2.s2_adr
			s2_l2_s2_d                         => CONNECTED_TO_s2_l2_s2_d,                         --                     .s2_d
			s2_l2_s2_q                         => CONNECTED_TO_s2_l2_s2_q,                         --                     .s2_q
			s2_l2_s2_cs                        => CONNECTED_TO_s2_l2_s2_cs,                        --                     .s2_cs
			s2_l2_s2_w                         => CONNECTED_TO_s2_l2_s2_w,                         --                     .s2_w
			s2_l3_s2_adr                       => CONNECTED_TO_s2_l3_s2_adr,                       --                s2_l3.s2_adr
			s2_l3_s2_d                         => CONNECTED_TO_s2_l3_s2_d,                         --                     .s2_d
			s2_l3_s2_q                         => CONNECTED_TO_s2_l3_s2_q,                         --                     .s2_q
			s2_l3_s2_cs                        => CONNECTED_TO_s2_l3_s2_cs,                        --                     .s2_cs
			s2_l3_s2_w                         => CONNECTED_TO_s2_l3_s2_w,                         --                     .s2_w
			s2_m1_address                      => CONNECTED_TO_s2_m1_address,                      --                s2_m1.address
			s2_m1_chipselect                   => CONNECTED_TO_s2_m1_chipselect,                   --                     .chipselect
			s2_m1_clken                        => CONNECTED_TO_s2_m1_clken,                        --                     .clken
			s2_m1_write                        => CONNECTED_TO_s2_m1_write,                        --                     .write
			s2_m1_readdata                     => CONNECTED_TO_s2_m1_readdata,                     --                     .readdata
			s2_m1_writedata                    => CONNECTED_TO_s2_m1_writedata,                    --                     .writedata
			s2_m2_address                      => CONNECTED_TO_s2_m2_address,                      --                s2_m2.address
			s2_m2_chipselect                   => CONNECTED_TO_s2_m2_chipselect,                   --                     .chipselect
			s2_m2_clken                        => CONNECTED_TO_s2_m2_clken,                        --                     .clken
			s2_m2_write                        => CONNECTED_TO_s2_m2_write,                        --                     .write
			s2_m2_readdata                     => CONNECTED_TO_s2_m2_readdata,                     --                     .readdata
			s2_m2_writedata                    => CONNECTED_TO_s2_m2_writedata,                    --                     .writedata
			s2_m3_address                      => CONNECTED_TO_s2_m3_address,                      --                s2_m3.address
			s2_m3_chipselect                   => CONNECTED_TO_s2_m3_chipselect,                   --                     .chipselect
			s2_m3_clken                        => CONNECTED_TO_s2_m3_clken,                        --                     .clken
			s2_m3_write                        => CONNECTED_TO_s2_m3_write,                        --                     .write
			s2_m3_readdata                     => CONNECTED_TO_s2_m3_readdata,                     --                     .readdata
			s2_m3_writedata                    => CONNECTED_TO_s2_m3_writedata,                    --                     .writedata
			sdram_clk_clk                      => CONNECTED_TO_sdram_clk_clk,                      --            sdram_clk.clk
			sdram_wire_addr                    => CONNECTED_TO_sdram_wire_addr,                    --           sdram_wire.addr
			sdram_wire_ba                      => CONNECTED_TO_sdram_wire_ba,                      --                     .ba
			sdram_wire_cas_n                   => CONNECTED_TO_sdram_wire_cas_n,                   --                     .cas_n
			sdram_wire_cke                     => CONNECTED_TO_sdram_wire_cke,                     --                     .cke
			sdram_wire_cs_n                    => CONNECTED_TO_sdram_wire_cs_n,                    --                     .cs_n
			sdram_wire_dq                      => CONNECTED_TO_sdram_wire_dq,                      --                     .dq
			sdram_wire_dqm                     => CONNECTED_TO_sdram_wire_dqm,                     --                     .dqm
			sdram_wire_ras_n                   => CONNECTED_TO_sdram_wire_ras_n,                   --                     .ras_n
			sdram_wire_we_n                    => CONNECTED_TO_sdram_wire_we_n,                    --                     .we_n
			sw_export_export                   => CONNECTED_TO_sw_export_export,                   --            sw_export.export
			system_ref_clk_clk                 => CONNECTED_TO_system_ref_clk_clk,                 --       system_ref_clk.clk
			system_ref_reset_reset             => CONNECTED_TO_system_ref_reset_reset              --     system_ref_reset.reset
		);


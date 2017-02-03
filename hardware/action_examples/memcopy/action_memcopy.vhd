----------------------------------------------------------------------------
----------------------------------------------------------------------------
--
-- Copyright 2016 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions AND
-- limitations under the License.
--
-- change log:
-- 12/20/2016 R. Rieke fixed case statement issue
----------------------------------------------------------------------------
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;



entity action_memcopy is
    generic (
        -- Parameters of Axi Master Bus Interface AXI_CARD_MEM0 ; to DDR memory
        C_AXI_CARD_MEM0_ID_WIDTH    : integer   := 2;
        C_AXI_CARD_MEM0_ADDR_WIDTH  : integer   := 33;
        C_AXI_CARD_MEM0_DATA_WIDTH  : integer   := 512;
        C_AXI_CARD_MEM0_AWUSER_WIDTH    : integer   := 1;
        C_AXI_CARD_MEM0_ARUSER_WIDTH    : integer   := 1;
        C_AXI_CARD_MEM0_WUSER_WIDTH : integer   := 1;
        C_AXI_CARD_MEM0_RUSER_WIDTH : integer   := 1;
        C_AXI_CARD_MEM0_BUSER_WIDTH : integer   := 1;

        -- Parameters of Axi Slave Bus Interface AXI_CTRL_REG
        C_AXI_CTRL_REG_DATA_WIDTH   : integer   := 32;
        C_AXI_CTRL_REG_ADDR_WIDTH   : integer   := 32;

        -- Parameters of Axi Master Bus Interface AXI_HOST_MEM ; to Host memory
        C_AXI_HOST_MEM_ID_WIDTH     : integer   := 2;
        C_AXI_HOST_MEM_ADDR_WIDTH   : integer   := 64;
        C_AXI_HOST_MEM_DATA_WIDTH   : integer   := 512;
        C_AXI_HOST_MEM_AWUSER_WIDTH : integer   := 1;
        C_AXI_HOST_MEM_ARUSER_WIDTH : integer   := 1;
        C_AXI_HOST_MEM_WUSER_WIDTH  : integer   := 1;
        C_AXI_HOST_MEM_RUSER_WIDTH  : integer   := 1;
        C_AXI_HOST_MEM_BUSER_WIDTH  : integer   := 1
    );
    port (
        action_clk      : in STD_LOGIC;
        action_rst_n        : in STD_LOGIC;

        -- Ports of Axi Master Bus Interface AXI_CARD_MEM0                                         -- only for DDR3_USED=TRUE
                -- to DDR memory                                                                   -- only for DDR3_USED=TRUE
        axi_card_mem0_awaddr    : out std_logic_vector(C_AXI_CARD_MEM0_ADDR_WIDTH-1 downto 0);     -- only for DDR3_USED=TRUE
        axi_card_mem0_awlen : out std_logic_vector(7 downto 0);                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_awsize    : out std_logic_vector(2 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awburst   : out std_logic_vector(1 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awlock    : out std_logic_vector(0 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awcache   : out std_logic_vector(3 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awprot    : out std_logic_vector(2 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awregion  : out std_logic_vector(3 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_awqos : out std_logic_vector(3 downto 0);                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_awvalid   : out std_logic;                                                   -- only for DDR3_USED=TRUE
        axi_card_mem0_awready   : in std_logic;                                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_wdata : out std_logic_vector(C_AXI_CARD_MEM0_DATA_WIDTH-1 downto 0);         -- only for DDR3_USED=TRUE
        axi_card_mem0_wstrb : out std_logic_vector(C_AXI_CARD_MEM0_DATA_WIDTH/8-1 downto 0);       -- only for DDR3_USED=TRUE
        axi_card_mem0_wlast : out std_logic;                                                       -- only for DDR3_USED=TRUE
        axi_card_mem0_wvalid    : out std_logic;                                                   -- only for DDR3_USED=TRUE
        axi_card_mem0_wready    : in std_logic;                                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_bresp : in std_logic_vector(1 downto 0);                                     -- only for DDR3_USED=TRUE
        axi_card_mem0_bvalid    : in std_logic;                                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_bready    : out std_logic;                                                   -- only for DDR3_USED=TRUE
        axi_card_mem0_araddr    : out std_logic_vector(C_AXI_CARD_MEM0_ADDR_WIDTH-1 downto 0);     -- only for DDR3_USED=TRUE
        axi_card_mem0_arlen : out std_logic_vector(7 downto 0);                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_arsize    : out std_logic_vector(2 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arburst   : out std_logic_vector(1 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arlock    : out std_logic_vector(0 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arcache   : out std_logic_vector(3 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arprot    : out std_logic_vector(2 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arregion  : out std_logic_vector(3 downto 0);                                -- only for DDR3_USED=TRUE
        axi_card_mem0_arqos : out std_logic_vector(3 downto 0);                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_arvalid   : out std_logic;                                                   -- only for DDR3_USED=TRUE
        axi_card_mem0_arready   : in std_logic;                                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_rdata : in std_logic_vector(C_AXI_CARD_MEM0_DATA_WIDTH-1 downto 0);          -- only for DDR3_USED=TRUE
        axi_card_mem0_rresp : in std_logic_vector(1 downto 0);                                     -- only for DDR3_USED=TRUE
        axi_card_mem0_rlast : in std_logic;                                                        -- only for DDR3_USED=TRUE
        axi_card_mem0_rvalid    : in std_logic;                                                    -- only for DDR3_USED=TRUE
        axi_card_mem0_rready    : out std_logic;                                                   -- only for DDR3_USED=TRUE
--      axi_card_mem0_error : out std_logic;                                                       -- only for DDR3_USED=TRUE
        axi_card_mem0_arid  : out std_logic_vector(C_AXI_CARD_MEM0_ID_WIDTH-1 downto 0);           -- only for DDR3_USED=TRUE
        axi_card_mem0_aruser    : out std_logic_vector(C_AXI_CARD_MEM0_ARUSER_WIDTH-1 downto 0);   -- only for DDR3_USED=TRUE
        axi_card_mem0_awid  : out std_logic_vector(C_AXI_CARD_MEM0_ID_WIDTH-1 downto 0);           -- only for DDR3_USED=TRUE
        axi_card_mem0_awuser    : out std_logic_vector(C_AXI_CARD_MEM0_AWUSER_WIDTH-1 downto 0);   -- only for DDR3_USED=TRUE
        axi_card_mem0_bid   : in std_logic_vector(C_AXI_CARD_MEM0_ID_WIDTH-1 downto 0);            -- only for DDR3_USED=TRUE
        axi_card_mem0_buser : in std_logic_vector(C_AXI_CARD_MEM0_BUSER_WIDTH-1 downto 0);         -- only for DDR3_USED=TRUE
        axi_card_mem0_rid   : in std_logic_vector(C_AXI_CARD_MEM0_ID_WIDTH-1 downto 0);            -- only for DDR3_USED=TRUE
        axi_card_mem0_ruser : in std_logic_vector(C_AXI_CARD_MEM0_RUSER_WIDTH-1 downto 0);         -- only for DDR3_USED=TRUE
        axi_card_mem0_wuser : out std_logic_vector(C_AXI_CARD_MEM0_WUSER_WIDTH-1 downto 0);        -- only for DDR3_USED=TRUE

        -- Ports of Axi Slave Bus Interface AXI_CTRL_REG
        axi_ctrl_reg_awaddr : in std_logic_vector(C_AXI_CTRL_REG_ADDR_WIDTH-1 downto 0);
        -- axi_ctrl_reg_awprot : in std_logic_vector(2 downto 0);
        axi_ctrl_reg_awvalid    : in std_logic;
        axi_ctrl_reg_awready    : out std_logic;
        axi_ctrl_reg_wdata  : in std_logic_vector(C_AXI_CTRL_REG_DATA_WIDTH-1 downto 0);
        axi_ctrl_reg_wstrb  : in std_logic_vector((C_AXI_CTRL_REG_DATA_WIDTH/8)-1 downto 0);
        axi_ctrl_reg_wvalid : in std_logic;
        axi_ctrl_reg_wready : out std_logic;
        axi_ctrl_reg_bresp  : out std_logic_vector(1 downto 0);
        axi_ctrl_reg_bvalid : out std_logic;
        axi_ctrl_reg_bready : in std_logic;
        axi_ctrl_reg_araddr : in std_logic_vector(C_AXI_CTRL_REG_ADDR_WIDTH-1 downto 0);
        -- axi_ctrl_reg_arprot : in std_logic_vector(2 downto 0);
        axi_ctrl_reg_arvalid    : in std_logic;
        axi_ctrl_reg_arready    : out std_logic;
        axi_ctrl_reg_rdata  : out std_logic_vector(C_AXI_CTRL_REG_DATA_WIDTH-1 downto 0);
        axi_ctrl_reg_rresp  : out std_logic_vector(1 downto 0);
        axi_ctrl_reg_rvalid : out std_logic;
        axi_ctrl_reg_rready : in std_logic;
        interrupt           : out std_logic;

        -- Ports of Axi Master Bus Interface AXI_HOST_MEM
                -- to HOST memory
        axi_host_mem_awaddr : out std_logic_vector(C_AXI_HOST_MEM_ADDR_WIDTH-1 downto 0);
        axi_host_mem_awlen  : out std_logic_vector(7 downto 0);
        axi_host_mem_awsize : out std_logic_vector(2 downto 0);
        axi_host_mem_awburst    : out std_logic_vector(1 downto 0);
        axi_host_mem_awlock : out std_logic_vector(0 downto 0);
        axi_host_mem_awcache    : out std_logic_vector(3 downto 0);
        axi_host_mem_awprot : out std_logic_vector(2 downto 0);
        axi_host_mem_awregion   : out std_logic_vector(3 downto 0);
        axi_host_mem_awqos  : out std_logic_vector(3 downto 0);
        axi_host_mem_awvalid    : out std_logic;
        axi_host_mem_awready    : in std_logic;
        axi_host_mem_wdata  : out std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH-1 downto 0);
        axi_host_mem_wstrb  : out std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH/8-1 downto 0);
        axi_host_mem_wlast  : out std_logic;
        axi_host_mem_wvalid : out std_logic;
        axi_host_mem_wready : in std_logic;
        axi_host_mem_bresp  : in std_logic_vector(1 downto 0);
        axi_host_mem_bvalid : in std_logic;
        axi_host_mem_bready : out std_logic;
        axi_host_mem_araddr : out std_logic_vector(C_AXI_HOST_MEM_ADDR_WIDTH-1 downto 0);
        axi_host_mem_arlen  : out std_logic_vector(7 downto 0);
        axi_host_mem_arsize : out std_logic_vector(2 downto 0);
        axi_host_mem_arburst    : out std_logic_vector(1 downto 0);
        axi_host_mem_arlock : out std_logic_vector(0 downto 0);
        axi_host_mem_arcache    : out std_logic_vector(3 downto 0);
        axi_host_mem_arprot : out std_logic_vector(2 downto 0);
        axi_host_mem_arregion   : out std_logic_vector(3 downto 0);
        axi_host_mem_arqos  : out std_logic_vector(3 downto 0);
        axi_host_mem_arvalid    : out std_logic;
        axi_host_mem_arready    : in std_logic;
        axi_host_mem_rdata  : in std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH-1 downto 0);
        axi_host_mem_rresp  : in std_logic_vector(1 downto 0);
        axi_host_mem_rlast  : in std_logic;
        axi_host_mem_rvalid : in std_logic;
        axi_host_mem_rready : out std_logic;
--      axi_host_mem_error  : out std_logic;
        axi_host_mem_arid   : out std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
        axi_host_mem_aruser : out std_logic_vector(C_AXI_HOST_MEM_ARUSER_WIDTH-1 downto 0);
        axi_host_mem_awid   : out std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
        axi_host_mem_awuser : out std_logic_vector(C_AXI_HOST_MEM_AWUSER_WIDTH-1 downto 0);
        axi_host_mem_bid    : in std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
        axi_host_mem_buser  : in std_logic_vector(C_AXI_HOST_MEM_BUSER_WIDTH-1 downto 0);
        axi_host_mem_rid    : in std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
        axi_host_mem_ruser  : in std_logic_vector(C_AXI_HOST_MEM_RUSER_WIDTH-1 downto 0);
        axi_host_mem_wuser  : out std_logic_vector(C_AXI_HOST_MEM_WUSER_WIDTH-1 downto 0)
);
end action_memcopy;

architecture action_memcopy of action_memcopy is



        type   fsm_app_t    is (IDLE, JUST_COUNT_DOWN, WAIT_FOR_MEMCOPY_DONE);
        type   fsm_copy_t   is (IDLE, PROCESS_COPY, PROCESS_FILL, WAIT_FOR_WRITE_DONE);

        signal fsm_app_q        : fsm_app_t;
        signal fsm_copy_q       : fsm_copy_t;

        signal reg_0x10         : std_logic_vector(31 downto 0);
        signal reg_0x14         : std_logic_vector(31 downto 0);
        signal reg_0x18         : std_logic_vector(31 downto 0);
        signal reg_0x1c         : std_logic_vector(31 downto 0);
        signal reg_0x20         : std_logic_vector(31 downto 0);
        signal reg_0x24         : std_logic_vector(31 downto 0);
        signal app_start        : std_logic;
        signal app_done         : std_logic;
        signal app_ready        : std_logic;
        signal app_idle         : std_logic;
        signal counter          : std_logic_vector( 7 downto 0);
        signal counter_q        : std_logic_vector(31 downto 0);
        signal mem_wr           : std_logic;                                             -- only for DDR3_USED=TRUE
        signal mem_wr_addr      : std_logic_vector(  7 downto 0);                        -- only for DDR3_USED=TRUE
        signal mem_rd_addr      : std_logic_vector(  7 downto 0);                        -- only for DDR3_USED=TRUE
        signal mem_rd_addr_real : std_logic_vector(  7 downto 0);                        -- only for DDR3_USED=TRUE
        signal mem_wr_data      : std_logic_vector(511 downto 0);                        -- only for DDR3_USED=TRUE
        signal mem_rd_data      : std_logic_vector(511 downto 0);                        -- only for DDR3_USED=TRUE

        signal dma_rd_req        : std_logic;
        signal dma_rd_req_ack    : std_logic;
        signal rd_addr           : std_logic_vector( 63 downto 0);
        signal rd_len            : std_logic_vector(  7 downto 0);
        signal dma_rd_data       : std_logic_vector(511 downto 0);
        signal dma_rd_data_valid : std_logic;
        signal dma_rd_data_taken : std_logic;

        signal dma_wr_req        : std_logic;
        signal dma_wr_req_ack    : std_logic;
        signal wr_addr           : std_logic_vector( 63 downto 0);
        signal wr_len            : std_logic_vector(  7 downto 0);
        signal wr_data           : std_logic_vector(511 downto 0);
        signal dma_wr_data_strobe: std_logic_vector( 63  downto 0);
        signal dma_wr_data_valid : std_logic;
        signal dma_wr_data_last  : std_logic;
        signal dma_wr_ready      : std_logic;
        signal dma_wr_bready     : std_logic;
        signal dma_wr_done       : std_logic;

        signal ddr_rd_req        : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_rd_req_ack    : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_rd_data       : std_logic_vector(511 downto 0);                       -- only for DDR3_USED=TRUE
        signal ddr_rd_data_valid : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_rd_data_taken : std_logic;                                            -- only for DDR3_USED=TRUE

        signal ddr_wr_req        : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_ready      : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_bready     : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_req_ack    : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_data_strobe: std_logic_vector(63 downto 0);                        -- only for DDR3_USED=TRUE
        signal ddr_wr_data_valid : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_data_last  : std_logic;                                            -- only for DDR3_USED=TRUE
        signal ddr_wr_done       : std_logic;                                            -- only for DDR3_USED=TRUE

        signal memcopy           : boolean;
        signal start_copy        : std_logic;
        signal start_fill        : std_logic;
        signal last_write_done   : std_logic;
        signal src_host          : std_logic;
        signal src_ddr           : std_logic;                                            -- only for DDR3_USED=TRUE
        signal dest_host         : std_logic;
        signal dest_ddr          : std_logic;                                            -- only for DDR3_USED=TRUE

        signal blocks_to_write   : std_logic_vector(31 downto 0);
        signal blocks_expected   : std_logic_vector(31 downto 0);
        signal blocks_to_set     : std_logic_vector(31 downto 0);
        signal blocks_to_read    : std_logic_vector(31 downto 0);
        signal first_max_blk_r   : std_logic_vector(31 downto 0);
        signal first_blk_r       : std_logic_vector(31 downto 0);
        signal first_max_blk_w   : std_logic_vector(31 downto 0);
        signal first_blk_w       : std_logic_vector(31 downto 0);
        signal write_counter_up  : std_logic_vector(31 downto 0);
        signal total_write_count : std_logic_vector(31 downto 0);
        signal write_counter_dn  : std_logic_vector(25 downto 0);
        signal head              : integer range 0 to 2;
        signal tail              : integer range 0 to 2;
        signal reg0_valid        : std_logic;
        signal reg1_valid        : std_logic;
        signal reg2_valid        : std_logic;
        signal reg0_data         : std_logic_vector(511 downto 0);
        signal reg1_data         : std_logic_vector(511 downto 0);
        signal reg2_data         : std_logic_vector(511 downto 0);
        signal wr_req_count      : integer;
        signal wr_done_count     : integer;
        signal rd_data_taken     : std_logic;
        signal rd_req_ack        : std_logic;
        signal wr_req_ack        : std_logic;
        signal rd_requests_done  : std_logic;
        signal wr_requests_done  : std_logic;
        signal rd_addr_adder     : std_logic_vector(15 downto 0);
        signal wr_addr_adder     : std_logic_vector(15 downto 0);
        signal first_write_mask  : std_logic_vector(63 downto 0);
        signal last_write_mask   : std_logic_vector(63 downto 0);
        signal block_diff        : std_logic_vector(63 downto 0);
        signal last_write        : std_logic;
        signal last_write_q      : std_logic;
        signal first_write_q     : std_logic;
        signal wr_gate           : std_logic;
        


        function or_reduce (signal arg : std_logic_vector) return std_logic is
          variable result : std_logic;

        begin
          result := '0';
          for i in arg'low to arg'high loop
            result := result or arg(i);
          end loop;  -- i
          return result;
        end or_reduce;


begin

--  axi_card_mem0_error  <= '0';
--  axi_host_mem_error   <= '0';

--  reg_0x10 <= x"0000_0108";

-- Instantiation of Axi Bus Interface AXI_CTRL_REG
action_axi_slave_inst : entity work.action_axi_slave
    generic map (
        C_S_AXI_DATA_WIDTH  => C_AXI_CTRL_REG_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH  => C_AXI_CTRL_REG_ADDR_WIDTH
    )
    port map (
        -- config reg ; bit 0 => disable dma and
        -- just count down the length regsiter
        reg_0x10_o      => reg_0x10,
        -- low order source address
        reg_0x14_o      => reg_0x14,
        -- high order source  address
        reg_0x18_o      => reg_0x18,
        -- low order destination address
        reg_0x1c_o      => reg_0x1c,
        -- high order destination address
        reg_0x20_o      => reg_0x20,
        -- number of bytes to copy
        reg_0x24_o      => reg_0x24,
        app_start_o     => app_start,
        app_done_i      => app_done,
        app_ready_i     => app_ready,
        app_idle_i      => app_idle,
        -- User ports ends
        S_AXI_ACLK  => action_clk,
        S_AXI_ARESETN   => action_rst_n,
        S_AXI_AWADDR    => axi_ctrl_reg_awaddr,
        -- S_AXI_AWPROT    => axi_ctrl_reg_awprot,
        S_AXI_AWVALID   => axi_ctrl_reg_awvalid,
        S_AXI_AWREADY   => axi_ctrl_reg_awready,
        S_AXI_WDATA => axi_ctrl_reg_wdata,
        S_AXI_WSTRB => axi_ctrl_reg_wstrb,
        S_AXI_WVALID    => axi_ctrl_reg_wvalid,
        S_AXI_WREADY    => axi_ctrl_reg_wready,
        S_AXI_BRESP => axi_ctrl_reg_bresp,
        S_AXI_BVALID    => axi_ctrl_reg_bvalid,
        S_AXI_BREADY    => axi_ctrl_reg_bready,
        S_AXI_ARADDR    => axi_ctrl_reg_araddr,
        -- S_AXI_ARPROT    => axi_ctrl_reg_arprot,
        S_AXI_ARVALID   => axi_ctrl_reg_arvalid,
        S_AXI_ARREADY   => axi_ctrl_reg_arready,
        S_AXI_RDATA => axi_ctrl_reg_rdata,
        S_AXI_RRESP => axi_ctrl_reg_rresp,
        S_AXI_RVALID    => axi_ctrl_reg_rvalid,
        S_AXI_RREADY    => axi_ctrl_reg_rready
    );

-- Instantiation of Axi Bus Interface AXI_HOST_MEM
action_dma_axi_master_inst : entity work.action_axi_master
    generic map (


        C_M_AXI_ID_WIDTH    => C_AXI_HOST_MEM_ID_WIDTH,
        C_M_AXI_ADDR_WIDTH  => C_AXI_HOST_MEM_ADDR_WIDTH,
        C_M_AXI_DATA_WIDTH  => C_AXI_HOST_MEM_DATA_WIDTH,
        C_M_AXI_AWUSER_WIDTH    => C_AXI_HOST_MEM_AWUSER_WIDTH,
        C_M_AXI_ARUSER_WIDTH    => C_AXI_HOST_MEM_ARUSER_WIDTH,
        C_M_AXI_WUSER_WIDTH => C_AXI_HOST_MEM_WUSER_WIDTH,
        C_M_AXI_RUSER_WIDTH => C_AXI_HOST_MEM_RUSER_WIDTH,
        C_M_AXI_BUSER_WIDTH => C_AXI_HOST_MEM_BUSER_WIDTH
    )
    port map (

        dma_rd_req_i            => dma_rd_req,
        dma_rd_addr_i           => rd_addr,
        dma_rd_len_i            => rd_len,
        dma_rd_req_ack_o        => dma_rd_req_ack,
        dma_rd_data_o           => dma_rd_data,
        dma_rd_data_valid_o     => dma_rd_data_valid,
        dma_rd_data_taken_i     => dma_rd_data_taken,

        dma_wr_req_i            => dma_wr_req,
        dma_wr_addr_i           => wr_addr,
        dma_wr_len_i            => wr_len,
        dma_wr_req_ack_o        => dma_wr_req_ack,
        dma_wr_data_i           => wr_data,
        dma_wr_data_strobe_i    => dma_wr_data_strobe,
        dma_wr_data_last_i      => dma_wr_data_last,
        dma_wr_ready_o          => dma_wr_ready,
        dma_wr_bready_i         => dma_wr_bready,
        dma_wr_done_o           => dma_wr_done,


        M_AXI_ACLK  => action_clk,
        M_AXI_ARESETN   => action_rst_n,
        M_AXI_AWID  => axi_host_mem_awid,
        M_AXI_AWADDR    => axi_host_mem_awaddr,
        M_AXI_AWLEN => axi_host_mem_awlen,
        M_AXI_AWSIZE    => axi_host_mem_awsize,
        M_AXI_AWBURST   => axi_host_mem_awburst,
        M_AXI_AWLOCK    => axi_host_mem_awlock(0),
        M_AXI_AWCACHE   => axi_host_mem_awcache,
        M_AXI_AWPROT    => axi_host_mem_awprot,
        M_AXI_AWQOS => axi_host_mem_awqos,
        M_AXI_AWUSER    => axi_host_mem_awuser,
        M_AXI_AWVALID   => axi_host_mem_awvalid,
        M_AXI_AWREADY   => axi_host_mem_awready,
        M_AXI_WDATA => axi_host_mem_wdata,
        M_AXI_WSTRB => axi_host_mem_wstrb,
        M_AXI_WLAST => axi_host_mem_wlast,
        M_AXI_WUSER => axi_host_mem_wuser,
        M_AXI_WVALID    => axi_host_mem_wvalid,
        M_AXI_WREADY    => axi_host_mem_wready,
        M_AXI_BID   => axi_host_mem_bid,
        M_AXI_BRESP => axi_host_mem_bresp,
        M_AXI_BUSER => axi_host_mem_buser,
        M_AXI_BVALID    => axi_host_mem_bvalid,
        M_AXI_BREADY    => axi_host_mem_bready,
        M_AXI_ARID  => axi_host_mem_arid,
        M_AXI_ARADDR    => axi_host_mem_araddr,
        M_AXI_ARLEN => axi_host_mem_arlen,
        M_AXI_ARSIZE    => axi_host_mem_arsize,
        M_AXI_ARBURST   => axi_host_mem_arburst,
        M_AXI_ARLOCK    => axi_host_mem_arlock(0),
        M_AXI_ARCACHE   => axi_host_mem_arcache,
        M_AXI_ARPROT    => axi_host_mem_arprot,
        M_AXI_ARQOS => axi_host_mem_arqos,
        M_AXI_ARUSER    => axi_host_mem_aruser,
        M_AXI_ARVALID   => axi_host_mem_arvalid,
        M_AXI_ARREADY   => axi_host_mem_arready,
        M_AXI_RID   => axi_host_mem_rid,
        M_AXI_RDATA => axi_host_mem_rdata,
        M_AXI_RRESP => axi_host_mem_rresp,
        M_AXI_RLAST => axi_host_mem_rlast,
        M_AXI_RUSER => axi_host_mem_ruser,
        M_AXI_RVALID    => axi_host_mem_rvalid,
        M_AXI_RREADY    => axi_host_mem_rready
    );

-- Instantiation of Axi Bus Interface AXI_CARD_MEM0                                                -- only for DDR3_USED=TRUE
action_ddr_axi_master_inst : entity work.action_axi_master                                         -- only for DDR3_USED=TRUE
    generic map (                                                                                  -- only for DDR3_USED=TRUE


        C_M_AXI_ID_WIDTH    => C_AXI_CARD_MEM0_ID_WIDTH,                                           -- only for DDR3_USED=TRUE
        C_M_AXI_ADDR_WIDTH  => C_AXI_CARD_MEM0_ADDR_WIDTH,                                         -- only for DDR3_USED=TRUE
        C_M_AXI_DATA_WIDTH  => C_AXI_CARD_MEM0_DATA_WIDTH,                                         -- only for DDR3_USED=TRUE
        C_M_AXI_AWUSER_WIDTH    => C_AXI_CARD_MEM0_AWUSER_WIDTH,                                   -- only for DDR3_USED=TRUE
        C_M_AXI_ARUSER_WIDTH    => C_AXI_CARD_MEM0_ARUSER_WIDTH,                                   -- only for DDR3_USED=TRUE
        C_M_AXI_WUSER_WIDTH => C_AXI_CARD_MEM0_WUSER_WIDTH,                                        -- only for DDR3_USED=TRUE
        C_M_AXI_RUSER_WIDTH => C_AXI_CARD_MEM0_RUSER_WIDTH,                                        -- only for DDR3_USED=TRUE
        C_M_AXI_BUSER_WIDTH => C_AXI_CARD_MEM0_BUSER_WIDTH                                         -- only for DDR3_USED=TRUE
    )                                                                                              -- only for DDR3_USED=TRUE
    port map (                                                                                     -- only for DDR3_USED=TRUE

      dma_rd_req_i            => ddr_rd_req,                                             -- only for DDR3_USED=TRUE
      dma_rd_addr_i           => rd_addr(C_AXI_CARD_MEM0_ADDR_WIDTH -1 downto 0),        -- only for DDR3_USED=TRUE
      dma_rd_len_i            => rd_len,                                                 -- only for DDR3_USED=TRUE
      dma_rd_req_ack_o        => ddr_rd_req_ack,                                         -- only for DDR3_USED=TRUE
      dma_rd_data_o           => ddr_rd_data,                                            -- only for DDR3_USED=TRUE
      dma_rd_data_valid_o     => ddr_rd_data_valid,                                      -- only for DDR3_USED=TRUE
      dma_rd_data_taken_i     => ddr_rd_data_taken,                                      -- only for DDR3_USED=TRUE

      dma_wr_req_i            => ddr_wr_req,                                             -- only for DDR3_USED=TRUE
      dma_wr_addr_i           => wr_addr(C_AXI_CARD_MEM0_ADDR_WIDTH -1 downto 0),        -- only for DDR3_USED=TRUE
      dma_wr_len_i            => wr_len,                                                 -- only for DDR3_USED=TRUE
      dma_wr_req_ack_o        => ddr_wr_req_ack,                                         -- only for DDR3_USED=TRUE
      dma_wr_data_i           => wr_data,                                                -- only for DDR3_USED=TRUE
      dma_wr_data_strobe_i    => ddr_wr_data_strobe,                                     -- only for DDR3_USED=TRUE
      dma_wr_data_last_i      => ddr_wr_data_last,                                       -- only for DDR3_USED=TRUE
      dma_wr_ready_o          => ddr_wr_ready,                                           -- only for DDR3_USED=TRUE
      dma_wr_bready_i         => ddr_wr_bready,                                          -- only for DDR3_USED=TRUE
      dma_wr_done_o           => ddr_wr_done,                                            -- only for DDR3_USED=TRUE


        M_AXI_ACLK  => action_clk,                                                                -- only for DDR3_USED=TRUE
        M_AXI_ARESETN   => action_rst_n,                                                          -- only for DDR3_USED=TRUE
        M_AXI_AWID  => axi_card_mem0_awid,                                                        -- only for DDR3_USED=TRUE
        M_AXI_AWADDR    => axi_card_mem0_awaddr,                                                  -- only for DDR3_USED=TRUE
        M_AXI_AWLEN => axi_card_mem0_awlen,                                                       -- only for DDR3_USED=TRUE
        M_AXI_AWSIZE    => axi_card_mem0_awsize,                                                  -- only for DDR3_USED=TRUE
        M_AXI_AWBURST   => axi_card_mem0_awburst,                                                 -- only for DDR3_USED=TRUE
        M_AXI_AWLOCK    => axi_card_mem0_awlock(0),                                               -- only for DDR3_USED=TRUE
        M_AXI_AWCACHE   => axi_card_mem0_awcache,                                                 -- only for DDR3_USED=TRUE
        M_AXI_AWPROT    => axi_card_mem0_awprot,                                                  -- only for DDR3_USED=TRUE
        M_AXI_AWQOS => axi_card_mem0_awqos,                                                       -- only for DDR3_USED=TRUE
        M_AXI_AWUSER    => axi_card_mem0_awuser,                                                  -- only for DDR3_USED=TRUE
        M_AXI_AWVALID   => axi_card_mem0_awvalid,                                                 -- only for DDR3_USED=TRUE
        M_AXI_AWREADY   => axi_card_mem0_awready,                                                 -- only for DDR3_USED=TRUE
        M_AXI_WDATA => axi_card_mem0_wdata,                                                       -- only for DDR3_USED=TRUE
        M_AXI_WSTRB => axi_card_mem0_wstrb,                                                       -- only for DDR3_USED=TRUE
        M_AXI_WLAST => axi_card_mem0_wlast,                                                       -- only for DDR3_USED=TRUE
        M_AXI_WUSER => axi_card_mem0_wuser,                                                       -- only for DDR3_USED=TRUE
        M_AXI_WVALID    => axi_card_mem0_wvalid,                                                  -- only for DDR3_USED=TRUE
        M_AXI_WREADY    => axi_card_mem0_wready,                                                  -- only for DDR3_USED=TRUE
        M_AXI_BID   => axi_card_mem0_bid,                                                         -- only for DDR3_USED=TRUE
        M_AXI_BRESP => axi_card_mem0_bresp,                                                       -- only for DDR3_USED=TRUE
        M_AXI_BUSER => axi_card_mem0_buser,                                                       -- only for DDR3_USED=TRUE
        M_AXI_BVALID    => axi_card_mem0_bvalid,                                                  -- only for DDR3_USED=TRUE
        M_AXI_BREADY    => axi_card_mem0_bready,                                                  -- only for DDR3_USED=TRUE
        M_AXI_ARID  => axi_card_mem0_arid,                                                        -- only for DDR3_USED=TRUE
        M_AXI_ARADDR    => axi_card_mem0_araddr,                                                  -- only for DDR3_USED=TRUE
        M_AXI_ARLEN => axi_card_mem0_arlen,                                                       -- only for DDR3_USED=TRUE
        M_AXI_ARSIZE    => axi_card_mem0_arsize,                                                  -- only for DDR3_USED=TRUE
        M_AXI_ARBURST   => axi_card_mem0_arburst,                                                 -- only for DDR3_USED=TRUE
        M_AXI_ARLOCK    => axi_card_mem0_arlock(0),                                               -- only for DDR3_USED=TRUE
        M_AXI_ARCACHE   => axi_card_mem0_arcache,                                                 -- only for DDR3_USED=TRUE
        M_AXI_ARPROT    => axi_card_mem0_arprot,                                                  -- only for DDR3_USED=TRUE
        M_AXI_ARQOS => axi_card_mem0_arqos,                                                       -- only for DDR3_USED=TRUE
        M_AXI_ARUSER    => axi_card_mem0_aruser,                                                  -- only for DDR3_USED=TRUE
        M_AXI_ARVALID   => axi_card_mem0_arvalid,                                                 -- only for DDR3_USED=TRUE
        M_AXI_ARREADY   => axi_card_mem0_arready,                                                 -- only for DDR3_USED=TRUE
        M_AXI_RID   => axi_card_mem0_rid,                                                         -- only for DDR3_USED=TRUE
        M_AXI_RDATA => axi_card_mem0_rdata,                                                       -- only for DDR3_USED=TRUE
        M_AXI_RRESP => axi_card_mem0_rresp,                                                       -- only for DDR3_USED=TRUE
        M_AXI_RLAST => axi_card_mem0_rlast,                                                       -- only for DDR3_USED=TRUE
        M_AXI_RUSER => axi_card_mem0_ruser,                                                       -- only for DDR3_USED=TRUE
        M_AXI_RVALID    => axi_card_mem0_rvalid,                                                  -- only for DDR3_USED=TRUE
        M_AXI_RREADY    => axi_card_mem0_rready                                                   -- only for DDR3_USED=TRUE
    );                                                                                            -- only for DDR3_USED=TRUE



        process(action_clk ) is
    begin
      if (rising_edge (action_clk)) then
            start_copy          <= '0';
            start_fill          <= '0';
            if reg_0x10(3 downto 0) = x"2" or reg_0x10(3 downto 0) = x"3" or
               reg_0x10(3 downto 0) = x"4" or reg_0x10(3 downto 0) = x"5"   then
              memcopy <= true;
            else
              memcopy <= false;
            end if;
        if ( action_rst_n = '0' ) then
              fsm_app_q         <= IDLE;
              app_ready         <= '0';
              app_idle          <= '0';
            else
              app_done          <= '0';
              app_idle          <= '0';
              app_ready         <= '1';
              case fsm_app_q is
                when IDLE  =>
                  app_idle <= '1';

                  if app_start = '1' then
                    src_ddr   <= '0';                                                    -- only for DDR3_USED=TRUE
                    src_host  <= '0';
                    dest_ddr  <= '0';                                                    -- only for DDR3_USED=TRUE
                    dest_host <= '0';
                    case reg_0x10(3 downto 0) is

                      when x"1" =>
                        -- just count a counter down
                        fsm_app_q  <= JUST_COUNT_DOWN;
                        counter_q  <= reg_0x24;

                       when x"2" =>
                        -- memcopy host to host memory
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;
                        src_host   <= '1';
                        dest_host  <= '1';
                        start_copy <= '1';


                       when x"8" =>
                        -- host memory fill
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;
                        dest_host  <= '1';
                        start_fill <= '1';

                       when x"9" =>                                                      -- only for DDR3_USED=TRUE   
                        -- DDR memory fill                                               -- only for DDR3_USED=TRUE
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;                             -- only for DDR3_USED=TRUE
                        dest_ddr   <= '1';                                               -- only for DDR3_USED=TRUE
                        start_fill <= '1';                                               -- only for DDR3_USED=TRUE

                       when x"3" =>                                                      -- only for DDR3_USED=TRUE
                        -- memcopy host to DDR memory                                    -- only for DDR3_USED=TRUE
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;                             -- only for DDR3_USED=TRUE
                        src_host   <= '1';                                               -- only for DDR3_USED=TRUE
                        dest_ddr   <= '1';                                               -- only for DDR3_USED=TRUE
                        start_copy <= '1';                                               -- only for DDR3_USED=TRUE

                       when x"4" =>                                                      -- only for DDR3_USED=TRUE
                        -- memcopy DDR to host memory                                    -- only for DDR3_USED=TRUE
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;                             -- only for DDR3_USED=TRUE
                        src_ddr    <= '1';                                               -- only for DDR3_USED=TRUE
                        dest_host  <= '1';                                               -- only for DDR3_USED=TRUE
                        start_copy <= '1';                                               -- only for DDR3_USED=TRUE

                       when x"5" =>                                                      -- only for DDR3_USED=TRUE
                        -- memcopy DDR to DDR memory                                     -- only for DDR3_USED=TRUE
                        fsm_app_q  <= WAIT_FOR_MEMCOPY_DONE;                             -- only for DDR3_USED=TRUE
                        src_ddr    <= '1';                                               -- only for DDR3_USED=TRUE
                        dest_ddr   <= '1';                                               -- only for DDR3_USED=TRUE
                        start_copy <= '1';                                               -- only for DDR3_USED=TRUE

                       when others =>
                         app_done   <= '1';

                    end case;
                  end if ;

                when  JUST_COUNT_DOWN =>
                  if counter_q > x"0000_0001" then
                    counter_q <= counter_q - '1';
                  else
                    app_done   <= '1';
                    fsm_app_q  <= IDLE;
                  end if;

                when WAIT_FOR_MEMCOPY_DONE =>
                  if last_write_done = '1' then
                    app_done   <= '1';
                    fsm_app_q  <= IDLE;
                  end if;


                when others => null;
              end case;
        end if;
      end if;
    end process;

  rd_req_ack <= dma_rd_req_ack
                when src_host  = '1' else ddr_rd_req_ack                                 -- only for DDR3_USED=TRUE
                ;
  wr_req_ack <= dma_wr_req_ack
                when dest_host = '1' else ddr_wr_req_ack                                 -- only for DDR3_USED=TRUE
                ;

    process(action_clk) is
    variable j,k : integer range 0 to 63;
    begin
       if (rising_edge (action_clk)) then
          j := to_integer(unsigned(reg_0x14(5 downto 0)));
          for x in 0 to 63 loop
            if x >= j then
              first_write_mask(x) <= '1';
            else
              first_write_mask(x) <= '0';
            end if;
          end loop;  -- x
          k := to_integer(unsigned(reg_0x1C(5 downto 0)));
          for x in 0 to 63 loop
            if x > k then
              last_write_mask(x) <= '0';
            else
              last_write_mask(x) <= '1';
            end if;
          end loop;  -- x
       end if;  
    end process;  


    block_diff <= "000000" & ((reg_0x20 & reg_0x1c(31 downto 6)) - (reg_0x18 & reg_0x14(31 downto 6)));

    process(action_clk ) is
     variable temp64 : std_logic_vector(63 downto 0);
    begin
      if (rising_edge (action_clk)) then
        last_write_done   <= '0';
        mem_wr            <= '0';                                                    -- only for DDR3_USED=TRUE
        if ( action_rst_n = '0' ) then
              fsm_copy_q         <= IDLE;
              dma_rd_req         <= '0';
              dma_wr_req         <= '0';
              dma_wr_bready      <= '0';
              ddr_rd_req         <= '0';                                                 -- only for DDR3_USED=TRUE
              ddr_wr_req         <= '0';                                                 -- only for DDR3_USED=TRUE
              ddr_wr_bready      <= '0';                                                 -- only for DDR3_USED=TRUE
              wr_gate            <= '0';
            else
              case fsm_copy_q is
                when IDLE =>
                  wr_req_count     <= 0;
                  wr_done_count    <= 0;
                  wr_gate          <= '0';
                  blocks_to_read   <= "000000"   & reg_0x24(31 downto 6);
                  if memcopy then
                    -- memcopy
                    blocks_to_write  <= "000000"   & reg_0x24(31 downto 6);
                    blocks_expected  <= "000000"   & reg_0x24(31 downto 6);
                    first_max_blk_w    <= x"0000_00" & (x"40" - reg_0x1c(11 downto 6));
                  else
                    -- memfill
                    blocks_to_write  <= block_diff(31 downto 0) + 1;
                    blocks_expected  <= block_diff(31 downto 0) + 1;
                    first_max_blk_w    <= x"0000_00" & (x"40" - reg_0x14(11 downto 6));
                  end if;
                  first_max_blk_r    <= x"0000_00" & (x"40" - reg_0x14(11 downto 6));
                  
                 
                  if first_max_blk_r < blocks_to_read then
                    first_blk_r      <= first_max_blk_r;
                  else
                    first_blk_r      <= blocks_to_read;
                  end if;
                  if first_max_blk_w < blocks_to_write then
                    first_blk_w      <= first_max_blk_w;
                  else
                    first_blk_w      <= blocks_to_write ;
                  end if;                    
                  rd_addr            <= reg_0x18 & reg_0x14(31 downto 6) & "000000";
                  if memcopy then
                    wr_addr          <= reg_0x20 & reg_0x1c(31 downto 6) & "000000";
                  else
                    wr_addr          <= reg_0x18 & reg_0x14(31 downto 6) & "000000";
                  end if;
                 
                  rd_requests_done <= '0';
                  wr_requests_done <= '0';
                  rd_len          <= first_blk_r (7 downto 0) - '1';
                  wr_len          <= first_blk_w (7 downto 0) - '1';
                  
                  rd_addr_adder   <= x"1000" - (reg_0x14(11 downto 6) & (5 downto 0 =>'0')); 
                  
                  if start_copy = '1' then
                    wr_addr_adder   <= x"1000" - (reg_0x1c(11 downto 6) & (5 downto 0 =>'0'));
                    blocks_to_read  <= blocks_to_read  -first_blk_r (7 downto 0) ;
                    blocks_to_write <= blocks_to_write -first_blk_w (7 downto 0) ;
                    -- request data either from host or
                    dma_rd_req    <= src_host;
                    ddr_rd_req    <= src_ddr;                                               -- only for DDR3_USED=TRUE
                    dma_wr_req    <= dest_host;
                    dma_wr_bready <= dest_host;
                    ddr_wr_req    <= dest_ddr;                                             -- only for DDR3_USED=TRUE
                    ddr_wr_bready <= dest_ddr;                                             -- only for DDR3_USED=TRUE
                    wr_gate       <= '1';
                    fsm_copy_q    <= PROCESS_COPY;
                  end if;
                  if start_fill = '1' then
                    wr_addr_adder   <= x"1000" - (reg_0x14(11 downto 6) & (5 downto 0 =>'0'));
                    wr_gate         <= '1';
                    blocks_to_write <= blocks_to_write -first_blk_w (7 downto 0) ;
                    dma_wr_req      <= dest_host;
                    dma_wr_bready   <= dest_host;
                    ddr_wr_req      <= dest_ddr;                                         -- only for DDR3_USED=TRUE
                    ddr_wr_bready   <= dest_ddr;                                         -- only for DDR3_USED=TRUE
                    fsm_copy_q      <= PROCESS_FILL;
                  end if;
                  
                when PROCESS_FILL =>
                  if wr_req_ack = '1' and or_reduce(blocks_to_write) = '1' then
                    wr_addr         <= wr_addr + wr_addr_adder;
                    wr_addr_adder   <= x"1000";
                    dma_wr_req      <= dest_host;
                    ddr_wr_req      <= dest_ddr;                                         -- only for DDR3_USED=TRUE
                    if blocks_to_write >  x"0000_0040" then
                      wr_len     <= x"3f";
                      blocks_to_write <= blocks_to_write - x"40";
                    else
                      wr_len         <= blocks_to_write(7 downto 0) - '1';
                      blocks_to_write <= (others => '0');
                    end if;
                  end if;
                  if wr_req_ack = '1' and or_reduce(blocks_to_write) = '0' then
                    dma_wr_req       <= '0';
                    ddr_wr_req       <= '0';                                             -- only for DDR3_USED=TRUE
                    wr_requests_done <= '1';
                    fsm_copy_q       <= WAIT_FOR_WRITE_DONE;
                  end if;

                  
                when PROCESS_COPY =>

                  if rd_req_ack = '1' and or_reduce(blocks_to_read) = '1' then
                    rd_addr          <= rd_addr + rd_addr_adder;
                    rd_addr_adder    <= x"1000";
                    dma_rd_req       <= src_host;
                    ddr_rd_req       <= src_ddr;                                         -- only for DDR3_USED=TRUE
                    if blocks_to_read >  x"0000_0040" then
                      rd_len         <= x"3f";
                      blocks_to_read <= blocks_to_read - x"40";
                    else
                      rd_len         <= blocks_to_read(7 downto 0) - '1';
                      blocks_to_read <= (others => '0');
                    end if;
                  end if;
                  if rd_req_ack = '1' and or_reduce(blocks_to_read) = '0' then
                    dma_rd_req       <= '0';
                    ddr_rd_req       <= '0';                                             -- only for DDR3_USED=TRUE
                    rd_requests_done <= '1';
                  end if;

                  if wr_req_ack = '1' and or_reduce(blocks_to_write) = '1' then
                    wr_addr         <= wr_addr + wr_addr_adder;
                    wr_addr_adder   <= x"1000";
                    dma_wr_req      <= dest_host;
                    ddr_wr_req      <= dest_ddr;                                         -- only for DDR3_USED=TRUE
                    if blocks_to_write >  x"0000_0040" then
                      wr_len     <= x"3f";
                      blocks_to_write <= blocks_to_write - x"40";
                    else
                      wr_len         <= blocks_to_write(7 downto 0) - '1';
                      blocks_to_write <= (others => '0');
                    end if;
                  end if;
                  if wr_req_ack = '1' and or_reduce(blocks_to_write) = '0' then
                    dma_wr_req       <= '0';
                    ddr_wr_req       <= '0';                                             -- only for DDR3_USED=TRUE
                    wr_requests_done <= '1';
                  end if;
                  if rd_requests_done = '1' and wr_requests_done = '1' then
                    fsm_copy_q      <= WAIT_FOR_WRITE_DONE;
                  end if;

                 when WAIT_FOR_WRITE_DONE =>
                   if or_reduce(write_counter_dn) = '0' and wr_req_count = wr_done_count then
                     last_write_done <= '1';
                     fsm_copy_q      <= IDLE;
                     ddr_wr_bready   <= '0';
                     dma_wr_bready   <= '0';
                   end if;

               end case;
               if (dma_wr_done = '1' and dest_host = '1')
                  or (ddr_wr_done = '1' and dest_ddr = '1')                              -- only for DDR3_USED=TRUE
               then
                 wr_done_count <= wr_done_count + 1;
               end if;
               if (dma_wr_req = '1' and dma_wr_req_ack = '1' and dest_host = '1')
                  or (ddr_wr_req = '1' and ddr_wr_req_ack = '1' and dest_ddr  = '1')     -- only for DDR3_USED=TRUE
               then
                 wr_req_count <= wr_req_count + 1;
               end if;
            end if;
          end if;




        end process;
    -- User logic ends

  rd_data_taken <= '1' when (head = 0 and reg0_valid = '0') or
                            (head = 1 and reg1_valid = '0') or
                            (head = 2 and reg2_valid = '0')     else '0';
  dma_rd_data_taken <= rd_data_taken and src_host;
  ddr_rd_data_taken <= rd_data_taken and src_ddr;                                        -- only for DDR3_USED=TRUE

read_write_process:
      process(action_clk ) is
    begin
      if (rising_edge (action_clk)) then
            if start_copy = '1' or action_rst_n = '0' or start_fill = '1' then

              tail              <= 0;
              head              <= 0;
              reg0_valid        <= '0';
	      reg0_data         <= dma_rd_data;   -- assigning reset value in order to get around 'partial antenna' problems
              reg1_valid        <= '0';
	      reg1_data         <= dma_rd_data;   -- assigning reset value in order to get around 'partial antenna' problems
              reg2_valid        <= '0';
	      reg2_data         <= dma_rd_data;   -- assigning reset value in order to get around 'partial antenna' problems
              total_write_count <=(31 downto 1 => '0') & '1';
              if memcopy then
                write_counter_up  <=(31 downto 0 => '0' ) + reg_0x1c(11 downto 6) + 1;
              else
                write_counter_up  <=(31 downto 0 => '0' ) + reg_0x14(11 downto 6) + 1;
              end if;
              
              write_counter_dn  <= blocks_to_write(25 downto 0);
              last_write_q      <= '0';
              first_write_q     <= '1';
            else
              
              if dest_ddr = '1' then
                last_write_q      <= (last_write and ddr_wr_ready and ( dma_wr_data_valid or  ddr_wr_data_valid)) or last_write_q;
              else
                last_write_q      <= (last_write and dma_wr_ready and ( dma_wr_data_valid or  ddr_wr_data_valid)) or last_write_q;
              end if;  
               if head = 0 and reg0_valid = '0' then
                if src_host = '1' then
                  if dma_rd_data_valid = '1' then
                    reg0_data  <= dma_rd_data;
                    reg0_valid <= '1';
                    head       <= 1;
                  end if;
                end if;
                if src_ddr = '1' then                                                    -- only for DDR3_USED=TRUE
                  if ddr_rd_data_valid = '1' then                                        -- only for DDR3_USED=TRUE
                    reg0_data  <= ddr_rd_data;                                           -- only for DDR3_USED=TRUE
                    reg0_valid <= '1';                                                   -- only for DDR3_USED=TRUE
                    head       <= 1;                                                     -- only for DDR3_USED=TRUE
                  end if;                                                                -- only for DDR3_USED=TRUE
                end if;                                                                  -- only for DDR3_USED=TRUE
              end if;
              if head = 1 and reg1_valid = '0' then
                if src_host = '1' then
                   if dma_rd_data_valid = '1' then
                     reg1_data  <= dma_rd_data;
                     reg1_valid <= '1';
                     head            <= 2;
                   end if;
                end if;
                if src_ddr = '1' then                                                    -- only for DDR3_USED=TRUE
                  if ddr_rd_data_valid = '1' then                                        -- only for DDR3_USED=TRUE
                    reg1_data  <= ddr_rd_data;                                           -- only for DDR3_USED=TRUE
                    reg1_valid <= '1';                                                   -- only for DDR3_USED=TRUE
                    head       <= 2;                                                     -- only for DDR3_USED=TRUE
                  end if;                                                                -- only for DDR3_USED=TRUE
                end if;                                                                  -- only for DDR3_USED=TRUE
              end if;

              if head = 2 and reg2_valid = '0' then
                if src_host = '1' then
                   if dma_rd_data_valid = '1' then
                     reg2_data  <= dma_rd_data;
                     reg2_valid <= '1';
                     head       <= 0;
                   end if;
                end if;
                if src_ddr = '1' then                                                    -- only for DDR3_USED=TRUE
                  if ddr_rd_data_valid = '1' then                                        -- only for DDR3_USED=TRUE
                    reg2_data  <= ddr_rd_data;                                           -- only for DDR3_USED=TRUE
                    reg2_valid <= '1';                                                   -- only for DDR3_USED=TRUE
                    head       <= 0;                                                     -- only for DDR3_USED=TRUE
                  end if;                                                                -- only for DDR3_USED=TRUE
                end if;                                                                  -- only for DDR3_USED=TRUE
              end if;
            end if;
            if (dma_wr_data_valid = '1' and dma_wr_ready = '1' and dest_host = '1')
               or (ddr_wr_data_valid = '1' and ddr_wr_ready = '1' and dest_ddr  = '1')   -- only for DDR3_USED=TRUE
            then 
              first_write_q <= '0';
              total_write_count <= total_write_count + '1';
              write_counter_up  <= write_counter_up  + '1';
              write_counter_dn  <= write_counter_dn  - '1';
              if tail = 0 then
                tail <= 1;
                reg0_valid <= '0';
              end if;
              if tail = 1 then
                tail <= 2;
                reg1_valid <= '0';
              end if;
              if tail = 2 then
                tail <= 0;
                reg2_valid <= '0';
              end if;
            end if;

          end if;                       -- rising edge
        end process;

write_data_process:
  process(reg0_data, reg1_data, reg2_data, reg0_valid, reg1_valid, reg2_valid,
          write_counter_up, total_write_count, reg_0x24, reg_0x10, last_write_q,
          dest_ddr,                                                                      -- only for DDR3_USED=TRUE
          dest_host, tail, blocks_expected,wr_gate, memcopy  ) is
    begin
      case tail is
      -- mem copy 
        when 0 =>
          wr_data           <= reg0_data;
          dma_wr_data_valid <= reg0_valid and dest_host;
          ddr_wr_data_valid <= reg0_valid and dest_ddr;                                  -- only for DDR3_USED=TRUE
        when 1 =>
          wr_data           <= reg1_data;
          dma_wr_data_valid <= reg1_valid and dest_host;
          ddr_wr_data_valid <= reg1_valid and dest_ddr;                                  -- only for DDR3_USED=TRUE
        when others =>
          wr_data           <= reg2_data;
          dma_wr_data_valid <= reg2_valid and dest_host;
          ddr_wr_data_valid <= reg2_valid and dest_ddr;                                  -- only for DDR3_USED=TRUE
      end case;
      if not memcopy then
      --  mem fill 
        for i in 1 to 64 loop
          if reg_0x10(23 downto 16) = x"00" then
            wr_data(i * 8 -1 downto (i-1) *8) <= reg_0x10(15 downto 8);
          else
            wr_data(i * 8 -1 downto (i-1) *8) <= std_logic_vector(to_unsigned(i-1, 8));
          end if;
        end loop;  -- i
        dma_wr_data_valid <= not last_write_q and dest_host and wr_gate;
        ddr_wr_data_valid <= not last_write_q and dest_ddr  and wr_gate;                  -- only for DDR3_USED=TRUE
      end if;

      if total_write_count = blocks_expected or
          or_reduce(write_counter_up(5 downto 0)) = '0'                 then
        dma_wr_data_last <= '1' and dest_host;
        ddr_wr_data_last <= '1' and dest_ddr;                                            -- only for DDR3_USED=TRUE
      else
        dma_wr_data_last <= '0';
        ddr_wr_data_last <= '0';                                                         -- only for DDR3_USED=TRUE
      end if;
      if total_write_count >= blocks_expected then
        last_write <= '1';
      else
        last_write <= '0';
      end if;
    end process;

wr_strobes: process(dma_wr_data_valid, memcopy,
                    ddr_wr_data_valid,                                                   -- only for DDR3_USED=TRUE
                    last_write, first_write_q, last_write_mask,first_write_mask  )
  begin
    dma_wr_data_strobe <= (63 downto 0 => '0');
    if dma_wr_data_valid = '1' then
      dma_wr_data_strobe <= (63 downto 0 => '1');
      if last_write = '1' and first_write_q = '0' then
        dma_wr_data_strobe <= last_write_mask; 
      end if;
      if last_write = '0' and first_write_q = '1' then
        dma_wr_data_strobe <= first_write_mask; 
      end if;      
      if last_write = '1' and first_write_q = '1' then
        dma_wr_data_strobe <= first_write_mask and last_write_mask; 
      end if;
      if memcopy  then
        dma_wr_data_strobe <= (63 downto 0 => '1'); 
      end if;
    end if;
    
    ddr_wr_data_strobe <= (63 downto 0 => '0');                          -- only for DDR3_USED=TRUE
    if ddr_wr_data_valid = '1' then                                      -- only for DDR3_USED=TRUE
      ddr_wr_data_strobe <= (63 downto 0 => '1');                        -- only for DDR3_USED=TRUE
      if last_write = '1' and first_write_q = '0' then                   -- only for DDR3_USED=TRUE
        ddr_wr_data_strobe <= last_write_mask;                           -- only for DDR3_USED=TRUE              
      end if;                                                            -- only for DDR3_USED=TRUE
      if last_write = '0' and first_write_q = '1' then                   -- only for DDR3_USED=TRUE
        ddr_wr_data_strobe <= first_write_mask;                          -- only for DDR3_USED=TRUE
      end if;                                                            -- only for DDR3_USED=TRUE
      if last_write = '1' and first_write_q = '1' then                   -- only for DDR3_USED=TRUE
        ddr_wr_data_strobe <= first_write_mask and last_write_mask;      -- only for DDR3_USED=TRUE
      end if;                                                            -- only for DDR3_USED=TRUE
      if memcopy  then
        ddr_wr_data_strobe <= (63 downto 0 => '1'); 
      end if;
    end if;                                                              -- only for DDR3_USED=TRUE
  
  end process;
    
  

  interrupt <= '0';                               -- interrupt line not used

end action_memcopy;

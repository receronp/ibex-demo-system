// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This is the top level that connects the demo system to the virtual devices.
module top_verilator (input logic clk_i, rst_ni);

  localparam ClockFrequency = 50_000_000;
  localparam BaudRate       = 115_200;

  logic uart0_sys_rx, uart0_sys_tx, uart1_sys_rx, uart1_sys_tx;

  // Instantiating the Ibex Demo System.
  ibex_demo_system #(
    .GpiWidth       ( 8                   ),
    .GpoWidth       ( 16                  ),
    .PwmWidth       ( 12                  ),
    .ClockFrequency ( ClockFrequency      ),
    .BaudRate       ( BaudRate            ),
    .RegFile        ( ibex_pkg::RegFileFF )
  ) u_ibex_demo_system (
    //Input
    .clk_sys_i (clk_i),
    .rst_sys_ni(rst_ni),
    .uart0_rx_i (uart0_sys_rx),
    .uart1_rx_i (uart1_sys_rx),

    //Output
    .uart0_tx_o(uart0_sys_tx),
    .uart1_tx_o(uart1_sys_tx),

    // tie off JTAG
    .trst_ni(1'b1),
    .tms_i  (1'b0),
    .tck_i  (1'b0),
    .td_i   (1'b0),
    .td_o   (    ),

    // Remaining IO
    .gp_i      (0),
    .gp_o      ( ),
    .pwm_o     ( ),
    .spi_rx_i  (0),
    .spi_tx_o  ( ),
    .spi_sck_o ( )
  );

  // Virtual UART0
  uartdpi #(
    .BAUD(BaudRate),
    .FREQ(ClockFrequency),
    .NAME("uart0")
  ) u_uartdpi0 (
    .clk_i,
    .rst_ni,
    .active (1'b1       ),
    .tx_o   (uart0_sys_rx),
    .rx_i   (uart0_sys_tx)
  );

  // Virtual UART1
  uartdpi #(
    .BAUD(BaudRate),
    .FREQ(ClockFrequency),
    .NAME("uart1")
  ) u_uartdpi1 (
    .clk_i,
    .rst_ni,
    .active (1'b1       ),
    .tx_o   (uart1_sys_rx),
    .rx_i   (uart1_sys_tx)
  );
endmodule

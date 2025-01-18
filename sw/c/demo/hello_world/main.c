// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdbool.h>

#include "demo_system.h"
#include "gpio.h"
#include "pwm.h"
#include "timer.h"

#define USE_GPIO_SHIFT_REG 0

int putcharUart1(int c) {
  if (c == '\n') {
    uart_out(UART_FROM_BASE_ADDR(UART1_BASE), '\r');
  }
  uart_out(UART_FROM_BASE_ADDR(UART1_BASE), c);

  return c;
}

int putsUart1(const char* str) {
  while (*str) {
    putcharUart1(*str++);
  }

  return 0;
}

int main(void) {
  // This indicates how often the timer gets updated.
  timer_init();
  timer_enable(3000000);

  uint64_t last_elapsed_time = get_elapsed_time();


  while (1) {
    uint64_t cur_time = get_elapsed_time();

    if (cur_time != last_elapsed_time) {
      last_elapsed_time = cur_time;

      // Disable interrupts whilst outputting to prevent output for RX IRQ
      // happening in the middle
      set_global_interrupt_enable(0);

      // Print this to UART (use the screen command to see it).
      puts("I say hi using UART0! ");
      putchar('\n');

      // Print this to UART (use the screen command to see it).
      putsUart1("Student says hi using UART1! ");
      putcharUart1('\n');

      // Re-enable interrupts with output complete
      set_global_interrupt_enable(1);
    }
    asm volatile("wfi");
  }
}

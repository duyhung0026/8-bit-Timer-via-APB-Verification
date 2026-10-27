# 8-bit Timer Verification using SystemVerilog

A layered, self-checking SystemVerilog testbench that verifies an **APB-slave 8-bit timer** (up/down counter, clock divisor, overflow/underflow detection, interrupt). Built with directed tests, a verification plan and functional coverage.

> The RTL and the specification BELONG to **** Training Center and are **not** included in this repository.

## DUT overview

| Item | Description |
|---|---|
| Interface | APB slave, no wait states, no error handling |
| Clocks | `pclk` 50 MHz (registers), `ker_clk` 200 MHz (clock divisor / counter) |
| Counter | 8-bit, count up or down, optional load from TDR |
| Clock divisor | /1, /2, /4, /8 of `ker_clk` (`clk_div` in TCR) |
| Status | Overflow (255 -> 0) and underflow (0 -> 255), R/W1C |
| Interrupt | Per-event enable in TIE, level output |

| Address | Register | Notes |
|---|---|---|
| 0x00 | TCR | `[4:3] clk_div`, `[2] load`, `[1] count_down`, `[0] timer_en` |
| 0x01 | TSR | `[1] underflow`, `[0] overflow` (R/W1C) |
| 0x02 | TDR | Value loaded into the counter when `load=1` |
| 0x03 | TIE | `[1] underflow_en`, `[0] overflow_en` |

## Testbench architecture

```
base_test (write()/read() API, run_scenarios)
 |
 +-- environment
      |-- stimulus --s2d_mb--> driver --(virtual if)--> DUT
      |-- monitor  --m2s_mb--> scoreboard (+ covergroup)
```

| Component | Role |
|---|---|
| `packet` | APB transaction (address, data, read/write) |
| `stimulus` | Sends packets to the driver through a mailbox |
| `driver` | Drives APB SETUP/ACCESS phases, signals `xfer_done` when finished |
| `monitor` | Captures APB transfers and forwards them to the scoreboard |
| `scoreboard` | Receives monitored transfers, samples functional coverage |
| `base_test` | Reusable `write(addr, data)` / `read(addr, ref data)` tasks, shared checking tasks, test flow |
| `dut_if` | Interface with APB signals plus whitebox probes (`cnt`, `clk_in`) |

Design notes:
- Tests use the `write()` / `read()` tasks, which handshake with the driver through the `xfer_done` event, so test code reads like register software.
- Internal counter value and divided clock are observed through probes exposed in `dut_if` (assigned in the top module), because the TDR register does not reflect the live count and `$root` references are not allowed inside package classes.
- Test selection uses `$test$plusargs`.

## Verification plan

The full plan is in Vplan_8_bit_Timer.xlsx. Test groups:

| Group | Scope |
|---|---|
| 1. Register | Default values, write/read, reserved region, reset on the fly |
| 2. Clock divisor | /1, /2, /4, /8 (checks `clk_in` period and counter step) |
| 3. Counter | Count up/down from 0, with load data, overflow/underflow, disable, resume, direction switch while running |
| 4. Interrupt | Overflow/underflow with interrupt enabled/disabled, clear via W1C, both enabled, polling mode |

## Functional coverage

Covergroup in the scoreboard:
- APB transfer type x address
- TCR field crosses (`clk_div`, `count_down`, `timer_en`, `load`)
- TIE enable bits, and TSR status crossed with the interrupt-enable state at read time

Coverage result: `TODO: add % and a screenshot (e.g. docs/coverage.png)`

## How to run

Requirements: QuestaSim (tested with 2021.2).

## Observations

- **Direction change while running (Vplan 3.9):** writing `count_down=1` while `timer_en=1` (outside the spec note) makes the DUT reverse the counting direction immediately, with no glitch around the turning point. The test records this behaviour instead of asserting a fixed expectation.
- TODO: add other findings (with waveform screenshots in `docs/`).

## Repository layout

```
tb/         testbench top, interface, environment, driver, monitor, scoreboard, coverage
testcase/   base_test and test classes
vplan/      verification plan
docs/       waveform and coverage screenshots
sim/        Makefile, compile.f   (TODO adjust)
```

## Author

`Nguyen Duy Hung` - Fresh Graduate Electronics and Telecommunications Engineering, HCMUTE.
`duyhung0939@gmail.com`

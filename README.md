# Sequence Repair Module

This project implements a **VHDL hardware module** that processes sequences stored in memory, reconstructs missing values, and assigns a credibility score to each entry. It was developed as part of the Digital Logic Design final examination and includes specification compliance, testbenches, and simulation results.

## Overview

The module reads a sequence of **K words W** from memory, where each word is an integer in the range [0, 255].

- A value of `0` indicates a **missing (unspecified) value**.
- Each word is stored with an associated **credibility score C** (0–31), which is written into the subsequent memory byte.

The module modifies the sequence as follows:

1. **Fill missing values** (`0`) with the most recently encountered valid value.
2. **Assign credibility values**:
   - `C = 31` whenever the value is valid (non-zero).
   - `C` is decremented each time a `0` is encountered, until reset by a new valid value.

## Example

**Input sequence (5 words):**
120 0 10 0 0 0 0 0 16 0

**Output sequence (with credibility):**
120 31 10 31 10 30 10 29 16 31

## Architecture

The module is implemented as a **finite state machine (FSM)** with the following key features:

- Synchronous design with a single clock.
- Asynchronous reset for reinitialization.
- Input signals: `START`, `ADD` (address), `K` (length).
- Output signal: `DONE` indicates end of processing.
- Memory interface:
  - `o_mem_addr`: address lines
  - `i_mem_data` / `o_mem_data`: data input/output
  - `o_mem_en`, `o_mem_we`: control signals

## Conclusion

The synthesized design works correctly in both behavioral and post-synthesis simulations, fully meeting the specifications and clock period constraints. The module was implemented with a single process, sufficient given the project’s simplicity. The project was evaluated with the maximum grade of 30/30L.

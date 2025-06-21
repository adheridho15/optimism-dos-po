# Optimism DoS Proof-of-Concept

This repository contains a minimal Proof-of-Concept (PoC) for a Denial of Service (DoS) vulnerability in the `L1CrossDomainMessenger` contract in Optimism Bedrock.

## Vulnerability Summary

A malicious actor can block the L1→L2 message relay queue indefinitely by submitting a fake withdrawal hash that causes reverts. This prevents subsequent valid messages from being processed due to queue ordering logic in `relayMessage()`.

## Project Structure

- `foundry.toml`: Foundry configuration
- `src/Revertor.sol`: Dummy contract that always reverts
- `test/PoC_Dos_Proof.t.sol`: Test that demonstrates the DoS scenario

## Requirements

- Foundry (`forge`)
- Solidity 0.8.30

## Run Test

```bash
forge test --match-contract PoC_Dos_Proof -vv

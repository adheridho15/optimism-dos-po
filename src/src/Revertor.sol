// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Revertor {
    fallback() external payable {
        revert("Always revert");
    }
}

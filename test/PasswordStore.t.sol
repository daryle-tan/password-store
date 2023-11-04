// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {PasswordStore} from "../src/PasswordStore.sol";
import {DeployPasswordStore} from "../script/DeployPasswordStore.s.sol";

contract PasswordStoreTest is Test {
    PasswordStore public passwordStore;
    DeployPasswordStore public deployer;
    address public owner;
    address public attacker;

    function setUp() public {
        deployer = new DeployPasswordStore();
        passwordStore = deployer.run();
        owner = msg.sender;
        attacker = address(1234);
    }

    function test_owner_can_set_password() public {
        vm.startPrank(owner);
        string memory expectedPassword = "myNewPassword";
        passwordStore.setPassword(expectedPassword);
        string memory actualPassword = passwordStore.getPassword();
        assertEq(actualPassword, expectedPassword);
    }

    function test_non_owner_reading_password_reverts() public {
        vm.startPrank(address(1));

        vm.expectRevert(PasswordStore.PasswordStore__NotOwner.selector);
        passwordStore.getPassword();
    }

    // Create test to have non-owner change password
    function test_missing_owner_checK() public {
        // owner can set password
        vm.startPrank(owner);
        string memory expectedPassword1 = "myNewPassword";
        passwordStore.setPassword(expectedPassword1);
        string memory actualPassword1 = passwordStore.getPassword();
        assertEq(actualPassword1, expectedPassword1);
        vm.stopPrank();

        // attacker can set password
        vm.startPrank(attacker);
        string memory expectedPassword2 = "attackerPassword";
        passwordStore.setPassword(expectedPassword2);
        vm.stopPrank();

        vm.startPrank(owner);
        string memory actualPassword2 = passwordStore.getPassword();
        assertEq(actualPassword2, expectedPassword2);
        console.log(actualPassword2, expectedPassword2);
        vm.stopPrank();
    }

    // Create test to have non owner read the password variable
    function test_contract_memory_read() public view {
        bytes32 password = vm.load(address(passwordStore), bytes32(uint256(1)));
        console.logString(string(abi.encodePacked(password)));
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AlexWeth} from "../src/AlexWeth.sol";

contract AlexWethTest2 is Test {
    AlexWeth public wethContract;
    address user;

    event Withdraw(address indexed owner, uint256 indexed amount);

    function setUp() public {
        user = makeAddr("user");
        deal(user, 10 ether);
        vm.label(user, "user");
        wethContract = new AlexWeth();
    }

    function testWithdrawBurn() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 withdrawAmount = 1 ether;
        uint256 wethAmountBefore = wethContract.accountBalance(user);
        bytes memory callFunc2 = abi.encodeWithSignature(
            "withdraw(uint256)",
            withdrawAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2, "fail to call function withdraw...");
        uint256 wethAmountAfter = wethContract.accountBalance(user);
        assertEq(wethAmountAfter, wethAmountBefore - withdrawAmount);
        vm.stopPrank();
    }

    function testWithdrawTransferEth() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 withdrawAmount = 1 ether;
        uint256 ethAmountBefore = address(user).balance;
        bytes memory callFunc2 = abi.encodeWithSignature(
            "withdraw(uint256)",
            withdrawAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2, "fail to call function withdraw...");
        // uint256 ethAmountAfter = wethContract.accountBalance(user);
        assertEq(address(user).balance, ethAmountBefore + withdrawAmount);
        vm.stopPrank();
    }

    function testWithdrawEmitEvent() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 withdrawAmount = 1 ether;
        vm.expectEmit(true, true, false, false);
        emit Withdraw(user, withdrawAmount);
        bytes memory callFunc2 = abi.encodeWithSignature(
            "withdraw(uint256)",
            withdrawAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2, "fail to call function withdraw...");
        vm.stopPrank;
    }
}

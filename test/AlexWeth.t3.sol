// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AlexWeth} from "../src/AlexWeth.sol";

contract AlexWethTest3 is Test {
    AlexWeth public wethContract;
    address user;
    address user2;
    address spender;

    event Withdraw(address indexed owner, uint256 indexed amount);

    function setUp() public {
        user = makeAddr("user");
        user2 = makeAddr("user2");
        spender = makeAddr("spender");
        deal(user, 10 ether);
        vm.label(user, "user");
        vm.label(user2, "user2");
        vm.label(spender, "spender");
        wethContract = new AlexWeth();
    }

    function testTransfer() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 user2WethBefore = wethContract.accountBalance(user2);
        uint256 transferAmount = 1 ether;
        bytes memory callFunc2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            user2,
            transferAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2, "fail to call function withdraw...");
        uint256 user2WethAfter = wethContract.accountBalance(user2);

        assertEq(user2WethAfter, user2WethBefore + transferAmount);
        vm.stopPrank();
    }

    function testApprove() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 spenderAllowanceBefore = wethContract.allowance(user, spender);
        uint256 appoveAmount = 1 ether;
        bytes memory callFunc2 = abi.encodeWithSignature(
            "approve(address,uint256)",
            spender,
            appoveAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2);
        uint256 spenderAllowanceAfter = wethContract.allowance(user, spender);
        assertEq(spenderAllowanceAfter, spenderAllowanceBefore + appoveAmount);
    }

    function testTransferFrom() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 appoveAmount = 1 ether;
        bytes memory callFunc2 = abi.encodeWithSignature(
            "approve(address,uint256)",
            spender,
            appoveAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2);
        vm.stopPrank();

        vm.startPrank(spender);
        uint256 user2WethBefore = wethContract.accountBalance(user2);
        uint256 transferAmount = 1 ether;
        bytes memory callFunc3 = abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            user,
            user2,
            transferAmount
        );
        (bool success3, ) = address(wethContract).call(callFunc3);
        require(success3);
        uint256 user2WethAfter = wethContract.accountBalance(user2);
        assertEq(user2WethAfter, user2WethBefore + transferAmount);
        vm.stopPrank();
    }

    function testAllowanceAfterTransferFrom() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");

        uint256 appoveAmount = 1 ether;
        bytes memory callFunc2 = abi.encodeWithSignature(
            "approve(address,uint256)",
            spender,
            appoveAmount
        );
        (bool success2, ) = address(wethContract).call(callFunc2);
        require(success2);
        vm.stopPrank();

        vm.startPrank(spender);
        uint256 userAllowanceBefore = wethContract.allowance(user, spender);
        uint256 transferAmount = 1 ether;
        bytes memory callFunc3 = abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            user,
            user2,
            transferAmount
        );
        (bool success3, ) = address(wethContract).call(callFunc3);
        require(success3);
        uint256 userAllowanceAfter = wethContract.allowance(user, spender);

        assertEq(userAllowanceAfter, userAllowanceBefore - transferAmount);
        vm.stopPrank();
    }
}

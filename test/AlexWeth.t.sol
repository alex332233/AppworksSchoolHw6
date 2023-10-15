// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AlexWeth} from "../src/AlexWeth.sol";

contract AlexWethTest is Test {
    AlexWeth public wethContract;
    address user;

    event Deposit(address indexed owner, uint256 indexed amount);

    function setUp() public {
        user = makeAddr("user");
        deal(user, 10 ether);
        vm.label(user, "user");
        wethContract = new AlexWeth();
    }

    function testDepositMintAmount() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        uint256 conversionRate = 1;
        uint256 tokenAmount = depositAmount * conversionRate;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: 1 ether}(callFunc);
        require(success, "fail to call function...");
        assertEq(wethContract.accountBalance(user), tokenAmount);
        vm.stopPrank();
    }

    function testDepositContractAmount() public {
        vm.startPrank(user);
        uint256 contractEthBefore = address(wethContract).balance;
        uint256 depositAmount = 1 ether;
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");
        uint256 contractEthAfter = address(wethContract).balance;
        assertEq(contractEthAfter, contractEthBefore + depositAmount);
    }

    function testDepositEmitEvent() public {
        vm.startPrank(user);
        uint256 depositAmount = 1 ether;
        vm.expectEmit(true, true, false, false);
        emit Deposit(user, depositAmount);
        bytes memory callFunc = abi.encodeWithSignature("deposit()");
        (bool success, ) = address(wethContract).call{value: depositAmount}(
            callFunc
        );
        require(success, "fail to call function...");
        // vm.expectEmit("Deposit", {owner: address(user), amount: depositAmount});
        vm.stopPrank;
    }
}

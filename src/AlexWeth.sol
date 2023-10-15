/**
 *Submitted for verification at Etherscan.io on 2023-10-01
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract AlexWeth {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Deposit(address indexed owner, uint256 indexed amount);
    event Withdraw(address indexed owner, uint256 indexed amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event Transfer(address indexed owner, address indexed to, uint256 amount);
    event TransferFrom(
        address indexed owner,
        address indexed to,
        uint256 amount
    );

    mapping(address => uint256) public accountBalance;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() external payable {
        accountBalance[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(
            accountBalance[msg.sender] >= _amount,
            "Not enough ETH for withdrawal..."
        );
        accountBalance[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Withdraw failed...");
        emit Withdraw(msg.sender, _amount);
    }

    function totalSupply() external view returns (uint256) {
        return address(this).balance;
    }

    function approve(
        address _spender,
        uint256 _amount
    ) external returns (bool) {
        require(
            accountBalance[msg.sender] >= _amount,
            "Not enough ETH to be approved..."
        );
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transfer(address _to, uint256 _amount) external returns (bool) {
        require(
            accountBalance[msg.sender] >= _amount,
            "Not enough ETH to transfer..."
        );
        accountBalance[msg.sender] -= _amount;
        accountBalance[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(
        address _owner,
        address _to,
        uint256 _amount
    ) external returns (bool) {
        require(
            accountBalance[_owner] >= _amount,
            "Not enough ETH to transfer..."
        );
        accountBalance[_owner] -= _amount;
        accountBalance[_to] += _amount;
        allowance[_owner][msg.sender] -= _amount;

        emit TransferFrom(_owner, _to, _amount);
        return true;
    }
}

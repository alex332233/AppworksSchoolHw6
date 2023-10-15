## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Test

```shell
$ forge test
```

## project explanation

### src

AlexWeth.sol: The WETH contract deployed on Week4.

### test

There are three test scripts, AlexWeth.t.sol, AlexWeth.t2.sol, and AlexWeth.t3.sol, and there are totally 10 tests in these scripts.

AlexWeth.t.sol: Test the deposit function in AlexWeth.sol with 3 testing functions.

AlexWeth.t2.sol: Test the withdraw function in AlexWeth.sol with 3 testing functions.

AlexWeth.t3.sol: Test the transfer, approve, and transferFrom function in AlexWeth.sol with 4 testing functions.

### test usage

Use the following command to test for the whole 10 testings.

```shell
$ forge test
```

Use the following command to test for each test script.

```shell
$ forge test --match-contract AlexWethTest
```

```shell
$ forge test --match-contract AlexWethTest2
```

```shell
$ forge test --match-contract AlexWethTest3
```

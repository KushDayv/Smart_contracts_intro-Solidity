// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VendingMachine{
    //This is the address of the deployer of the smart contract
    address public owner;

    mapping (address => uint) public donutBalances;

//Once the contract is deployed the smart contructor will be called thus giving us the address of the owner who deployed it.
    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner can restock this Machine");
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable {
        //the require function will be used to check the amount of ether the person is supplying. 
        require(msg.value >= amount * 2 ether, "You must pay atleast two ether per donut");
        require(donutBalances[address(this)] >= amount, "Not Enough Donuts ");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }

}
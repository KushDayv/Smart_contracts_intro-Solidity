//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;


contract SavingsAccount{
    address public owner;
    uint public balance;
    uint public interestRate; //this is the interest rate in percentage.

    struct Transaction {
        uint amount;
        uint timestamp;

    }

    mapping(address => uint) public balances;
    mapping(address => Transaction[]) public transactionHistory;

    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);
    event InterestCredited(address indexed account, uint amount);


    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _; //The underscore represents the actual body of the function that uses the modifier
    }

    constructor(uint _interestRate){
        owner = msg.sender;
        interestRate = _interestRate;
    }

    //Function to Deposit cash in the account,
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balance += msg.value;
        transactionHistory[msg.sender].push(Transaction(msg.value, block.timestamp));
        emit Deposit(msg.sender, msg.value);
    }

    //Function to Withdraw cash 
    function withdrawFunds(uint amount) public payable {
        require(amount > 0 && amount <= balance, "Invalid Withdrawal amount");

        payable(owner).transfer(amount);
        balance -= amount;
        transactionHistory[msg.sender].push(Transaction(msg.value, block.timestamp));
        emit Withdrawal(msg.sender, amount);

    }

    //Function to calculate the credit interest to the savings account. 
    function creditInterest() public onlyOwner {
        uint interest = (balance * interestRate) / 100;
        balance += interest;
        transactionHistory[msg.sender].push(Transaction(interest, block.timestamp));
        emit InterestCredited(msg.sender, interest);
    }

    //Function to get the current account balance. 
    function currentBalance() public view returns (uint){
        return balance;
    }

    //Function to get the transaction history 
    function getTransactionHistory() public view returns (Transaction[] memory) {
        return transactionHistory[msg.sender];
    }
}
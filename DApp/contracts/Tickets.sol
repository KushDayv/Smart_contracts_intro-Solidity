
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

uint256 constant TOTAL_TICKETS = 10;

contract Tickets {
    //this is like the public address...once the contract is deployed..the address will be stored in the block chain. 
    address public owner = msg.sender;

//creating of structs => is a data structure that one can use to store diverse data types together.
    struct Ticket {
        uint256 price;
        address owner;
    }

//creating an array of tickets that are accessible to the public.
    Ticket[TOTAL_TICKETS] public tickets;

//a constructor that will loop through the tickets
    constructor() {
        for (uint256 i = 0; i < TOTAL_TICKETS; i++){
            tickets[i].price = 1e17; //0.1ETH
            tickets[i].owner = address(0x0);
        }
    }

//function thet will be used to buy the tickets. 
    function buyTicket(uint256 _index) public payable {
    require(_index < TOTAL_TICKETS && _index >= 0); //ensures that anyone buys a ticket from 0 - 9. 
    require(tickets[_index].owner ==address(0x0)); //ensures that no one has a ticket initially. 
    require(msg.value >= tickets[_index].price); //used to check of the person has sent enough money to purchase the ticket. 
    tickets[_index].owner = msg.sender; //used to set the ticket to the owner once he or she has purchased.  
    }
}
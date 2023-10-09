//bringing in the actual contracts.
const Tickets = artifacts.require('Tickets');

//Performing a Mocha test
const assert = require('assert')

contract('Tickets', (accounts) => {
    const BUYER = accounts[1];
    const TICKET_ID = 0;

    it('should allow a user to buy a ticket', async () => {
        const instance = await Tickets.deployed(); //creating a new instance of the contract. 
        const originalTicket = await instance.tickets(TICKET_ID); //vefifying to see that the ticket we want to buy is not bought by anyone. 
        //calling the buyTicket function and passing the original amount that was set for the ticket. 
        await instance.buyTicket(TICKET_ID, {from: BUYER, value: originalTicket.price});
        //the new state of the contract.
        const updatedTicket = await instance.tickets(TICKET_ID);
        //making sure that the owner of the ticket is  the buyer.
        assert.equal(updatedTicket.owner, BUYER, 'the buyer should now own this ticket')
    });
});
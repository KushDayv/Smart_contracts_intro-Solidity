// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SmartLending{
    
    //property struct to store information about the property
    struct propertyInformation{
        address owner;
        string Name;
        uint leaseAmount;
        uint securityDeposit;
        bool propertyForLease;

    }
   
    //mapping to keep track of every single property
    mapping(uint => propertyInformation) public properties;//maps to the address of the property
    
    //array to hold all the property ids
    uint[] public propertyIDs;

    event propertySold(uint propertID);

//function that will be used to check if the property is there for Lease
    function propertyForLease(uint _propertyID, string memory _Name, uint _leaseAmount, 
    uint _securityDeposit) public {
        //creating a new property and populatin it with new values.
        propertyInformation memory newProperty = propertyInformation({
            owner: msg.sender, 
            Name: _Name,
            leaseAmount: _leaseAmount,
            securityDeposit: _securityDeposit,
            propertyForLease: true
        });

        
        properties[_propertyID] = newProperty;
        propertyIDs.push(_propertyID);
    }

//Function to  allow one to lease the property and is kept public so that anyone can call it. 
    function rentProperty(uint _propertyID) public payable {
        propertyInformation storage prop = properties[_propertyID];
        
        //require statement to check if the property is available for purchase
        require(prop.propertyForLease, "Property is not for Lease!!!");
        //require statement to check if the price the person has provided is enough
        require(prop.leaseAmount <= msg.value, "Insufficient Funds");

        //transfering the sold property to the buyer. 
        prop.owner = msg.sender;
        prop.propertyForLease = false;

        //transfering the purchase price to the seller
        payable(prop.owner).transfer(prop.leaseAmount);

        //Displaying the property sold event.
        emit propertySold(_propertyID);

    }

 }
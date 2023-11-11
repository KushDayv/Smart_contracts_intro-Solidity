// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SmartHousing{

    struct propertyInformation{
        address owner;
        string name;
        uint rentAmount;
        uint securityDeposit;
        uint repairServices;
        string propertyDescription;
        bool isProperty;
        uint initialPayment;
        address currentTenant; //used to show the current tenant who is renting the property.
    }

    struct tenantInformation{
        address tenantAddress;
        string tenantName;
        // string rentalHistory;
        uint lastRentPaid; // Track last rent payment: will return the timestamp of when the payment was paid
        uint lastWaterBillPaid; // Track last electric bill payment: will give the timestamp

    }

    struct rentPayment{
        uint rentAmount;
        uint waterBill;
        uint uintsOfWaterUsed;
        uint electricBill;
    }

// mapping(address => propertyInformation) public property;
    
    mapping(uint => propertyInformation) public properties;

    mapping(address => tenantInformation) public tenants;

    uint[] public propertyID;

    // uint[] public tenantID;

    // uint[] public initialPayment;

    event propertyAdded(uint propertID);

    event PropertyRented(uint propertyID);
//Function to add a property
/*One is supposed to enter a propertyID, name of the property, rentAmount, Securitydeposit, repairServices, 
and the initial payment = (rentAmount + securityDeposit + repairServices) */
    function addProperty(
        uint _propertyID,
        string memory _name,
        uint _rentAmount,
        uint _securityDeposit,
        uint _repairServices,
        uint _initialPayment,
        string memory _propertyDescription
    ) public {
            propertyInformation memory newProperty = propertyInformation({
            owner: msg.sender,
            name: _name,
            rentAmount: _rentAmount,
            securityDeposit: _securityDeposit,
            repairServices: _repairServices,
            propertyDescription: _propertyDescription,
            initialPayment: _initialPayment,
            currentTenant: address(0),
            isProperty: true
        });

        properties[_propertyID] = newProperty;
        propertyID.push(_propertyID);
    }

//Function to get the property information 
//The function takes propertyID as the argument which it uses to access the property
     function getPropertyInformation(uint _propertyID) public view returns (
        address owner,
        string memory name,
        uint rentAmount,
        uint securityDeposit,
        uint repairServices,
        string memory propertyDescription,
        bool isProperty,
        uint initialPayment
    ) {
        propertyInformation storage property = properties[_propertyID];

        require(property.isProperty, "Property with given ID does not exist");

        return (
            property.owner,
            property.name,
            property.rentAmount,
            property.securityDeposit,
            property.repairServices,
            property.propertyDescription,
            property.isProperty,
            property.initialPayment
        );
    }

//Function to add a New Tenant
function addTenant(address _tenantAddress, string memory _tenantName) public {
        // uint _tenantID = tenantID.length; // Assigning the new tenant ID
        // tenantID.push(_tenantAddress); // Add the new tenant ID to the tenantID array

        // Create and store the tenant information
        //Both initial values of water and rent 0.
        tenantInformation memory newTenant = tenantInformation({
            tenantAddress: _tenantAddress,
            tenantName: _tenantName,
            lastRentPaid: 0, 
            lastWaterBillPaid: 0
            
        });

        tenants[_tenantAddress] = newTenant; // Store the tenant information in the mapping
    }

// Function to get the tenant information 
//it takes in the address of the tenant as the argument
    function getTenantInformation(address _tenantAddress) public view returns (
        address tenantAddress,
        string memory tenantName,
        uint lastRentPaid,
        uint lastElectricBillPaid
    ) {
        tenantInformation storage tenant = tenants[_tenantAddress];

        // require(tenant.tenantAddress != address(0), "Tenant with given ID does not exist");
        require(tenants[_tenantAddress].tenantAddress != address(0), "Tenant with given Address does not exist");

        return (
            tenant.tenantAddress,
            tenant.tenantName,
            tenant.lastRentPaid,
            tenant.lastWaterBillPaid
        );
    }

//Function to rent a property 
    function rentProperty(uint _propertyID, uint _initialPayment) public payable {
    require(properties[_propertyID].isProperty, "Property with given ID does not exist");
    require(properties[_propertyID].currentTenant == address(0), "Property is already rented");
    require(msg.value >= (properties[_propertyID].rentAmount + properties[_propertyID].securityDeposit + properties[_propertyID].repairServices), "Insufficient initial payment");
    require(_initialPayment <= (properties[_propertyID].rentAmount + properties[_propertyID].securityDeposit + properties[_propertyID].repairServices), "Initial payment is greater than required");

    // Update property details
    properties[_propertyID].currentTenant = msg.sender; // Renting tenant is the message sender
    properties[_propertyID].initialPayment = _initialPayment;

    // Emit an event for property rental
    emit PropertyRented(_propertyID);
}

//Function to pay Rent 
    function payRent(address _tenantAddress , uint _propertyID, uint _rentAmount) public payable {
        require(properties[_propertyID].currentTenant == _tenantAddress, "Invalid tenant or property");
        require(msg.value >= properties[_propertyID].rentAmount, "Insufficient rent amount");
        require(msg.value >= _rentAmount, "Insufficient rent Amount");
        // Update tenant's last rent paid timestamp
        tenants[_tenantAddress].lastRentPaid = block.timestamp;

        address owner = properties[_propertyID].owner;
        payable(owner).transfer(msg.value);

        
    }
//Function to pay WaterBill
    function payWaterBill(address _tenantAddress, uint _propertyID, uint _waterBillAmount) public payable {
        require(properties[_propertyID].currentTenant == _tenantAddress, "Invalid tenant or property");
        require(msg.value >= _waterBillAmount, "Insufficient water bill amount");

        // Update tenant's last water bill paid timestamp
        tenants[_tenantAddress].lastWaterBillPaid = block.timestamp;

    }
}

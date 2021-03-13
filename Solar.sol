// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract Solar
{
    address seller;
    
    
    uint costPerKWH; 
    //billing based kilowatt/hours as the system is based on batteries with capacity ~5-10 KWH and this makes it easier to see usage for the consumer - each consumer has one battery linked to producers 
    //in the system with something like a tesla supercharger. standard house voltage is 120 VAC, so the battery will have hookups rated at this. the idea here is that people
    //are only getting power for what they need in an emergency - this isn't meant to link to an entire house like a generator system. this discourages wasteful use of electrcity
    //as you are forced to actually plug stuff into the battery. it also helps to isolate the networked power system from a larger grid (maybe even The Grid) that we don't want to interface with at all
    mapping (address => uint) private powerAvailable;
    mapping (address => uint) private activeConsumers;
    bool powerFlowing;
    
    constructor() public
    {
        seller = msg.sender;
        powerFlowing = false;
    }
    
    modifier onlyOwner(){
    require(msg.sender == seller);
    _;
    }
    
    function buyPower(uint amountKWH) public payable
    {
        powerAvailable[address(this)] = getAvailablePower();
        require(powerAvailable[address(this)] >= 20, "Batteries are too low to distribute power effectively."); //make sure batteries never run fully dry to avoid undervoltage/undercurrent/damage to batteries/etc
        require(activeConsumers[address(this)] <= 5, "Power network full."); //limit number of users that can concurrently use power system to avoid draining it too fast
        
        costPerKWH = computePowerCost(powerAvailable[address(this)]);
        uint costToConsumer = amountKWH * costPerKWH;
        require(msg.value >= costToConsumer * 1 ether, "Power cost must be affordable.");
        //consumer battery capacity is fixed and known to the consumer, allowing them to purchase fractional amounts of electricty to charge their battery
        powerOn(amountKWH);
    }
    
    
    function getAvailablePower() private onlyOwner returns (uint)
    {
        //there would be some kind of code here to communicate with a power controller at the producer's box to get the current charge percentage of the batteries linked to the owner's solar power system
        //we will return a sample percentage
        uint percentage = 100 - 71; //function call to controller would be here
        return percentage;
        //representing that the system currently has 71% of maximum charge available for distribution.
    }
    
    function computePowerCost(uint capacityAvailable) private returns (uint)
    {
        uint BASEFEE = getMarketRate();
        uint cost = capacityAvailable * BASEFEE; //simplfied cost scaling model for the specific producer of electricity - encourages people to utilize power evely and not just from one producer
        return cost;
    }
    
    function getMarketRate() private returns (uint)
    {
        //set base power fee, in reality this would be set by street level network - incremented upward by some amount if street level network is < 50%, < 40% capacity,
        // < 30% capacity, etc. point here is to somehow maintain a reasonable price but one that makes people only use it for essential purposes
        uint BASEFEE = 0.000070 ether;
        return BASEFEE;
    }
    
    function powerOn(uint amount) private onlyOwner
    {
        uint KWHdistributed = 0;
        //communicateWithPowerControllerBoxAndTurnOnPower(amount);
        //method above would communicate with power box to turn on power to house linked to address and start charging until the amount of power ordered has been distributed
        while(KWHdistributed <= amount)
        {
            powerFlowing = true;
        }
    }
}

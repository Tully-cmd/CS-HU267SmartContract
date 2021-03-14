// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

/**
 * Smart contract that handles the pricing and sale of Hydro electricity
 * @title Hydro
 * 
 */
 contract Hydro {
      address payable seller;
      uint256 startingTime;
      
      //Should this really be a uint? Sometimes the value might be negative in order to reflect profitability and direction of sale.
      //Although I'm not sure if that would work given the how crypto payments work (i.e. signatures locking addresses)
      uint costPerKWH;
      
      mapping (address => uint) private powerAvailable;
      mapping (address => uint) private activeConsumers;
      bool powerFlowing;
      
      //This is how I saw to make contract payable. I'm not sure which one of us is correct
      constructor(address payable _seller) onlyOwner {
          seller = _seller;
          powerFlowing = false;
          startingTime = block.timestamp;
      }
      
      modifier onlyOwner() {
          require(msg.sender == seller);
          _;  
      }
      
      function buyPower(uint amountKWH) public payable {
          powerAvailable[address(this)] = getAvailablePower();
          
          //This line reflected batteries in the solar example. Perhaps it should be water level in hydro?
          //
          require(powerAvailable[address(this)] >= 20, "Water level is too low to distribute power effectively.");
          require(activeConsumers[address(this)] <= 5, "Power network full.");
          
          costPerKWH = computePowerCost(powerAvailable[address(this)]);
          uint costToConsumer = amountKWH * costPerKWH;
          
          require(msg.value >= costToConsumer * 1 ether, "Power cost must be affordable.");
          
          powerFlowing = true;
      }
      
      /**
       * Three phase power has 3 sin waves space 120 degrees appart that ossiclate at 60hz in the US.
       * In order to synchronize the hydro electric turbine with the rest of the grid the owner of the turbine needs to be
       * able adjust the phases to match the 60hz of the grid, by adjusting the angle of stator relative to the turbines magnets.
       */
      function synchronizePowerPhases() public returns (uint) {
          //Remainder of (60 * (currentTime - startingTime) * 360)/120
          return startingTime;
      }
      
      function getAvailablePower() private onlyOwner returns (uint) {
        //there would be some kind of code here to communicate with a power controller at the producer's box 
        //to get the current charge percentage of the batteries linked to the owner's hydro power system
        //we will return a sample percentage
        uint percentage = 100 - 71; //function call to controller would be here
        return percentage;
        //representing that the system currently has 71% of maximum charge available for distribution.
      }
      
      function computePowerCost(uint capacityAvailable) private returns (uint)
    {
        //uint BASEFEE = getMarketRate(); commenting this out solidity literally doesn't support floating 
        //point values no kidding probably best to divide by a whole number on the next line
        
        //simplfied cost scaling model for the specific producer of electricity - encourages people to 
        //utilize power evenly and not just from one producer
        uint cost = capacityAvailable / 100; 
        return cost;
    }
    
    function getMarketRate() private returns (uint)
    {
        //set base power fee, in reality this would be set by street level network - incremented upward by some
        //amount if street level network is < 50%, < 40% capacity, < 30% capacity, etc. point here is to somehow
        //maintain a reasonable price but one that makes people only use it for essential purposes 
        //uint BASEFEE = 0.000070 ether; 
        // returns a gigantic fee for some odd reason see line 67
        uint BASEFEE = 1; //for testing returns a too big of fee
        return BASEFEE;
    }
    
 }
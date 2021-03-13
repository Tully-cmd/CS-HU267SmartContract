// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

/** 
 * @title Coal
 * @dev Idea on how a emergency power system could work
 */
contract Coal {

    //bool hasPower;
    uint currentHousePower;
    uint minimumLevel; // min level this house needs to have power
    uint extraGridPower = 1000; //this somehow needs to be a value that is always
                                //the same for all users on this contract
                                //lets say there is 1000 extra power to start out with
    
    //user passes in if they have power or not when starting up
    constructor (uint currentPower, uint min) public { 
        //hasPower = status;
        currentHousePower = currentPower;
        minimumLevel = min;
    }
    
    function sendExtraCoal(uint amount) payable public {
        if(minimumLevel > currentHousePower - amount ) {
            //FAIL GAVE TOO MUCH POWER
        } else {
            extraGridPower = extraGridPower + amount;
            currentHousePower = currentHousePower - amount;
        }
    }
    
    function getEmergencyPower() public {
        if(minimumLevel > currentHousePower) {
            //able to recieve 
            uint neededAmount = minimumLevel - currentHousePower;
            extraGridPower = extraGridPower - neededAmount;
            currentHousePower = currentHousePower + neededAmount;
        } else {
            //fail already have enough power!
        }
    }
    

}

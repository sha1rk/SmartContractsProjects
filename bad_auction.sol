//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

contract auction{
    address payable owner;
    //start and end date 
    //end date to be 7 days from the date of deployment/starting 
//chainStartTime = block.timestamp;
    uint256 start_date;
    uint256 end_date;
    //bids ; //mapping data type 
    //mapping(keyDataType=>valueDataType) mappingName
    mapping(address => uint) bids;
    constructor(){
        //values intitialize 
        //contract owner -->deployers> msg.sender 
        owner= payable(msg.sender);
        //tbc
        start_date = block.timestamp;
        end_date = start_date+86400;
        //we are making end date as 24 hours from the contract deployment 
    }
    function placeBid() public{
        //body to be addedd later
        //bids ... = msg.sender;
        //bids... = msg.value;
    }
    function destroy() public {
    require(owner == msg.sender, "ooppssiieeee !!! only the owner can call this");       
            selfdestruct(owner);
    }
    //type(msg.value)
    //create a function to end the smart c ontract / auction
    //only owner can call this 
    //owner can call this arbitrarily or it get's called automatically when end_date
}

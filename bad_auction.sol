//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

contract auction{
    address payable public owner;
    //payable- can rcv eth
    //public - is visibile and accessible to everyone
    //start_date = block.timestamp;
    //this is not to be used becuase block.timestamp can be spofed by the miner. tldr;
    //start and end date 
    //end date to be 7 days from the date of deployment/starting 
    uint256 public start_date;
    uint256 public end_date;
    string public ipfsHash; // to store auction assets on ipfs and not on blochcain becuase on blockchain it's expensive
    enum State {Started, Running, Ended, Cancelled}   // pata nahi kyu banaana hai ye 
    State public auctionState; // this tells us the current state of auction
    uint public highestBindingBid;//
    address payable public highestBidder; // 
    mapping(address => uint) public bids; // bids are going to have 2 components - 1 is bidder i.e key and another is bidding amout i.e value 
    uint bidIncrement;
    constructor ()
    {
        owner = payable(msg.sender);
        auctionState = State.Running;
        start_date = block.number;//block.number is a global variable represnting the current block number 
        end_date = start_date+40320; // 40320 represents the number of blocks that will be built in 1 week, one block is built in 15 seconds do the maths 
        ipfsHash= "";
        bidIncrement= 100; // here the SI unit of this 100 is wei, for other unit such as ether you have to explicilty mention that ahead of value like 100 ether

    }
    modifier onlyOwner()
    {
        require(owner==msg.sender, "sorry you are not the owner !!");
        _;
    }
    modifier notOwner()
    {
        require(msg.sender!=owner,"owner can not placebid");
        _;
    }
    modifier afterStart()
    {
        require(block.number>=start_date, "oopss the current block is before start date");
        _;
    }
    modifier beforeEnd()
    {
        require(block.number<=end_date, "ooppss the current block is after end date");
        _;
    }
    function min(uint a, uint b) internal pure returns (uint) 
    {
        if (a < b) 
        {
            return a;
        } 
        else 
        {
            return b;
        }
    }
    function emergency() public onlyOwner 
    {
        auctionState = State.Cancelled;
        //do something more here if you want to ; 
    }
    //withdrawl function with checking the state cacnelled or ended and the amout that was bidded by the requestor 

    function placeBid() public payable notOwner afterStart beforeEnd 
    {
        require(msg.value>=100); // ps. the SI unit for currecny is wei here 
        require(auctionState==State.Running, "sorry the auction is not Running(may be it is cancelled)");// why are we doing this ? isn't this redundnant and unneccasry with afterStart beforeEnd
        // we are doing this becuase in case of emergency cancellation of the auction the start and end date checks would betrue but the auction state would be cnacelled.

        uint currentBid = bids[msg.sender]+msg.value;
        require(currentBid>highestBindingBid);
        bids[msg.sender]=currentBid;
        if (currentBid<=bids[highestBidder])
        {
            highestBindingBid = min(currentBid+bidIncrement, bids[highestBidder]);
        }
        else
        {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder=payable(msg.sender);
        }
    }

    function finalizeAuction () public
    {
        require(auctionState == State.Cancelled || block.number > end_date);
        require(msg.sender == owner || bids [msg.sender] > 0);
        address payable recipient;
        uint value;
        if(auctionState==State.Cancelled)
        { // auction was canceled
            recipient = payable (msg.sender);
            value = bids [msg.sender];
        }
        else
        { // auction ended (not canceled)
            if(msg.sender == owner) 
            { // this is the owner
                recipient = owner;
                value = highestBindingBid;
            }
        else
        { //this is a bidder
            if(msg.sender == highestBidder)
            {
                recipient = highestBidder;
                value = bids [highestBidder] - highestBindingBid;
            }
            else
            { // this is neither the owner nor the highest Bidder
                recipient = payable(msg.sender);
            }
            }
        }
        recipient.transfer(value);
    }

}



/*
    //bids ; //mapping data type 
    //mapping(keyDataType=>valueDataType) mappingName
    
    constructor(){
        //values intitialize 
        //contract owner -->deployers> msg.sender 
        owner= payable(msg.sender);
        //tbc
        end_date = start_date+86400;
        //we are making end date as 24 hours from the contract deployment 
    }
    function placeBid() public{
        //body to be addedd later
        //bids ... = msg.sender;
        //bids... = msg.value;
        bidI.value=msg.value;
        bidI.bidder=msg.sender;
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
*/

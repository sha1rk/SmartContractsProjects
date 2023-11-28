//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

//create a contract named lottery 
contract Lottery {
    //declare a dynamic array that is payable and of address data type
    //why? because it's storing addreses thats why address data type. & becuase at the end of lottery the smart contract is going to send money/pay money to an address insde this array thats why it's payable. 
    address payable[] public players;
    //an array to store players has been created 
    //payable and non payable addresses ?
    //payable addresses are the addresses to which you can send the ether to
    //declare a manager; and externalyl owned accoun that deploys the contract 
    address public owner_mgr;
    //implement functionality of manager 
    
    constructor()
    {
        owner_mgr=msg.sender;
        //msg.sender is a global variable in solidity
        //constructor will be called only once automatically when the contract is deployed
    }
    //how a user enters a lottery ?
    //user enters a lottery by using a wallet to send 0.1 ether to contract 
    //users address is added to array 
    //contracts balamnce is updated with 0.1 eth 
    //how torcv eth in a contract ?
    //using recieve () or a fallback function ()

    //a contract can have only one rcv function 
    //this was introduced in ----xxx xx version --- solidity 0.6
    //very important function;this function allows your smart contract to rcv eth/rcv money 
    receive() external payable{
        //why payable ? becuase will be senduign money to this 
        // externall owned accoutns 
        // this can not have 
        //we have to check if the incoming amount is 0.1 ether 
        require(msg.value == 0.1 ether );
        //we nned to know more about ether keyword used here 
        players.push(payable(msg.sender));
        //we rcv the money and we add the sender of that money in the players array
    }

    function getBalance()public view returns (uint)
    {
        require(msg.sender==owner_mgr);
        return address(this).balance;
        //becuase we only want the owner to view the balance

    }
    //Since Solidity 0.8, an address is not payable by default (source: docs). So if you want to send them the native currency (in case of Ethereum, that's ETH), you need to cast the address to payable first.
    //warning:: this is definitley insecure way of genearting random number dont put this in prod.
    function random_gen() public view returns (uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pick_winner(address payable[] memory) public returns(address){
        //only owner can call this access checks 
        require(msg.sender==owner_mgr);
        //additional check for atleast 3 players
        require(players.length>=3);
        // there is an issue here if same player sends money for 3 times the address of that player will be added to the players array 3 times fullfing this check but failing at logical level.
        //random winner selection
        uint r = random_gen();
        uint indi = r % players.length;
        address payable winner = players[indi];
        //return winner;
        //return here if you want to limit it for one time usage 

        winner.transfer(getBalance());
        //resetting the array / clearing the array for next round 
        players = new address payable[](0);
        //bhai isme elaboration chaiye - how this is resetting 
        return winner; 

    }

}

//what to learn more ?
/*
why infite gas error arises in follwing snippet 
  function random_gen() public returns (uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }
*/

// how is estimated gas calculated on the go in remixi ? what is this feature.

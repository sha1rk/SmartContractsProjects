//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

//create a contract named lottery 
contract lottery {
    //declare a dynamic array that is payable and of address data type
    //why? because it's storing addreses thats why address data type. & becuase at the end of lottery the smart contract is going to send money/pay money to an address insde this array thats why it's payable. 
    address payable[] public players;

    //payable and non payable addresses ?
    //payable addresses are the addresses to which you can send the ether to

    //declare a manager; and externalyl owned accoun that deploys the contract 
    
    //implement functionality of manager 
    address public owner_mgr;
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
    }
    //Since Solidity 0.8, an address is not payable by default (source: docs). So if you want to send them the native currency (in case of Ethereum, that's ETH), you need to cast the address to payable first.
    function random_gen() returns (unint)
    {

    }

    function pick_winner(address payable[]) public returns(address){
        //only owner can call this access checks 
        //random winner selection
        len=players.length
        return winner; 
    }

    function addElement(uint value) public {
        players.push(value);
    }


    function getElement(uint index) public view returns (uint) {
        return players[index];
    }


    function getLength() public view returns (uint) {
        return players.length;
    }
}


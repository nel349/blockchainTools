// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract MiniRaffle {

    // one ether = 1000000000000000000
    // 0.1 ether = 100000000000000000


    event Started();
    event TicketBought(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    uint public prize; // wei
    mapping(uint => TicketVoucher) public tickets; // contains addresses and maps to ticket voucher.
    uint public minimumTickets;
    address payable public host;
    uint public ticketPrice;
    address payable winner;
    uint public endAt;
    bool public started;
    bool public ended;

    // Initializing the state variable
    uint randNonce = 0;

    struct TicketVoucher {
        address payable owner;
        int count; //number of tickets bought
    }

    constructor(uint _prize, uint _ticketPrice, uint daysDuration) {
        prize = _prize;
        ticketPrice = _ticketPrice;
        endAt = block.timestamp + daysDuration * 1 days;
        minimumTickets = prize / ticketPrice;
        host = payable(msg.sender);
    }

    function drawWinner () public {
        require(block.timestamp > endAt + 1 minutes);
        require(winner == address(0));
        uint index = randMod(minimumTickets);
        winner = tickets[index].owner;
    }

    function start() external payable {
        require(!started, "it already started!");
        require(msg.sender == host, "not host");
        require(address(this).balance >= prize, "Major prize should be funded");
        started = true;
        emit Started();
    }

    // Defining a function to generate a random number
    //consider https://docs.chain.link/docs/get-a-random-number/ for random generation.
    function randMod(uint _modulus) internal returns(uint)
    {
        // increase nonce
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}
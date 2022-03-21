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
    mapping(uint => address) public tickets; // maps id participant to address
    mapping(address => TicketVoucher) public participants; // maps address participant to ticket voucher
    uint public minimumTickets;
    address payable public host;
    uint public ticketPrice;
    address payable winner;
    uint public endAt;
    bool public started;
    bool public ended;

    uint private ticketId = 0;

    // Initializing the state variable
    uint randNonce = 0;

    struct TicketVoucher {
        bool exists;
        uint[] ticketsBought; //tickets bought ids
    }

    constructor(uint _prize, uint _ticketPrice, uint daysDuration) {
        prize = _prize;
        ticketPrice = _ticketPrice;
        endAt = block.timestamp + daysDuration * 1 days;
        minimumTickets = prize / ticketPrice;
        host = payable(msg.sender);
    }

    function drawWinner () external {
        require(block.timestamp > endAt + 1 minutes, "not ended");
        require(winner == address(0), "no winner yet!");
        uint index = randMod(minimumTickets);
        winner = payable(tickets[index]);
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

    function buyTicket() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "raffle has ended");
        require(msg.value >= ticketPrice, "value must be above the ticket price");

        TicketVoucher storage ticketVoucher = participants[msg.sender];
        if (ticketVoucher.exists) {
            ticketVoucher.ticketsBought.push(ticketId);
        } else {
            uint[] memory _ticketsBought = new uint[](ticketId);
            participants[msg.sender] = TicketVoucher({exists: true, ticketsBought:_ticketsBought});
        }
        tickets[ticketId] = msg.sender;
        ticketId++;
        emit TicketBought(msg.sender, msg.value);
    }

    function getTicketsBoughtByAddress(address addr) view external returns (uint[] memory) {
        return participants[addr].ticketsBought;
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract MiniRaffle {

    // one ether = 1000000000000000000
    // 0.1 ether = 100000000000000000


    event Started();
    event TicketBought(address indexed sender, uint amount);
    event Withdraw(address indexed participant, uint amount);
    event WithdrawByWinner(address indexed winner, uint amount);
    event End(address winner, uint amount);

    uint public prize; // wei
    mapping(uint => address) public tickets; // maps id ticket to participant address
    mapping(address => TicketVoucher) public participants; // maps address participant to ticket voucher
    uint public minimumTickets;
    address payable public host;
    uint public ticketPrice;
    address payable public winner;
    uint public endAt;
    bool public started;
    bool public ended;

    // uint private ticketId = 0;
    uint public ticketCount;

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
        require(block.timestamp < endAt, "raffle has ended, time expired");
        require(msg.value == ticketPrice, "value must equal to ticket price");

        TicketVoucher storage ticketVoucher = participants[msg.sender];
        if (ticketVoucher.exists) {
            ticketVoucher.ticketsBought.push(ticketCount);
        } else {
            ticketVoucher.exists = true;
            ticketVoucher.ticketsBought.push(ticketCount);
        }
        tickets[ticketCount] = msg.sender;
        // ticketId++;
        ticketCount++;
        emit TicketBought(msg.sender, msg.value);
    }

    function getTicketsBoughtByAddress(address addr) view public returns (uint[] memory) {
        return participants[addr].ticketsBought;
    }

    function getTotalAmountTicketsBoughtByAddress(address addr) view public returns (uint result) {
        uint numTicketsBought = getTicketsBoughtByAddress(addr).length;
        result = numTicketsBought * ticketPrice;
    }

    function withdraw () external {
        require(block.timestamp >= endAt, "cannot withdraw before ended or due date");
        if (msg.sender == winner && (block.timestamp >= endAt || ended)) {  // Winner case
            payable(winner).transfer(prize);
            emit WithdrawByWinner(winner, prize);
        }
        else if ( (ended || ticketCount < minimumTickets) && block.timestamp >= endAt) { // When time has expired and the minimum spot count is not filled
            uint bal = getTotalAmountTicketsBoughtByAddress(msg.sender);

            if (bal == 0) {
                revert("Unable to withdraw: your balance is 0 in this raffle");
            }
            removeTicketsAndParticipant(msg.sender);

            payable(msg.sender).transfer(bal);
            emit Withdraw(msg.sender, bal);
        } else {
            revert("Unable to withdraw");
        }
    }

    function changeEndAtDateTo(uint _endAt) external {
        endAt = _endAt;
    }

    // REMOVE!! ONLY FOR TESTING PURPOSES
    function changeWinner(address addr) external {
        winner = payable(addr);
    }

    function getNowTime() view external returns (uint) {
        return block.timestamp;
    }

    function removeTicketsAndParticipant(address addr) internal {
        //Remove from tickets map
        uint[] memory idsToDelete = getTicketsBoughtByAddress(addr);
        for (uint i = 0; i < idsToDelete.length; i++) {
            delete tickets[idsToDelete[i]];
            ticketCount--;
        }

        //Remove from participant map
        delete participants[addr];
    }
}
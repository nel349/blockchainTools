pragma solidity ^0.7.1;

contract Investment {
    event CheckBalance(address indexed from, uint256 amount);

    uint256 balanceAmount;
    uint256 depositAmount;
    uint256 thresholdAmount;
    uint256 returnOnInvestment;

    constructor() {
        balanceAmount = getBalanceAmount();
        depositAmount = 0;
        thresholdAmount = 12;
        returnOnInvestment = 3;
        emit CheckBalance(msg.sender, balanceAmount);
    }

    function getBalanceAmount() public view returns (uint256) {
        return msg.sender.balance / (1e16);
    }

    function getDepositAmount() public view returns (uint256) {
        return depositAmount;
    }

    function addDepositAmount(uint256 amount) public {
        depositAmount = depositAmount + amount;

        if (depositAmount >= thresholdAmount) {
            balanceAmount = depositAmount + returnOnInvestment;
        }
    }

    function withdrawBalance() public {
        balanceAmount = 0;
        depositAmount = 0;
    }
}
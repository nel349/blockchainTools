importScripts("https://binaries.soliditylang.org/bin/soljson-v0.8.13+commit.abaa5c0e.js");
importScripts("browser-solc.new.min.js");

var sourceCode='';

function loadSolJson(solcInput) {
  var compiler = solc(Module);
  var result = compiler.compile(solcInput);

  console.log("Running compilation")

  postMessage(result);
}

onmessage = function(event) {
  sourceCode += event.data

  var solcInput = {
    language: "Solidity",
    sources: { 
        contract: {
            content: sourceCode
        }
     },
    settings: {
        outputSelection: {
            "*": {
              "*": [
                "abi","evm.bytecode"
              ]
            },
        }
    }
  };
  
  solcInput = JSON.stringify(solcInput);

  loadSolJson(solcInput)
};

// var exampleSource = "pragma solidity ^0.8.13;contract Investment {event CheckBalance(address indexed from, uint256 amount);uint256 balanceAmount;uint256 depositAmount;uint256 thresholdAmount;uint256 returnOnInvestment;constructor() {balanceAmount = getBalanceAmount();depositAmount = 0;thresholdAmount = 12;returnOnInvestment = 3;emit CheckBalance(msg.sender, balanceAmount);}function getBalanceAmount() public view returns (uint256) {return msg.sender.balance / (1e16);}function getDepositAmount() public view returns (uint256) {return depositAmount;}function addDepositAmount(uint256 amount) public {depositAmount = depositAmount + amount;if (depositAmount >= thresholdAmount) {balanceAmount = depositAmount + returnOnInvestment;}}function withdrawBalance() public {balanceAmount = 0;depositAmount = 0;} }" //testing







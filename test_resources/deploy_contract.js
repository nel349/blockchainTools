var Tx = require('ethereumjs-tx');
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab");
const web3 = new Web3(provider);

const account1 = '0x33d312c90831F42840E412DC2094a61a99d5Cb57'; // Your account address 1
//const account2 = '' // Your account address 2
web3.eth.defaultAccount = account1;

const privateKey1 = Buffer.from('afd01d2beeb0db02600fcfee2a85805e6b59a32d6bc89cfa91ef55926e289c3b', 'hex');

const abi = [{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"greet","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getGreeting","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}];

const contract_Address = "0x0000000000000000000000000000000000000000";

const myContract = new web3.eth.Contract(abi, contract_Address);

const myData = myContract.methods.greet( "hello blockchain devs").encodeABI();


const txCount = web3.eth.getTransactionCount(account1);

// Build the transaction
var txObject = {
    nonce:    web3.utils.toHex(txCount),
    to:       contract_Address,
    value:    web3.utils.toHex(web3.utils.toWei('0', 'ether')),
    gasLimit: web3.utils.toHex(2100000),
    gasPrice: web3.utils.toHex(web3.utils.toWei('6', 'gwei')),
    data: myData  
}
// Sign the transaction
const tx = new Tx.Transaction(txObject, { chain: 'ropsten' });
tx.sign(privateKey1)

const serializedTx = tx.serialize();
const raw = '0x' + serializedTx.toString('hex');

// Broadcast the transaction
web3.eth.sendSignedTransaction(raw, (error, txHash) => {
    // console.log(chalk.green("sendSignedTransaction error, txHash"), error, txHash);
    console.log("hash: ", txHash)
    console.log("errors: ", error)
  })
    .on('confirmation', (confirmationNumber, receipt) => {
      console.log( confirmationNumber);
    })
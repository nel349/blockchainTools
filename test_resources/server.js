const Web3 = require('web3');
const tx = require('ethereumjs-tx').Transaction;

var HDWalletProvider = require("truffle-hdwallet-provider");
//load single private key as string
var provider = new HDWalletProvider("afd01d2beeb0db02600fcfee2a85805e6b59a32d6bc89cfa91ef55926e289c3b", "https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab';
const web3 = new Web3(provider);

let abi = '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"}]';
let bytecode = '6080604052348015600f57600080fd5b50603f80601d6000396000f3fe6080604052600080fdfea264697066735822122053fea42d7f6e2edb70e6fc91e8322c6eaf42a7edb89f3a5c9361f0d8268422b964736f6c63430007010033';

let deploy_contract = new web3.eth.Contract(JSON.parse(abi));

let account = '0x33d312c90831F42840E412DC2094a61a99d5Cb57'; 
let payload = {
    data: bytecode
}

let parameter = {
    from: account,
    gas: web3.utils.toHex(800000),
    gasPrice: web3.utils.toHex(web3.utils.toWei('35', 'gwei'))
}

deploy_contract.deploy(payload).send(parameter, (_, transactionHash) => {
    console.log('Transaction Hash :', transactionHash);
}).on('confirmation', () => {}).then((newContractInstance) => {
    console.log('Deployed Contract Address : ', newContractInstance.options.address);
});

// var myContract = new web3.eth.Contract([...], '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe', {
//   from: '0x1234567890123456789012345678901234567891', // default from address
//   gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
// });


//*********************** */ sign transaction

// var ropstenAddress = "0x33d312c90831F42840E412DC2094a61a99d5Cb57";
// const nonce = web3.eth.getTransactionCount(ropstenAddress);

// const rawTx =
// {
//     nonce: nonce,
//     from: ropstenAddress,
//     to: "0x",
//     gasPrice: _hex_gasPrice,
//     gasLimit: _hex_gasLimit,
//     gas: _hex_Gas,
//     value: '0x0',
//     data: contract.methods.transfer(toAddress, _hex_value).encodeABI()
// };



// Or, pass an array of private keys, and optionally use a certain subset of addresses
// var privateKeys = [
//   "3f841bf589fdf83a521e55d51afddc34fa65351161eead24f064855fc29c9580",
//   "9549f39decea7b7504e15572b2c6a72766df0281cea22bd1a3bc87166b1ca290",
// ];
// var provider = new HDWalletProvider(privateKeys, "http://localhost:8545", 0, 2);



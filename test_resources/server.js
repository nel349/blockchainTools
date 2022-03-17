
// const HDWalletProvider = require("hd-wallet-provider");

const HDWalletProvider = require("hdwallet-provider");

// const { Web3 } = require("./web3.min");

// import HDWalletProvider from './bundle.js'

//load single private key as string
var provider = new HDWalletProvider("afd01d2beeb0db02600fcfee2a85805e6b59a32d6bc89cfa91ef55926e289c3b", "https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab';
const web3_instance = new Web3(provider);

let abi = '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"}]';
let bytecode = '6080604052348015600f57600080fd5b50603f80601d6000396000f3fe6080604052600080fdfea264697066735822122053fea42d7f6e2edb70e6fc91e8322c6eaf42a7edb89f3a5c9361f0d8268422b964736f6c63430007010033';

let deploy_contract = new web3_instance.eth.Contract(JSON.parse(abi));

let account = '0x33d312c90831F42840E412DC2094a61a99d5Cb57'; 
let payload = {
    data: bytecode
}

let parameter = {
    from: account,
    gas: web3_instance.utils.toHex(800000),
    gasPrice: web3_instance.utils.toHex(web3_instance.utils.toWei('35', 'gwei'))
}

// function deployContract() {
    deploy_contract.deploy(payload).send(parameter, (_, transactionHash) => {
        console.log('Transaction Hash :', transactionHash);
    }).on('confirmation', () => {}).then((newContractInstance) => {
        console.log('Deployed Contract Address : ', newContractInstance.options.address);
    });
// }
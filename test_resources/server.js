const HDWalletProvider = require("hdwallet-provider");

//load single private key as string
var provider = new HDWalletProvider("afd01d2beeb0db02600fcfee2a85805e6b59a32d6bc89cfa91ef55926e289c3b", "https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab';
const web3_instance = new Web3(provider);

var transactionHashResult = "";
var bytecode = '8908098098098098';
let abi = '[]';
let fromEthAddress = '';
let privatKey = '';

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

function deployContract() {
    deploy_contract.deploy(payload).send(parameter, (_, transactionHash) => {
        console.log('Transaction Hash :', transactionHash);
        transactionHashResult = transactionHash;
    }).on('confirmation', () => {}).then((newContractInstance) => {
        console.log('Deployed Contract Address : ', newContractInstance.options.address);
    });
}

function getTransactionHashResult() {
    return transactionHashResult;
}
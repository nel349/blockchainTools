const HDWalletProvider = require("hdwallet-provider");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab'; // ethereum
const rpcMumbai = 'https://polygon-mumbai.g.alchemy.com/v2/wDKjb83mAC3ok5MgMg1vWvc78NAa59zo'; // Polygon

//load single private key as string
var provider = new HDWalletProvider("afd01d2beeb0db02600fcfee2a85805e6b59a32d6bc89cfa91ef55926e289c3b", rpcMumbai);


const web3_instance = new Web3(provider);

var transactionHashResult = "";
var bytecode = '8908098098098098';
var abi = '[]';
let fromEthAddress = '';
let privatKey = '';

var deploy_contract = new web3_instance.eth.Contract(JSON.parse(abi));

let account = '0x33d312c90831F42840E412DC2094a61a99d5Cb57'; 

const gasCost = '40';
let parameter = {
    from: account,
    gas: web3_instance.utils.toHex(5511498),
    gasPrice: web3_instance.utils.toHex(web3_instance.utils.toWei(gasCost, 'gwei'))
}

function deployContract() {
    let payload = {
        data: bytecode
    }

    deploy_contract.deploy(payload).send(parameter, (_, transactionHash) => {
        console.log('Transaction Hash :', transactionHash);
        console.log('Gas Cost :', gasCost);
        transactionHashResult = transactionHash;
    }).on('confirmation', () => {}).then((newContractInstance) => {
        console.log('Deployed Contract Address : ', newContractInstance.options.address);
    });
}

function getTransactionHashResult() {
    return transactionHashResult;
}

//Convert ts script to js, then convert into a browser version. removing require dependencies. 
// browserify -r ./hdwallet-provider.ts:hdwallet-provider  -p [ tsify --noImplicitAny] -o  hdwallet-provider-min.js
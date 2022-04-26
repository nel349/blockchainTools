const HDWalletProvider = require("hdwallet-provider");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab'; // ethereum
const rpcURLRinkeby = 'https://rinkeby.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab';
const rpcMumbai = 'https://polygon-mumbai.g.alchemy.com/v2/wDKjb83mAC3ok5MgMg1vWvc78NAa59zo'; // Polygon

//load single private key as string
var provider = new HDWalletProvider("c07dc9fe23081f4f06d1c1f8211f2627be0b178c47bddd3ad06177fffe3c5d5f", rpcMumbai);


const web3_instance = new Web3(provider);

var transactionHashResult = "";
var bytecode = '8908098098098098';
var abi = '[]';
let fromEthAddress = '';
let privatKey = '';

var deploy_contract = new web3_instance.eth.Contract(JSON.parse(abi));

let account = '0x0b6cd4c4bD7339859F242eDb7830935aB4e5dc11'; 

const gasCost = '40';
const gasLimit = 5511498;
let parameter = {
    from: account
}

function deployContract() {
    let payload = {
        data: bytecode
    }

    deploy_contract.deploy(payload).send(parameter, (_, transactionHash) => {
        console.log('Transaction Hash :', transactionHash);
        // console.log('Gas Cost :', gasCost);
        // estimateGasFor(bytecode);
        transactionHashResult = transactionHash;
    })
    .on('transactionHash', (transactionHashResult) =>{
        console.log('Transaction HASH ', transactionHashResult);
    })
    .on('confirmation', () => {}).then((newContractInstance) => {
        console.log('Deployed Contract Address : ', newContractInstance.options.address);
    });
}

function estimateGasFor(bytecode){
    web3_instance.eth.estimateGas({
        to: "0x0000000000000000000000000000000000000000",
        data: bytecode}).then(value => {console.log('Estimated gas: ', value);});
}

function getTransactionHashResult() {
    return transactionHashResult;
}

//Convert ts script to js, then convert into a browser version. removing require dependencies. 
// browserify -r ./hdwallet-provider.ts:hdwallet-provider  -p [ tsify --noImplicitAny] -o  hdwallet-provider-min.js
const HDWalletProvider = require("hdwallet-provider");

const rpcURL = 'https://ropsten.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab'; // ethereum
const rpcURLRinkeby = 'https://rinkeby.infura.io/v3/a2293dab520a45fba5a5ab184d14e8ab';
const rpcMumbai = 'https://polygon-mumbai.g.alchemy.com/v2/wDKjb83mAC3ok5MgMg1vWvc78NAa59zo'; // Polygon

//load single private key as string
var provider = new HDWalletProvider("12ba688b588f2096b1af28d16cff4037bbc735a38f8c975a6b9a4582dc16fdff", rpcMumbai);


const web3_instance = new Web3(provider);

var transactionHashResult = "";
var bytecode = '8908098098098098';
var abi = '[]';
let fromEthAddress = '';
let privatKey = '';

var deploy_contract = new web3_instance.eth.Contract(JSON.parse(abi));

let account = '0xc3511d52D2e03B5edDE1e1F55F1c22fd5f5369D9'; 

const gasCost = '40';
const gasLimit = 5511498;
let parameter = {
    from: account,
    gas: web3_instance.utils.toHex(gasLimit),
    gasPrice: web3_instance.utils.toHex(web3_instance.utils.toWei(gasCost, 'gwei'))
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
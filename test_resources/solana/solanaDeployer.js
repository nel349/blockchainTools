import { Connection, LAMPORTS_PER_SOL, Keypair } from '@solana/web3.js'
import { BpfLoader, SystemProgram, PublicKey, Loader, Transaction } from '@solana/web3.js'
import { lchownSync, readFile, readFileSync } from 'fs'
import fs from 'mz/fs.js';

const BUNDLE_SO = readFileSync('./solana/solanalotto.so')
const secretKeyString = await fs.readFile("./solana/solanalotto-keypair.json", {encoding: 'utf8'});
const secretKey = Uint8Array.from(JSON.parse(secretKeyString));
const programKeypair = Keypair.fromSecretKey(secretKey);

console.log('Connecting to your local Solana node ...')
const connection = new Connection(
    // works only for localhost at the time of writing
    // see https://github.com/solana-labs/solana-solidity.js/issues/8
    "http://localhost:8899",
    'confirmed'
)

const payer = Keypair.generate()
var balance;
while (true) {
    console.log('Airdropping (from faucet) SOL to a new wallet ...')
    await connection.requestAirdrop(payer.publicKey, 4 * LAMPORTS_PER_SOL)
    await new Promise((resolve) => setTimeout(resolve, 1000))
    balance = await connection.getBalance(payer.publicKey)
    if (balance) {
        console.log("Current balance for: " + payer.publicKey + " is " + balance)
        break
    } 
}
while (true) {
    // console.log('Airdropping (from faucet) SOL to a program wallet ...')
    // await connection.requestAirdrop(programKeypair.publicKey, 1 * LAMPORTS_PER_SOL)
    // await new Promise((resolve) => setTimeout(resolve, 1000))
    balance = await connection.getBalance(programKeypair.publicKey)
    if (balance) {
        console.log("Current balance for program wallet: " + programKeypair.publicKey + " is " + balance)
        break
    } 
}

// while (true) {
//     console.log('Airdropping (from faucet) SOL to a program wallet ...')
//     await connection.requestAirdrop(payer.publicKey, 4 * LAMPORTS_PER_SOL)
//     await new Promise((resolve) => setTimeout(resolve, 1000))
//     const balance = await connection.getBalance(payer.publicKey)
//     if (balance) {
//         console.log("Current balance for: " + payer.publicKey + " is " + balance)
//         break
//     } 
// }

const programId = new PublicKey(
    programKeypair.publicKey);

console.log("program id: " + programId.toBase58())

const lottoAccount = Keypair.generate();

let instruction = SystemProgram.createAccount({
    fromPubkey: payer.publicKey, 
    lamports: LAMPORTS_PER_SOL * 3,
    newAccountPubkey: lottoAccount.publicKey, 
    programId: programId,
    space: 233
});

let transaction = new Transaction().add(instruction);

await connection.sendTransaction(transaction, [payer, lottoAccount])

// while (true) {
//     console.log('getting new balance for lotto...')
//     await new Promise((resolve) => setTimeout(resolve, 1000))
//     balance = await connection.getBalance(lottoAccount.publicKey)
//     if (balance) {
//         console.log("Current balance for lotto: " + lottoAccount.publicKey + " is " + balance)
//         break
//     } 
// }


// while (true) {
//     console.log('attempting to deploy...')
//     await new Promise((resolve) => setTimeout(resolve, 1000))
//     const resultLoad = await Loader.load(connection, payer, programKeypair, lottoAccount.publicKey, BUNDLE_SO)
//     if (resultLoad) {
//         console.log("Successfully deployed")
//         break
//     } 
// }


const resultLoad = await Loader.load(connection, payer, lottoAccount, programId, BUNDLE_SO)


// console.log("%s should be true", resultLoad)




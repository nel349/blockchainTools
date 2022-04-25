import { Connection, LAMPORTS_PER_SOL, Keypair, BPF_LOADER_PROGRAM_ID } from '@solana/web3.js'
import { BpfLoader, SystemProgram, PublicKey, Transaction } from '@solana/web3.js'
import { lchownSync, readFile, readFileSync } from 'fs'
import fs from 'mz/fs.js';

const data = readFileSync('./solanalotto.so')
const secretKeyString = await fs.readFile("./solanalotto-keypair.json", {encoding: 'utf8'});
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
var payerBalance;
while (true) {
    console.log('Airdropping (from faucet) SOL to a new wallet ...')
    await connection.requestAirdrop(payer.publicKey, 4 * LAMPORTS_PER_SOL)
    await new Promise((resolve) => setTimeout(resolve, 1000))
    payerBalance = await connection.getBalance(payer.publicKey)
    if (payerBalance) {
        console.log("Current payer balance for: " + payer.publicKey + " is " + payerBalance)
        break
    } 
}

// const programAccount = new Keypair();
const resultLoad = await BpfLoader.load(
        connection,
        payer,
        programKeypair,
        data,
        BPF_LOADER_PROGRAM_ID
    )

const programId = programKeypair.publicKey;
console.log("Program loaded to account ", programId.toBase58())




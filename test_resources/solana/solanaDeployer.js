import { Connection, LAMPORTS_PER_SOL, Keypair } from '@solana/web3.js'

import { BpfLoader } from '@solana/web3.js'

console.log('Connecting to your local Solana node ...')
const connection = new Connection(
    // works only for localhost at the time of writing
    // see https://github.com/solana-labs/solana-solidity.js/issues/8
    "http://localhost:8899",
    'confirmed'
)

const payer = Keypair.generate()
while (true) {
    console.log('Airdropping (from faucet) SOL to a new wallet ...')
    await connection.requestAirdrop(payer.publicKey, 2 * LAMPORTS_PER_SOL)
    await new Promise((resolve) => setTimeout(resolve, 1000))
    const balance = await connection.getBalance(payer.publicKey)
    if (balance) {
        console.log("Current balance for: " + payer.publicKey + " is " + balance)
        break
    } 
}





# Developing blockchain app with flutter

*Motivation
Most dapps currently support only-web experiences. There is a lot of friction for mobile users. 
Compiling and deploying a smart contract over the blockchain requires many dependencies, from running
a hosted node to supporting client framework libraries. In this app I develop proof of concepts
to showcase the common dapp features that mostly exist in web based environments and expose what is missing.
I chose to do this experiment in flutter as they are far-away ecosystems.
different programming language and framework ecosystem.

Imagine if a user could just do all the below steps for minting an NFT without ever having to worry about what needs
to be done behind the curtains(described in parentheses below).
connect to wallet, (non-custodial)
build a smart contract, (create solidity SC, compile with solc, bpf loader for solana, etc..)
deploy a smart contract, (use HardHat or Truffle to deploy contract using a CLI interface)
change between blockchain networks, (connect to remote node provider for mobile users)
upload an NFT image, (upload an image to IPFS using Pinata, metaplex in solana, etc..)
mint an NFT, (make RPC call to mint token in command line, or web3 library)

There is a lot to be done in the blockchain industry and one important area to work on I believe is
portability. Most of the steps described above need to be encapsulated for the common user in order 
to increase adoption. There is a need for improvement in compilers, serializers, and security 
for the mobile sector to get more adoption from mobile developers. 

Currently working on the following features:
Smart contract deployment on Ethereum/Polygon Solidity 
NFT minting engine on Ethereum/Polygon Solidity

UpComing: 
Interoperability on (Solana, Cardano, Avalanche, etc...)
ERC-20 token factory with attributes (reflection, burn)




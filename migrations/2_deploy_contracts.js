// which contracts we'd like to interact with via the artifacts.require() method
const MyNftTokenCondensed = artifacts.require("MyNftTokenCondensed");

// All migrations must export a function via the module.exports syntax
module.exports = function (deployer) {
  // The function exported by each migration should accept a deployer object
  deployer.deploy(MyNftTokenCondensed, "MYNFTNAME", // Token name
   "NFT", // Token symbol
    "100000000000000000", // Cost
    10, // Max supply
    1, // Max mint ammount per tx
    "ifps//:something/blah"
     );
};

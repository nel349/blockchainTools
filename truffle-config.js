module.exports = {
  networks: {
    development: {
      host: "0.0.0.0",
      port: 7545,
      network_id: "*", // Match any network id
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
    version: ">=0.7.0 <0.9.0",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};

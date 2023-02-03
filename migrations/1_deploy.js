const Nfts = artifacts.require("MyMarketPlace");

module.exports = async function (deployer) {
  deployer.deploy(Nfts);
};

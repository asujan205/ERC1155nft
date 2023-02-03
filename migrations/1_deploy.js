const Nfts = artifacts.require("MyMarketPlace");

module.exports = async function (deployer) {
  deployer.deploy(Nfts, "0x2d2071e0f10EacF7b1E17232300b9a9085b86366");
};

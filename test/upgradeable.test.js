const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Upgradeable", function () {
  async function dep() {
    const [deployer] = await ethers.getSigners();
    const NFTFactory = await ethers.getContractFactory("MyNFTToken");
    const token = await upgrades.deployProxy(NFTFactory, [], {
      initializer: "initialize",
    });
    await token.deployed();
    return { token, deployer };
  }
  it("works", async () => {
    const { token, deployer } = await loadFixture(dep);
    const mintTx = await token.safeMint(deployer.address, "123abc");
    await mintTx.wait();
    expect(await token.balanceOf(deployer.address)).to.eq(1);
  });
});

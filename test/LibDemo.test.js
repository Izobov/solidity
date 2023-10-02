const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LibDemo", function () {
  let acc1, contract;
  beforeEach(async () => {
    [acc1] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("LibDemo", acc1);
    contract = await Contract.deploy();
    await contract.waitForDeployment();
  });

  it("compare strings", async () => {
    const res = await contract.runnerStr("cat", "cat");
    expect(res).to.be.true;
    const res2 = await contract.runnerStr("cat", "dog");
    expect(res2).to.be.false;
  });
  it("finds uint in arr", async () => {
    const res = await contract.runnerArr([1, 2, 3], 2);
    expect(res).to.be.true;
    const res2 = await contract.runnerArr([1, 2, 3], 4);
    expect(res2).to.be.false;
  });
});

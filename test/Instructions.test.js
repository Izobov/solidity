const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Instructions", function () {
  let acc1, acc2, contract;
  beforeEach(async () => {
    [acc1, acc2] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("Instructions", acc1);
    contract = await Contract.deploy();
    await contract.waitForDeployment();
  });

  async function sendMoney(sender) {
    const amount = 100;
    const txData = {
      to: contract.address,
      value: amount,
    };
    const tx = await sender.sendTransaction(txData);
    await tx.wait();
    return [tx, amount];
  }
  it("send money to contract", async () => {
    const [tx, amount] = await sendMoney(acc2);
    await expect(() => tx).to.changeEtherBalance(contract, amount);
    const ts = (await ethers.provider.getBlock(tx.blockNumber)).timestamp;
    await expect(tx).to.emit(contract, "Paid").withArgs(acc2, amount, ts);
  });

  it("allows withdraw", async () => {
    const [_, amount] = await sendMoney(acc2);
    const tx = await contract.withdraw(acc1.address);
    await expect(() => tx).to.changeEtherBalances(
      [contract, acc1],
      [-amount, amount]
    );
  });

  it("withdraw only owner can withdraw", async () => {
    const [_, amount] = await sendMoney(acc2);
    const tx = await contract.connect(acc2).withdraw(acc1.address);
    await expect(() => tx).to.be.revertedWith("You are not owner!");
  });
});

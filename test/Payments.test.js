const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Payments", function () {
  let acc1, acc2, payments;
  beforeEach(async () => {
    [acc1, acc2] = await ethers.getSigners();
    const Payments = await ethers.getContractFactory("Payments", acc1);
    payments = await Payments.deploy();
    await payments.waitForDeployment();
  });

  it("Check contract address", async () => {
    const address = await payments.getAddress();

    expect(address).to.be.properAddress;
  });

  it("should have 0 ether by default", async () => {
    const balance = await payments.currentBalance();
    expect(balance).to.eq(0);
  });

  it("send funds", async () => {
    const sum = 100;
    const tx = await payments.connect(acc2).pay({ value: sum });
    await expect(() => tx).to.changeEtherBalances(
      [acc2, payments],
      [-sum, sum]
    );
  });

  it("get payment info", async () => {
    const tx = await payments.connect(acc2).pay({ value: 100 });
    await tx.wait();
    const info = await payments.getPayment(acc2.address, 0);
    expect(info.amount).to.eq(100);
    expect(info.from).to.eq(acc2.address);
  });
});

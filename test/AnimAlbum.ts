import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Animalbum", function () {

  async function deployTokenFixture() {

    const [owner, addr1, addr2] = await ethers.getSigners();

    const animAlbum = await ethers.deployContract("AnimAlbum");

    await animAlbum.waitForDeployment();

    return { animAlbum, owner, addr1, addr2 };
  }
  
  it("Should revert with the right error if called by the owner", async function () {

    const { animAlbum } = await loadFixture(deployTokenFixture);

    await expect(animAlbum.claim()).to.be.revertedWith("You are the owner");
  });

  it("Should get a token by claim", async function () {

    const { animAlbum, addr1 } = await loadFixture(deployTokenFixture);

    await animAlbum.connect(addr1).claim();

    let address1_Balance = [];
    for (let index = 0; index < 10; index++) {
      address1_Balance.push(await animAlbum.balanceOf(addr1.address, index));      
    }

    expect(address1_Balance.some(balance => 1)).to.equal(true);
  });

  it("Should revert if try to claim again in the same day", async function () {

    const { animAlbum, addr1 } = await loadFixture(deployTokenFixture);

    await animAlbum.connect(addr1).claim();
    await expect(animAlbum.connect(addr1).claim()).to.be.revertedWith("Only one claim per day");

    const ONE_DAY_IN_SECS = 24 * 60 * 60;
    const oneDay = (await time.latest()) + ONE_DAY_IN_SECS;
    await time.increaseTo(oneDay);
    await animAlbum.connect(addr1).claim();

    let address1_Balance = [];
    for (let index = 0; index < 10; index++) {
      address1_Balance.push(await animAlbum.balanceOf(addr1.address, index));      
    }
    
    expect(address1_Balance.reduce((total, num) => total + num)).to.equal(2);
  });

  it("Should set uri", async function () {

    const { animAlbum } = await loadFixture(deployTokenFixture);

    const expectedUri = 'https://azure-renewed-dog-869.mypinata.cloud/ipfs/QmQiEHcaTWaek5We6rwDyJtR2NMRfB8UUqjLCefbjz12Jp/1.json';

    const uri = await animAlbum.uri(1);

    expect(expectedUri).to.equal(uri);

    const res = await animAlbum.hola();

    console.log(res)
    console.log(Number(res) % 20)
  });
});

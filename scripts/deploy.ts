import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const time = currentTimestampInSeconds + 60;

  const animAlbum = await ethers.deployContract("AnimAlbum");

  await animAlbum.waitForDeployment();

  console.log(
    `Animalbum with ETH and unlock timestamp ${time} deployed to ${animAlbum.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

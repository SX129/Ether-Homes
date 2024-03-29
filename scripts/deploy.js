// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), 'ether');
}

async function main() {
  // Setup accounts
  [lender, inspector, seller, buyer] = await ethers.getSigners();

  // Deploy Real Estate contract
  const RealEstate = await ethers.getContractFactory('RealEstate');
  const realEstate = await RealEstate.deploy();
  await realEstate.deployed();

  console.log(`RealEstate deployed to: ${realEstate.address}`);

  // Loop to Mint property NFTs on IPFS
  for (let i = 0; i < 3; i++) {
    const transaction = await realEstate.connect(seller).mint(`https://ipfs.io/ipfs/QmQVcpsjrA6cr1iJjZAodYwmPekYgbnXGo4DFubJiLc2EB/${i + 1}.json`);
    await transaction.wait();
  }

  console.log(`Minted 3 properties on IPFS`);

  // Deploy Escrow contract
  const Escrow = await ethers.getContractFactory('Escrow');
  escrow = await Escrow.deploy(
      lender.address,
      inspector.address,
      seller.address,
      realEstate.address,
  );
  await escrow.deployed();

  console.log(`Escrow deployed to: ${escrow.address}`);

  // Loop to Approve properties
  for (let i = 0; i < 3; i++) {
    let transaction = await realEstate.connect(seller).approve(escrow.address, i + 1);
    await transaction.wait();
  }

  // List properties
  transaction = await escrow.connect(seller).list(1, tokens(20), buyer.address, tokens(10));
  await transaction.wait();

  transaction = await escrow.connect(seller).list(2, tokens(10), buyer.address, tokens(5));
  await transaction.wait();

  transaction = await escrow.connect(seller).list(3, tokens(15), buyer.address, tokens(5));
  await transaction.wait();

  console.log(`Completed listing properties`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

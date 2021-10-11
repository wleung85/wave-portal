const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  /* We don't need to call waveCount.wait() because getTotalWaves() is a view,
   * i.e. does not affect anything in the blockchain and is read-only */
  let waveCount = await waveContract.getTotalWaves();
  console.log(waveCount.toNumber());

  /* Sending waves */
  let waveTxn = await waveContract.wave('A message!');
  await waveTxn.wait(); // wait for transaction to be mined

  waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();
  console.log("Total number of waves: %d", waveCount);

  // Get how many times owner has waved
  let userWaveCount = await waveContract.getAddrWaveCount();
  console.log("Total number of waves from %d: %d", owner, userWaveCount);

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
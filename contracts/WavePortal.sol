// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;
  uint256 private seed;
  mapping (address => uint256) private addrWaveCount;
  mapping (address => uint256) private lastWavedAt;
  mapping (address => uint256) private lastWonAt;

  event NewWave(address indexed from, uint256 timestamp, string message);

  struct Wave {
    address waver;
    string message;
    uint256 timestamp;
  }

  struct TopWaver {
    address waver;
    uint256 count;
  }

  Wave[] waves;

  /* Tracks top 3 wavers */
  address[3] topWavers;

  constructor() payable {
    console.log("Smart contract successfully deployed!");
  }

  function wave(string memory _message) public {
    require(
      lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
      "Wait 30s"
    );

    uint256 userNumWaves;

    /* Update the current timestamp we have for the user */
    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves += 1;
    addrWaveCount[msg.sender] += 1;
    userNumWaves = addrWaveCount[msg.sender];
    console.log("%s has waved!", msg.sender);

    /* Store wave in array */
    waves.push(Wave(msg.sender, _message, block.timestamp));

    /* Add to waverScores if needed */
    if (userNumWaves >= addrWaveCount[topWavers[0]]) {
      // replace 1st place if not already 1st place
      if (topWavers[0] != msg.sender) {
        if (topWavers[1] != msg.sender) {
          topWavers[2] = topWavers[1];
        }
        topWavers[1] = topWavers[0];
        topWavers[0] = msg.sender;
      }

      require(
        lastWonAt[msg.sender] + 60 minutes < block.timestamp,
        "Same user can only win once every 60 minutes."
      );

      uint256 prizeAmount = 0.0001 ether;
      require(
        prizeAmount <= address(this).balance,
        "Trying to withdraw more than the contract has."
      );
      (bool success, ) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money from contract.");
      lastWonAt[msg.sender] = block.timestamp;

    } else if (userNumWaves >= addrWaveCount[topWavers[1]]) {
      // replace 2nd place if not already 2nd place
      if (topWavers[1] != msg.sender) {
        topWavers[2] = topWavers[1];
        topWavers[1] = msg.sender;
      }

    } else if (userNumWaves >= addrWaveCount[topWavers[2]]) {
      // replace 3rd place if not already 3rd place
      if (topWavers[2] != msg.sender) {
        topWavers[2] = msg.sender;
      }
    }

    // /* Generate a pseudo random number between 0 and 100 */
    // uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    // console.log("Random # generated: $s", randomNumber);

    // seed = randomNumber;

    // /* Give a 50% chance that the user wins the prize */
    // if (randomNumber < 50) {
    //   console.log("%s won!", msg.sender);

    //   uint256 prizeAmount = 0.0001 ether;
    //   require(
    //     prizeAmount <= address(this).balance,
    //     "Trying to withdraw more than the contract has."
    //   );
    //   (bool success, ) = (msg.sender).call{value: prizeAmount}("");
    //   require(success, "Failed to withdraw money from contract.");
    // }

    emit NewWave(msg.sender, block.timestamp, _message);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("We have %d total waves!", totalWaves);
    return totalWaves;
  }

  function getAddrWaveCount() public view returns (uint256) {
    console.log("%s has waved %s times!", msg.sender, addrWaveCount[msg.sender]);
    return addrWaveCount[msg.sender];
  }

  function getTopWavers() public view returns (TopWaver[3] memory) {
    TopWaver[3] memory topWaversSummary;
    for (uint i = 0; i < 3; i += 1) {
      topWaversSummary[i] = TopWaver(topWavers[i], addrWaveCount[topWavers[i]]);
    }
    return topWaversSummary;
  }
}
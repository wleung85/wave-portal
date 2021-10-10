// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;
  mapping (address => uint256) private addrWaveCount;

  constructor() {
    console.log("Smart contract successfully deployed!");
  }

  function wave() public {
    totalWaves += 1;
    addrWaveCount[msg.sender] += 1;
    console.log("%s has waved!", msg.sender);
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("We have %d total waves!", totalWaves);
    return totalWaves;
  }

  function getAddrWaveCount() public view returns (uint256) {
    console.log("%s has waved %s times!", msg.sender, addrWaveCount[msg.sender]);
    return addrWaveCount[msg.sender];
  }
}
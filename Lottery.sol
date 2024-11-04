// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Lottery{
    //entities - manager, players, winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }

    function participate() public payable{
        require(msg.value==1 ether, "Please pay 1 ether only!");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint){
        require(manager==msg.sender, "You are not the manager!");
        return address(this).balance;
    }

    // Simulate the process of obtaining a random number manually during development/testing
    uint private manualRandomNumber;

    function setManualRandomNumber(uint _manualRandomNumber) external {
        require(msg.sender == manager, "You are not the manager!");
        manualRandomNumber = _manualRandomNumber;
    }

    function getRandomNumber() internal view returns (uint) {
        // Use the manually set random number during development/testing
        if (manualRandomNumber != 0) {
            return manualRandomNumber;
        }

        // In production, we should use an off-chain oracle or service to get a random number
        // For demonstration purposes, we return a deterministic value
        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
    }

    function pickWinner() public {
        require(msg.sender==manager, "You are not the manager!");
        require(players.length>=3, "There are less than 3 players!");

        uint r = getRandomNumber();
        uint index = r%players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); // This will initialize the players array to zero
    }
}

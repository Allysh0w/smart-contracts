pragma solidity 0.5.16;

contract PrizeDraw {
    address private manager;
    address[] private players;
    address payable private winner; 

    constructor() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require (msg.value == .1 ether, "must send 0.1 eth or 100000000 Gwei");
        players.push(msg.sender);
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getBalance() public view returns (uint) {
        return uint(address(this).balance);
    }

    function randomValue() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, players)));
    }

    function getWinner() public restricted {
        uint index = randomValue() % players.length;
        winner = address(uint160(players[index]));
        winner.transfer(address(this).balance);
        resetPrizeDraw();
    }

    function resetPrizeDraw() private {
        players = new address[](0);
        winner = address(uint160(0x0));
    }

}
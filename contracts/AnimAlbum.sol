// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract AnimAlbum is ERC1155, Ownable {

    uint8 constant DECIMAL = 3;
    uint8 constant TOKEN_TYPES = 10;
    
    uint8 constant YAGUARETE = 1;
    uint8 constant PINGUINO = 2;
    uint8 constant PUMA = 3;
    uint8 constant GUANACO = 4;
    uint8 constant HORNERO = 5;
    uint8 constant TAPIR = 6;
    uint8 constant FLAMENCTO = 7;
    uint8 constant CARPINCHO = 8;
    uint8 constant TUCAN = 9;
    uint8 constant LOBO_MARINO = 10;

    mapping(address => uint256) lastUpdated;


    constructor() ERC1155("") {
        _mint(owner(), YAGUARETE, 10**DECIMAL, "");
        _mint(owner(), PINGUINO, 10**DECIMAL, "");
        _mint(owner(), PUMA, 10**DECIMAL, "");
        _mint(owner(), GUANACO, 10**DECIMAL, "");
        _mint(owner(), HORNERO, 10**DECIMAL, "");
        _mint(owner(), TAPIR, 10**DECIMAL, "");
        _mint(owner(), FLAMENCTO, 10**DECIMAL, "");
        _mint(owner(), CARPINCHO, 10**DECIMAL, "");
        _mint(owner(), TUCAN, 10**DECIMAL, "");
        _mint(owner(), LOBO_MARINO, 10**DECIMAL, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(abi.encodePacked("https://azure-renewed-dog-869.mypinata.cloud/ipfs/QmQiEHcaTWaek5We6rwDyJtR2NMRfB8UUqjLCefbjz12Jp/", Strings.toString(_tokenid),".json"));
    }

    function claim() external {
        require(msg.sender != owner(), "You are the owner");
        if (lastUpdated[msg.sender] != 0) {
            require(lastUpdated[msg.sender] < block.timestamp - 1 days, "Only one claim per day");
        }
        lastUpdated[msg.sender] = block.timestamp;
        _safeTransferFrom(owner(), msg.sender, getRandomNum(), 1, "");
     }

     function getRandomNum() private view returns (uint8) {
        uint8[] memory positions = new uint8[](TOKEN_TYPES);
        uint8 counter = 0;
        for (uint8 i = 1; i <= TOKEN_TYPES; i++) {
            if (this.balanceOf(owner(), i) > 0) {
                positions[counter] = i;
                counter++;
            }
        }        
        require(counter > 0, "There are not more tokens");        
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % counter;        
        return positions[randomIndex];
    }
}
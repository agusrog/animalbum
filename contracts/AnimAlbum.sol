// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract AnimAlbum is ERC1155, Ownable {
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
    uint8 constant CONDOR_BONUS = 11;
    mapping(address => uint256) lastUpdated;

    constructor() ERC1155("https://bafybeibqlc7ndk53klft26jy5atjjm2yuvov6tken6v2df3gadagshc3lm.ipfs.nftstorage.link/{id}.json") {}

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(abi.encodePacked("https://bafybeibqlc7ndk53klft26jy5atjjm2yuvov6tken6v2df3gadagshc3lm.ipfs.nftstorage.link/", Strings.toString(_tokenid),".json"));
    }

    modifier OnlyOnePerDay() {
        if (lastUpdated[msg.sender] != 0 && msg.sender != owner()) {
            require(
                lastUpdated[msg.sender] < block.timestamp - 1 days,
                "Only one claim per day"
            );
        }
        _;
    }

    function claim() external OnlyOnePerDay {
        lastUpdated[msg.sender] = block.timestamp;
        uint256 _tokenId = randomNum();
        _mint(msg.sender, _tokenId, 1, "");
    }

    function randomNum() private view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % TOKEN_TYPES) + 1;
    }

    function claimBonusToken() external {
        require(albumCompleted() == true, "The album is not completed");
        require(
            this.balanceOf(msg.sender, CONDOR_BONUS) == 0,
            "You already have this token"
        );
        _mint(msg.sender, CONDOR_BONUS, 1, "");
    }

    function albumCompleted() private view returns (bool) {
        bool _albumCompleted = true;
        for (uint256 i = 1; i <= TOKEN_TYPES; i++) {
            if (this.balanceOf(msg.sender, i) == 0) {
                _albumCompleted = false;
            }
        }
        return _albumCompleted;
    }
}

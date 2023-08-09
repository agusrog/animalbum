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
    mapping (uint256 => string) public meta;

    constructor() ERC1155("") {
        _setMeta();
    }

    modifier OnlyOnePerDay () {
        if (lastUpdated[msg.sender] != 0 && msg.sender != owner()) {
            require(lastUpdated[msg.sender] < block.timestamp - 1 days, "Only one claim per day");
        }_;
    }

    function claim() external OnlyOnePerDay {
        lastUpdated[msg.sender] = block.timestamp;
        uint256 tokenId = randomNum();
        _mint(msg.sender, tokenId, 1, "");
        _setURI(meta[tokenId]);
    }

    function randomNum() private view returns (uint256)  {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % TOKEN_TYPES + 1;
    }

    function claimBonusToken() external {
        require(albumCompleted() == true, "The album is not completed");
        require(this.balanceOf(msg.sender, CONDOR_BONUS) == 0, "You already have this token");
        _mint(msg.sender, CONDOR_BONUS, 1, "");
     }
     
     function albumCompleted() private view returns (bool) {
        bool _albumCompleted = true;
        for (uint i = 1; i <= TOKEN_TYPES; i++) 
        {
            if (this.balanceOf(msg.sender, i) == 0) {
            _albumCompleted = false;
            }
        }
        return _albumCompleted;
     }

     function _setMeta() private {
        meta[1] = "https://bafkreigs4chuzadpeury7adx33ypabvfad6s2swksxbabrpjlvijxrkxry.ipfs.nftstorage.link/";
        meta[2] = "https://bafkreihpd7rzrczwza3cdn4nxoznfs44qs57r54s3ss5xotjadchklodje.ipfs.nftstorage.link/";
        meta[3] = "https://bafkreiaf66cqv5isjhoppqcmcskfer3sjz4xsljlx3jx2iswzlnzpfqvca.ipfs.nftstorage.link/";
        meta[4] = "https://bafkreidamoxjbhgkx5yy2z2hhdyb4q2xk3y5ukv22cricucolhoopmb5ii.ipfs.nftstorage.link/";
        meta[5] = "https://bafkreiairkjgzlzpu3jxipioakzbhryoztwsfok2cjrwi3y7krwufr2uya.ipfs.nftstorage.link/";
        meta[6] = "https://bafkreiept7jca2vkgezjxohvogelaohgft34bgaptwdllz66elusxs7tjm.ipfs.nftstorage.link/";
        meta[7] = "https://bafkreidkedkwladass4zkhwqfkm2yp6yzzgk5lbv4lwi7v73cjgwzjm2i4.ipfs.nftstorage.link/";
        meta[8] = "https://bafkreidlssv5cpv3s63druai6qxyyait6i5qhowe4akvj7tl622ajwlffm.ipfs.nftstorage.link/";
        meta[9] = "https://bafkreidfqfwvozwvibnkk34psw2y3njh2dvngr37pc3nhsmt3xcgsbb4o4.ipfs.nftstorage.link/";
        meta[10] = "https://bafkreibh2du7lm7f2352cf6vrcjboib3q5yfz3b4tsdhntocpch2au4yjm.ipfs.nftstorage.link/";
        meta[11] = "https://bafkreigbww5yygr4dzcrnn5m2okq6lndy46jualjenibdl5soj7fmndvm4.ipfs.nftstorage.link/";
    }
}

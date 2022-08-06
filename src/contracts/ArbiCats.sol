// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArbiCats is ERC721, ERC721URIStorage {
    event CatUpdated(
        uint256 happiness,
        uint256 hunger,
        uint256 enrichment,
        uint256 checked,
        string uri,
        uint256 index
    );

    struct CatAttributes {
        uint256 gotchiIndex;
        string imageURI;
        uint256 happiness;
        uint256 hunger;
        uint256 enrichment;
        uint256 lastChecked;
    }
    using Counters for Counters.Counter;

    string[] cat = [
        "bafkreie5h6cnacxjbjcg7r6u2rcp7k6tkoyfll2vxvgiseeuqurn34e3ma", // love
        "bafkreib5rtfcqfdhpffpxyvego5v2f3ikpom2had4qupxj2yfl5pbgedoq", // normal
        "bafkreia23ppmsi5i37gqut2ueygel224zkp2ekeleqnr4frxuppjgk4hwe", // hungry
        "bafkreickkav67nt2g6xqbhnjcn5mwqy2jkn3pl43fbpbepy3tbe3u5hitm", //angry
        "bafkreiennobi5aopsrhnh42orxquwa3mess26wmomlehet6idgbu6rse3a" // sad
    ];

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => CatAttributes) public catOwnerAttributes;

    mapping(address => uint256) public catHolders;

    uint256 interval = 60;

    constructor() ERC721("ArbiCat", "Arbitrum's First Pet Cat") {}

    function safeMint(address to) public {
        require(catHolders[address(msg.sender)] == 0, "1 cat at a time");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        string memory finalPng = cat[0];
        catOwnerAttributes[tokenId] = CatAttributes({
            gotchiIndex: tokenId,
            imageURI: finalPng,
            happiness: 100,
            hunger: 100,
            enrichment: 100,
            lastChecked: block.timestamp
        });
        catHolders[msg.sender] = tokenId;
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function gotchiStats(uint256 _tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return (
            catOwnerAttributes[_tokenId].happiness,
            catOwnerAttributes[_tokenId].hunger,
            catOwnerAttributes[_tokenId].enrichment,
            catOwnerAttributes[_tokenId].lastChecked,
            catOwnerAttributes[_tokenId].imageURI
        );
    }

    function myGotchi()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return gotchiStats(catHolders[msg.sender]);
    }

    function passTime(uint256 _tokenId) public {
        catOwnerAttributes[_tokenId].hunger =
            catOwnerAttributes[_tokenId].hunger -
            10;
        catOwnerAttributes[_tokenId].enrichment =
            catOwnerAttributes[_tokenId].enrichment -
            10;
        catOwnerAttributes[_tokenId].happiness =
            (catOwnerAttributes[_tokenId].hunger +
                catOwnerAttributes[_tokenId].enrichment) /
            2;
        updateURI(_tokenId);
        emitUpdate(_tokenId);
    }

    function emitUpdate(uint256 _tokenId) internal {
        emit CatUpdated(
            catOwnerAttributes[_tokenId].happiness,
            catOwnerAttributes[_tokenId].hunger,
            catOwnerAttributes[_tokenId].enrichment,
            catOwnerAttributes[_tokenId].lastChecked,
            catOwnerAttributes[_tokenId].imageURI,
            _tokenId
        );
    }

    function feed() public {
        uint256 _tokenId = catHolders[msg.sender];
        catOwnerAttributes[_tokenId].hunger = 100;
        catOwnerAttributes[_tokenId].happiness =
            (catOwnerAttributes[_tokenId].hunger +
                catOwnerAttributes[_tokenId].enrichment) /
            2;
        updateURI(_tokenId);
        emitUpdate(_tokenId);
    }

    function play() public {
        uint256 _tokenId = catHolders[msg.sender];
        catOwnerAttributes[_tokenId].enrichment = 100;
        catOwnerAttributes[_tokenId].happiness =
            (catOwnerAttributes[_tokenId].hunger +
                catOwnerAttributes[_tokenId].enrichment) /
            2;
        updateURI(_tokenId);
        emitUpdate(_tokenId);
    }

    function updateURI(uint256 _tokenId) private {
        string memory base = cat[0];
        if (catOwnerAttributes[_tokenId].happiness == 100) {
            base = cat[0];
        } else if (catOwnerAttributes[_tokenId].happiness > 66) {
            base = cat[1];
        } else if (catOwnerAttributes[_tokenId].happiness > 33) {
            base = cat[2];
        } else if (catOwnerAttributes[_tokenId].happiness > 0) {
            base = cat[3];
        } else if (catOwnerAttributes[_tokenId].happiness == 0) {
            base = cat[4];
        }
        string memory finalSVG = base;
        catOwnerAttributes[_tokenId].imageURI = finalSVG;
        _setTokenURI(_tokenId, tokenURI(_tokenId));
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        CatAttributes memory gotchiAttributes = catOwnerAttributes[
            _tokenId
        ];

        string memory strHappiness = Strings.toString(
            gotchiAttributes.happiness
        );
        string memory strHunger = Strings.toString(gotchiAttributes.hunger);
        string memory strEnrichment = Strings.toString(
            gotchiAttributes.enrichment
        );

        string memory json = string(
            abi.encodePacked(
                '{"name": "Your Little Cat Friend",',
                '"description": "Keep your pet happy!",',
                '"image": "',
                gotchiAttributes.imageURI,
                '",',
                '"traits": [',
                '{"trait_type": "Hunger","value": ',
                strHunger,
                '}, {"trait_type": "Enrichment", "value": ',
                strEnrichment,
                '}, {"trait_type": "Happiness","value": ',
                strHappiness,
                "}]",
                "}"
            )
        );

        string memory output = string(abi.encodePacked(json));
        return output;
    }

    function checkUpkeep()
        external
        view
        returns (
            bool upkeepNeeded        )
    {
        uint256 lastTimeStamp = catOwnerAttributes[0].lastChecked;
        upkeepNeeded = (catOwnerAttributes[0].happiness > 0 &&
            (block.timestamp - lastTimeStamp) > 60);
    }

    function performUpkeep() external {
        uint256 lastTimeStamp = catOwnerAttributes[0].lastChecked;
        if (
            catOwnerAttributes[0].happiness > 0 &&
            ((block.timestamp - lastTimeStamp) > interval)
        ) {
            catOwnerAttributes[0].lastChecked = block.timestamp;
            passTime(0);
        }
        
    }
}

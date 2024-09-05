// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { UtilsScript } from "./Utils.s.sol";
import { Script, console } from "forge-std/src/Script.sol";
import { Merkle } from "murky/Merkle.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { TrailblazersBadges } from "../../../contracts/trailblazers-badges/TrailblazersBadges.sol";
import { IMinimalBlacklist } from "@taiko/blacklist/IMinimalBlacklist.sol";
import { TrailblazersBadges } from "../../../contracts/trailblazers-badges/TrailblazersBadges.sol";
import { TrailblazersBadgesS2 } from
    "../../../contracts/trailblazers-badges/TrailblazersBadgesS2.sol";
import { BadgeChampions } from "../../../contracts/trailblazers-badges/BadgeChampions.sol";

contract DeployScript is Script {
    UtilsScript public utils;
    uint256 public deployerPrivateKey;
    address public deployerAddress;

    TrailblazersBadges public trailblazersBadges;
    TrailblazersBadgesS2 public trailblazersBadgesS2;
    BadgeChampions public badgeChampions;

    // Hekla
    address constant S1_ADDRESS = 0x251a530c6C4Cb0839496ca38613F1e33a8AA2984;
    address constant S2_ADDRESS = 0xcc75A678b91076f8840a0BD4b269c8D6e0Ab2c26;
    address constant CHAMPIONS_ADDRESS = 0xc8fFF08D23C1176061a261CC5DB57c3B1CE43C04;

    address[] public participants = [
        // @bearni - taiko:hekla
        0x4100a9B680B1Be1F10Cb8b5a57fE59eA77A8184e,
        address(0x1),
        address(0x2),
        address(0x3),
        address(0x4),
        address(0x5),
        address(0x6),
        address(0x7),
        address(0x8),
        address(0x9),
        address(0x10)
    ];

    function setUp() public {
        utils = new UtilsScript();
        utils.setUp();

        deployerPrivateKey = utils.getPrivateKey();
        deployerAddress = utils.getAddress();

        trailblazersBadges = TrailblazersBadges(S1_ADDRESS);
        trailblazersBadgesS2 = TrailblazersBadgesS2(S2_ADDRESS);
        badgeChampions = BadgeChampions(CHAMPIONS_ADDRESS);
    }

    function createFreshTournament() public {
        vm.startBroadcast(deployerPrivateKey);

        uint256 OPEN_TIME = block.timestamp - 3 minutes;
        uint256 CLOSE_TIME = block.timestamp - 2 minutes;
        uint256 START_TIME = block.timestamp -1 minutes;


        badgeChampions.createLeague(
            OPEN_TIME, CLOSE_TIME, START_TIME);


        for (uint256 i = 0; i < participants.length; i++) {
            uint256 badgeId = i % 7;
            trailblazersBadges.mintTo(participants[i], badgeId);
            badgeChampions.registerChampionFor(
                participants[i],
                address(trailblazersBadges),
               badgeId
            );
        }

        vm.stopBroadcast();

    }



    function run() public {


      createFreshTournament();


        // close signups and start the tournament
        vm.startBroadcast(deployerPrivateKey);

        uint256 TOURNAMENT_SEED = block.number * 123456789;
        badgeChampions.startLeague(TOURNAMENT_SEED);
        vm.stopBroadcast();

    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../../../verifiers/SgxVerifier.sol";
import "../../addrcache/RollupAddressCache.sol";
import "../../reentrylock/FasterReentryLock.sol";

/// @title MainnetSgxVerifier
/// @dev This contract shall be deployed to replace its parent contract on Ethereum for Taiko
/// mainnet to reduce gas cost.
/// @notice See the documentation in {SgxVerifier}.
/// @custom:security-contact security@taiko.xyz
contract MainnetSgxVerifier is SgxVerifier, RollupAddressCache, FasterReentryLock {
    function _getAddress(uint64 _chainId, bytes32 _name) internal view override returns (address) {
        return getAddress(_chainId, _name, super._getAddress);
    }

    function _storeReentryLock(uint8 _reentry) internal override {
        storeReentryLock(_reentry);
    }

    function _loadReentryLock() internal view override returns (uint8) {
        return loadReentryLock();
    }

    function taikoChainId() internal pure override returns (uint64) {
        return LibNetwork.TAIKO_MAINNET;
    }
}
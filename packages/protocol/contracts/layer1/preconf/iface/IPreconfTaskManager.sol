// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "src/layer1/based/TaikoData.sol";
import "./ILookahead.sol";
import "./IPreconfViolationVerifier.sol";

/// @title IPreconfTaskManager
/// @custom:security-contact security@taiko.xyz
interface IPreconfTaskManager {
    /// @notice Proposes a Taiko L2 block (version 2)
    /// @param _lookaheadPointer pointer to the lookahead
    /// @param _lookaheadParams parameters to set lookahead
    /// @param _params Block parameters, an encoded BlockParamsV2 object.
    /// @param _txList txList data if calldata is used for DA.
    /// @return meta_ The metadata of the proposed L2 block.
    function proposeBlock(
        uint256 _lookaheadPointer,
        ILookahead.EntryParam[] calldata _lookaheadParams,
        bytes calldata _params,
        bytes calldata _txList
    )
        external
        returns (TaikoData.BlockMetadataV2 memory);

    /// @notice Proposes multiple Taiko L2 blocks (version 2)
    /// @param _lookaheadPointer pointer to the lookahead
    /// @param _lookaheadParams parameters to set lookahead
    /// @param _paramsArr A list of encoded BlockParamsV2 objects.
    /// @param _txListArr A list of txList.
    /// @return metaArr_ The metadata objects of the proposed L2 blocks.
    function proposeBlocks(
        uint256 _lookaheadPointer,
        ILookahead.EntryParam[] calldata _lookaheadParams,
        bytes[] calldata _paramsArr,
        bytes[] calldata _txListArr
    )
        external
        returns (TaikoData.BlockMetadataV2[] memory);

    /// @notice Proves a receipt violation
    /// @param _receipt The receipt to be proved
    /// @param _proof The proof data for the receipt
    function verifyPreconfViolation(
        bytes calldata _receipt,
        bytes calldata _proof
    )
        external;
}

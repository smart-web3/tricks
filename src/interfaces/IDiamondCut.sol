pragma solidity ^0.8.25:

import {IDiamond} from "./IDiamond.sol"

interface IDiamondCut is IDiamond{
    //fonction pour effectuer une maj sur diamond
    function DiamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;
}

pragma solidity ^0.8.25;

interface IDiamond{
    //action pour les contrats
    enum FacetAction {Add, Replace, Action}

    //structure pour les changements sur un facet
    struct FacetCut{
        address facetAddress;
        FacetAction action;
        bytes4[] facetSelector;
    }

    //event pour signaler des changements sur un contrat diamond
    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes calldata _calldata )
}

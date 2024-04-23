pragma solidity ^0.8.25;

interface IDiamondLoup{
    //facet presentant les infos sur les facets
    struct Facet{
        address facetAddress
        bytes4[] facetSelector
    }

    //fonction pour presenter les adresses de tous les facets
    function facets() external view returns(Facet[] memory facetAddress_)

    //fonction pour presenter les selector selon l'adresse d'un contrat
    function facetSelector(address _facet) external view returns(bytes4[] memory facetSeletor_) 

    //fonction pour presenter toutes les adresses d'une facet 
    function facetAddresses() external view returns(address[] memory facetAddresses_)

    //function pour presenter l'adresse d'une facet en fonction 
    //d'un selector
    function facetAddress(bytes4 _facetSelector) external view returns(address facetAddress_)
}

#[starknet::contract]
mod OM721Token {
    use openzeppelin::introspection::src5::SRC5Component;
    use openzeppelin::token::erc721::ERC721Component;
    use starknet::{
        contract_address_const, get_caller_address, get_contract_address, get_tx_info,
        ContractAddress
    };
    use contracts::Interface::IOM721Token;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnly = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataCamelOnly =
        ERC721Component::ERC721MetadataCamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = "OpenMarkNFT";
        let symbol = "OM";
        let base_uri = "https://api.example.com/v1/";
        self.erc721.initializer(name, symbol, base_uri);
    }

    #[abi(embed_v0)]
    impl OM721TokenImpl of IOM721Token<ContractState> {
        fn safe_mint(ref self: ContractState, to: ContractAddress, quantity: u256) {
            let mut token_id = 0;

            while token_id < quantity {
                self.erc721._mint(to, token_id);
                token_id += 1;
            };
        }
    }
}


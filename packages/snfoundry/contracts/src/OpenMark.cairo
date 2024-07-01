#[starknet::contract]
mod OpenMark {
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use openzeppelin::token::erc721::interface::{IERC721};
    use openzeppelin::account::utils::{is_valid_stark_signature};
    use starknet::{
        contract_address_const, get_caller_address, get_contract_address, get_tx_info,
        ContractAddress
    };
    use core::pedersen::PedersenTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::ecdsa::check_ecdsa_signature;

    use contracts::Primitives::{
        Order, ORDER_STRUCT_TYPE_HASH, ETH_CONTRACT_ADDRESS, StarknetDomain, IStructHash
    };
    use contracts::Interface::{IOpenMark, IOffchainMessageHash};

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }


    #[storage]
    struct Storage {
        eth_token: IERC20CamelDispatcher,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        usedOrderSignatures: LegacyMap<felt252, bool>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
        self.eth_token.write(IERC20CamelDispatcher { contract_address: eth_contract_address });

        self.ownable.initializer(owner);
    }


    #[abi(embed_v0)]
    impl OpenMarkImpl of IOpenMark<ContractState> {

        // fn acceptOffer(self: @ContractState) {}

        // fn cancelOrder(self: @ContractState) {}

        fn buy(self: @ContractState, order: Order, signature: Span<felt252>) {
            
        }

        fn verifyOrder(
            self: @ContractState, order: Order, signer: felt252, signature: Span<felt252>
        ) -> bool {
            let hash = self.get_message_hash(order, signer);

            is_valid_stark_signature(hash, signer, signature)
        }
    }

    #[abi(embed_v0)]
    impl OffchainMessageHashImpl of IOffchainMessageHash<ContractState> {
        fn get_message_hash(self: @ContractState, order: Order, signer: felt252) -> felt252 {
            let domain = StarknetDomain {
                name: 'OpenMark', version: 1, chain_id: get_tx_info().unbox().chain_id
            };
            let mut state = PedersenTrait::new(0);
            state = state.update_with('StarkNet Message');
            state = state.update_with(domain.hash_struct());
            // state = state.update_with(get_caller_address());
            state = state.update_with(signer);
            state = state.update_with(order.hash_struct());
            // Hashing with the amount of elements being hashed 
            state = state.update_with(4);
            state.finalize()
        }
    }
}

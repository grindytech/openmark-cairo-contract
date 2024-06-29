use starknet::ContractAddress;
use contracts::Primitives::Order;

#[starknet::interface]
pub trait IOpenMark<TState> {
    // fn buy(self: @TState);
    // fn acceptOffer(self: @TState);
    // fn cancelOrder(self: @TState);

    fn verifyOrder(self: @TState, order: Order, signature: ByteArray) -> ContractAddress;
}


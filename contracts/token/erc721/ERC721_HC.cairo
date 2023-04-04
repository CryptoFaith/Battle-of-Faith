// SPDX-License-Identifier: Apache 2.0
// Immutable Cairo Contracts v0.3.0 (token/erc721/presets/ERC721_Full.cairo)

// ERC721_Full.cairo has behaviour:
// - ERC721, TokenMetadata, ContractMetadata, AccessControl, Royalty, Bridgeable

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
)
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.access.accesscontrol.library import AccessControl
from openzeppelin.token.erc20.IERC20 import IERC20

from immutablex.starknet.token.erc721.library import ERC721
from immutablex.starknet.token.erc721_token_metadata.library import ERC721_Token_Metadata
from immutablex.starknet.token.erc721_contract_metadata.library import ERC721_Contract_Metadata
from immutablex.starknet.auxiliary.erc2981.unidirectional_mutable import (
    ERC2981_UniDirectional_Mutable,
)

//
// Constants
//
const MINTER_ROLE = 'MINTER_ROLE';
const DEFAULT_ADMIN_ROLE = 0x00;

//
// Storage vars
//

@storage_var
func next_token_id_storage() -> (next_token_id: Uint256) {
}

@storage_var
func max_mint_token_num_storage() -> (max_mint_token_num: Uint256) {
}


@storage_var
func mint_fee_storage() -> (mint_fee: Uint256) {
}


@storage_var
func fee_token_storage() -> (fee_token: felt) {
}


@storage_var
func fee_recipient_storage() -> (fee_token: felt) {
}

@storage_var
func max_mint_pre_address_storage() -> (max_mint_pre_address: Uint256) {
}


//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt,
    symbol: felt,
    owner: felt,
    default_royalty_receiver: felt,
    default_royalty_fee_basis_points: felt,
    fee_token: felt,
    fee_recipient: felt,
    max_mint_token_num: Uint256,
    mint_fee: Uint256,
    max_mint_pre_address: Uint256,
) {
    ERC721.initializer(name, symbol);
    ERC721_Token_Metadata.initializer();
    ERC2981_UniDirectional_Mutable.initializer(
        default_royalty_receiver, default_royalty_fee_basis_points
    );
    AccessControl.initializer();
    AccessControl._grant_role(DEFAULT_ADMIN_ROLE, owner);
    max_mint_token_num_storage.write(max_mint_token_num);
    let one_as_uint = Uint256(1, 0);
    next_token_id_storage.write(one_as_uint);
    mint_fee_storage.write(mint_fee);
    fee_token_storage.write(fee_token);
    fee_recipient_storage.write(fee_recipient);
    max_mint_pre_address_storage.write(max_mint_pre_address);
    return ();
}

//
// Getters
//

@view
func max_mint_token_num{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_mint_token_num: Uint256
) {
    let (max_mint_token_num) = max_mint_token_num_storage.read();
    return (max_mint_token_num=max_mint_token_num);
}


@view
func mint_fee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
 mint_fee: Uint256) {
    let (mint_fee) = mint_fee_storage.read();
    return (mint_fee=mint_fee);
}

@view
func next_token_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    next_token_id: Uint256
) {
    let (next_token_id) = next_token_id_storage.read();
    return (next_token_id=next_token_id);
}

@view
func fee_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    fee_token: felt
) {
    let (fee_token) = fee_token_storage.read();
    return (fee_token=fee_token);
}

@view
func fee_recipient{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    fee_recipient: felt
) {
    let (fee_recipient) = fee_recipient_storage.read();
    return (fee_recipient=fee_recipient);
}


@view
func max_mint_pre_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_mint_pre_address: Uint256
) {
    let (max_mint_pre_address) = max_mint_pre_address_storage.read();
    return (max_mint_pre_address=max_mint_pre_address);
}
//
// View (ERC165)
//

@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    let (success) = ERC165.supports_interface(interfaceId);
    return (success,);
}

//
// View (ERC721)
//

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    let (name) = ERC721.name();
    return (name,);
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    let (symbol) = ERC721.symbol();
    return (symbol,);
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    let (balance: Uint256) = ERC721.balance_of(owner);
    return (balance,);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    let (owner: felt) = ERC721.owner_of(tokenId);
    return (owner,);
}

@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    let (approved: felt) = ERC721.get_approved(tokenId);
    return (approved,);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved,);
}

//
// View (contract metadata)
//

@view
func contractURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    contract_uri_len: felt, contract_uri: felt*
) {
    let (contract_uri_len, contract_uri) = ERC721_Contract_Metadata.contract_uri();
    return (contract_uri_len, contract_uri);
}

//
// View (token metadata)
//

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (tokenURI_len: felt, tokenURI: felt*) {
    let (tokenURI_len, tokenURI) = ERC721_Token_Metadata.token_uri(tokenId);
    return (tokenURI_len, tokenURI);
}

//
// View (royalties)
//

@view
func royaltyInfo{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, salePrice: Uint256
) -> (receiver: felt, royaltyAmount: Uint256) {
    let (exists) = ERC721._exists(tokenId);
    with_attr error_message("ERC721: token ID does not exist") {
        assert exists = TRUE;
    }
    let (receiver: felt, royaltyAmount: Uint256) = ERC2981_UniDirectional_Mutable.royalty_info(
        tokenId, salePrice
    );
    return (receiver, royaltyAmount);
}

// This function should not be used to calculate the royalty amount and simply exposes royalty info for display purposes.
// Use royaltyInfo to calculate royalty fee amounts for orders as per EIP2981.
@view
func getDefaultRoyalty{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
    receiver: felt, feeBasisPoints: felt
) {
    let (receiver, fee_basis_points) = ERC2981_UniDirectional_Mutable.get_default_royalty();
    return (receiver, fee_basis_points);
}

//
// View (access control)
//

@view
func hasRole{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, account: felt
) -> (res: felt) {
    let (res) = AccessControl.has_role(role, account);
    return (res,);
}

@view
func getRoleAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(role: felt) -> (
    role_admin: felt
) {
    let (role_admin) = AccessControl.get_role_admin(role);
    return (role_admin,);
}

//
// Externals (ERC721)
//

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    ERC721.approve(to, tokenId);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    ERC721.transfer_from(from_, to, tokenId);
    return ();
}

@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

//
// External (token metadata)
//

@external
func setBaseURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    base_token_uri_len: felt, base_token_uri: felt*
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC721_Token_Metadata.set_base_token_uri(base_token_uri_len, base_token_uri);
    return ();
}

@external
func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256, tokenURI_len: felt, tokenURI: felt*
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC721_Token_Metadata.set_token_uri(tokenId, tokenURI_len, tokenURI);
    return ();
}

@external
func resetTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC721_Token_Metadata.reset_token_uri(tokenId);
    return ();
}

//
// External (contract metadata)
//

@external
func setContractURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    contract_uri_len: felt, contract_uri: felt*
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC721_Contract_Metadata.set_contract_uri(contract_uri_len, contract_uri);
    return ();
}

//
// External (royalties)
//

@external
func setDefaultRoyalty{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    receiver: felt, feeBasisPoints: felt
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC2981_UniDirectional_Mutable.set_default_royalty(receiver, feeBasisPoints);
    return ();
}

@external
func setTokenRoyalty{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256, receiver: felt, feeBasisPoints: felt
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    let (exists) = ERC721._exists(tokenId);
    with_attr error_message("ERC721: token ID does not exist") {
        assert exists = TRUE;
    }
    ERC2981_UniDirectional_Mutable.set_token_royalty(tokenId, receiver, feeBasisPoints);
    return ();
}

@external
func resetDefaultRoyalty{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    ERC2981_UniDirectional_Mutable.reset_default_royalty();
    return ();
}

@external
func resetTokenRoyalty{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    let (exists) = ERC721._exists(tokenId);
    with_attr error_message("ERC721: token ID does not exist") {
        assert exists = TRUE;
    }
    ERC2981_UniDirectional_Mutable.reset_token_royalty(tokenId);
    return ();
}

//
// External (mint)
//

@external
func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
    let one_as_uint = Uint256(1, 0);
    let (caller_address) = get_caller_address();
    let (balance: Uint256) = ERC721.balance_of(caller_address);
    let (max_mint_pre_address) = max_mint_pre_address_storage.read();
    let (next_mint_num,_) = uint256_add(max_mint_pre_address,one_as_uint);
    let (is_minted_le) = uint256_le(balance, next_mint_num);
    with_attr error_message("ERC721: mint was exceeded per address.") { 
        assert is_minted_le = TRUE;
    }

    let (token_id) = next_token_id_storage.read();
    
    let (max_mint_token_num) = max_mint_token_num_storage.read();

    let (is_le) = uint256_le(token_id, max_mint_token_num);
    with_attr error_message("ERC721: mint was exceeded.") {
        assert is_le = TRUE;
    }

    let (next_token_id, _) = uint256_add(one_as_uint, token_id);
    let (mint_fee) = mint_fee_storage.read();
    let (fee_token_address) = fee_token_storage.read();
    let (fee_recipient) = fee_recipient_storage.read();

    IERC20.transferFrom(
        contract_address=fee_token_address,
        sender=caller_address,
        recipient=fee_recipient,
        amount=mint_fee,
    );


    next_token_id_storage.write(next_token_id);
    ERC721._mint(caller_address, token_id);
    return ();
}

@external
func mint_without_fee{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}( to: felt) {
    AccessControl.assert_only_role(MINTER_ROLE);
    let one_as_uint = Uint256(1, 0);
    let (token_id) = next_token_id_storage.read();
    
    let (max_mint_token_num) = max_mint_token_num_storage.read();

    let (is_le) = uint256_le(token_id, max_mint_token_num);
    with_attr error_message("ERC721: mint was exceeded.") {
        assert is_le = TRUE;
    }

    let (next_token_id, _) = uint256_add(one_as_uint, token_id);

    next_token_id_storage.write(next_token_id);
    ERC721._mint(to, token_id);
    return ();
}


//
// External (access control)
//

@external
func grantRole{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, account: felt
) {
    AccessControl.grant_role(role, account);
    return ();
}

@external
func revokeRole{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, account: felt
) {
    AccessControl.revoke_role(role, account);
    return ();
}

@external
func renounceRole{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, account: felt
) {
    AccessControl.renounce_role(role, account);
    return ();
}


@external
func setMintFee{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    mint_fee: Uint256
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    mint_fee_storage.write(mint_fee);
    return ();
}

@external
func setFeeToken{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    fee_token: felt
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    fee_token_storage.write(fee_token);
    return ();
}


@external
func setFeeRecipient{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    fee_recipient: felt
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    fee_recipient_storage.write(fee_recipient);
    return ();
}

@external
func setMaxMintPreAddress {pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    max_mint_pre_address: Uint256
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    max_mint_pre_address_storage.write(max_mint_pre_address);
    return ();
}

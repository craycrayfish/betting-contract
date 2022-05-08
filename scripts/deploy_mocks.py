from webbrowser import get
from brownie import (
    accounts,
    network,
    config,
    MockOracle,
    LinkToken,
    Contract,
    interface,
)
from scripts.utils import get_account


def deploy_mocks():
    account = get_account()
    MockOracle.deploy({"from": account})
    link_token = LinkToken.deploy({"from": account})


def fund_with_link(
    contract_address, account=None, link_token=None, amount=100000000000000000
):  # 0.1 LINK
    account = account if account else get_account()
    link_token = link_token if link_token else get_contract("link_token")
    tx = link_token.transfer(contract_address, amount, {"from": account})
    # link_token_contract = interface.LinkTokenInterface(link_token.address)
    # tx = link_token_contract.transfer(contract_address, amount, {"from": account})
    tx.wait(1)
    print("Fund contract!")
    return tx
    
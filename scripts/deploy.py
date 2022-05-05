from scripts.utils import get_account
from brownie import Bookie, network, config
from web3 import Web3


def deploy_bookie():
    account = get_account()
    bookie = Bookie.deploy({"from": account})
    print("Deployed Bookie!")
    return bookie


def start_betting(tx_params=None):
    account = get_account()
    bookie = Bookie[-1]
    tx_params = tx_params or {"from": account}
    start_tx = bookie.start_betting(tx_params)
    print("Betting started")


def add_outcome(tx_params=None):
    account = get_account()
    bookie = Bookie[-1]
    tx_params = tx_params or {"from": account}
    bookie.add_outcome(tx_params)


def place_bet(bet_size=1, tx_params=None):
    account = get_account()
    bookie = Bookie[-1]
    tx_params = tx_params or {"from": account, "value": Web3.toWei(0.1, "ether")}
    tx = bookie.place_bet(bet_size, tx_params)

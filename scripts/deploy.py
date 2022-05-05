from scripts.utils import get_account
from brownie import Bookie, network, config


def deploy_bookie():
    account = get_account()
    bookie = Bookie.deploy()
    print("Deployed Bookie!")
    return bookie


def start_betting():
    account = get_account()
    bookie = Bookie[-1]
    start_tx = bookie.start

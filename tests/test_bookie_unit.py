from scripts.helpful_scripts import (
    get_account,
)
from brownie import exceptions
from web3 import Web3
import pytest


def test_deploy_contract():
    """Ensure contract can be deployed"""
    pass


def test_create_outcome_and_place_bet(check_local_blockchain_envs, bookie_contract):
    """Ensure outcomes can be created"""
    account = get_account()
    bet_outcome = 1
    bet_value = 2
    bookie_contract.start_betting({"from": account})
    bookie_contract.add_outcome({"from": account})
    bookie_contract.place_bet(bet_outcome, {"from": account, "value": bet_value})
    assert bookie_contract.get_bets(account) == ((bet_outcome,), (bet_value,))


def test_start_end_bet():
    """Ensure startBet and endBet functions work"""
    pass


def test_claim_payout():
    """Ensure winners can claim their payout"""
    pass

from brownie import network
from scripts.deploy import deploy_bookie
import pytest

from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS


@pytest.fixture()
def check_local_blockchain_envs():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()


@pytest.fixture()
def bookie_contract():
    return deploy_bookie()

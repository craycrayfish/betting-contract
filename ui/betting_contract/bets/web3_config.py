import json
from web3 import Web3

deployed_contract_addresses = {
    "Bookie": "0xbAbF2f7A36556854A1212C13f6d2aba0cb36f0A5"
}


def get_web3(api_key):
    _web3 = Web3(Web3.HTTPProvider(api_key))
    return _web3


def get_contract(contract_name: str, _web3: Web3):
    with open("../../contracts/artifacts/Bookie.json") as f:
        abi = json.load(f)["abi"]
        return _web3.eth.contract(address=deployed_contract_addresses[contract_name], abi=abi)


def get_state(contract):
    return contract.functions.state().call()



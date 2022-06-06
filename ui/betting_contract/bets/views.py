from django.http import HttpResponse
from django.shortcuts import render
from .web3_config import *

API_KEY = "https://rinkeby.infura.io/v3/5965b73e57584acfafbd61b3b3517c44"


state_map = {
    0: "CLOSED",
    1: "PRE-GAME",
    2: "MID_GAME",
    3: "POST_GAME"
}


def get_bookie_contract():
    w3 = get_web3(API_KEY)
    bookie_contract = get_contract("Bookie", w3)
    return bookie_contract


def base(request):
    state = get_state(get_bookie_contract())
    return HttpResponse(f"Hello, world. You're at the bets index. The current game state is: {state}")


def index(request):
    state = get_state(get_bookie_contract())

    context = {"state": state_map[state]}
    return render(request, "index.html", context)

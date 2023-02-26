from brownie import WagerItFactory, accounts, network, config
from scripts.helpful_scripts import fund_with_link, get_publish_source

def main():
    dev = accounts.add(config['wallets']['from_key']) # Gets dev account
    print(network.show_active())
    publish_source = False; # Publich or not on etherscan
    fwi = WagerItFactory.deploy(
        {"from": dev},
        publish_source=get_publish_source(),
    ) # Deploys contract
    return fwi # Returns the contract

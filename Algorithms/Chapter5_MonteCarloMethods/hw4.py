import numpy as np 
import matplotlib.pyplot as plt 
import random


##########################################################
# ------------------- Black-Jack Game ------------------ #
##########################################################

# STATES: (Sum of Player Card, Dealer Showing Card, Player Useable ACE) 
# ACTIONS: (Player HIT, Player STICK)
# DEALER ACTIONs: Dealer Must HIT until dealer value >= 17 
    # 1) Dealer HITS if dealer value == 17 
    # 2) Dealer STICKS if deal value == 17 
    
# REWARDS: 
# Rewards are given at the end of each episodes (aka game) 
# IF Player... 
    # 1) Win: R = +1
    # 2) Loss: R = -1
    # 3) Draw: R = 0 

# DEFINITION: Useable ACE - IF an ACE can be valued as an 11 (instead of 1) withOUT going bust ELSE: ACE is unuseable 

# EXPLORING STARTS: 
# Randomly initialize games with Uniformly Random STATES and continue playing until terminal state is achieved (aka game results in a win, loss, or draw)

# INITIAL POLICY:
#  PI(s) = IF Player_State >= 20 && < =21: STICK ELSE: HIT 

# HOW GAME IS WON: 
    # 1) Win: Player is closer/equal to 21 (without going over) than dealer 
    # 2) Loss: Dealer is closer/equal to 21 (wihtout going over) than player 
    # 3) Draw: Player & Dealer Have SAME value OR both have 21 



card_values = {"A": (1,11), "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 10, "Q": 10, "K": 10 }
card_values = {1: (1,11), 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 10, 12: 10, 13: 10 }


def create_deck(): 

    card_values = {1: (1,11), 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 10, 12: 10, 13: 10 }
    card_in_suit =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12, 13]

    deck = [] 

    for i in range(1,5): 
        for j in range(len(card_in_suit)): 

            deck.append(card_in_suit[j])

    shuffled_deck = random.sample(deck, len(deck))

    return shuffled_deck

def generate_blackjack_episode(policy, dealer_policy): 


    # Create Random Deck of Cards
    card_deck = create_deck() 

    # Empty Trajectory List will store Tuples (S, A, R, S') Until Terminal State is acheived
    trajectory = [] 

    # Initialize States Randomly (Exploring Starts)
    init_state = (random.randint(0,21), random.randint(1,10), random.randint(0,1))


    done = False                                # Set DONE Flag for End of Episode 

    while done is not True:                     # While EPISODE is not DONE Loop until terminal state is achieved


    















if __name__ == '__main__':


    create_deck()




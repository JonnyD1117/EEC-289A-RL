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



# card_values = {"A": (1,11), "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 10, "Q": 10, "K": 10 }
card_values = {1: (1,11), 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 10, 12: 10, 13: 10 }


policy_dict = ["hit": 0, "stick": 1]

def dealer_action(dealer_faceup_card, deck_of_cards, card_cnt, dealer_policy==1):
    """
    Dealer Must follow fixed policy about the game. 

    Policy -> If the dealer has < 17 the dealer MUST hit

    Depending on the establishment, the dealer might also be required to HIT if value is equal to 17, while in other cases the dealer must stick if the value equals 17 

    Case #1: Dealer HITS on 17 
    Case #2: Dealer STICKS on 17 
    """

    new_dealer_state = dealer_faceup_card               # Initialize new state of the dealer to the current state (will be updated depending on action taken)

    if dealer_policy == 1:                              # HIT on 17 
        
        new_dealer_state += deck_of_cards[card_cnt]
        card_cnt += 1

        return new_dealer_state, card_cnt

    elif dealer_policy ==2:                             # STICK on 17 

        return new_dealer_state, card_cnt

    else: 

        # DO NOTHING

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
    episode_trajectory = [] 

    # Initialize States Randomly (Exploring Starts)
    init_state = (random.randint(0,21), random.randint(1,10), random.randint(0,1))

    state = init_state

    done = False                                # Set DONE Flag for End of Episode 

    while done is not True:                     # While EPISODE is not DONE Loop until terminal state is achieved
        
        card_counter = 0 


        player_state = state[0]
        dealer_state = state[1]
        player_useable_ace = state[2]


        player_action = policy[state]

        
        if player_action == 0:                                      # Player HITS

            player_state += card_deck[card_counter]
            card_counter +=1 

            dealer_state, card_counter = dealer_action(dealer_state, card_deck, card_counter, dealer_policy)

        elif player_action == 1:                                    # Player STICKS

            dealer_state, card_counter = dealer_action(dealer_state, card_deck, card_counter, dealer_policy)




        if player_state == 21 and dealer_state == 21:               # DRAW 

        elif player_state == 21 and dealer_state != 21:             # WIN

        elif player_state > 21                                      # BUST

        elif player_state == dealer_state:                          # DRAW

        elif player_state > dealer_state:                           # WIN 

        else: 












        else:
            # DO NOTHING Dealer Policy is Undefined




    















if __name__ == '__main__':


    create_deck()




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

def dealer_action(state, deck_of_cards, card_cnt, dealer_policy=1):
    """
    Dealer Must follow fixed policy about the game. 

    Policy -> If the dealer has < 17 the dealer MUST hit

    Depending on the establishment, the dealer might also be required to HIT if value is equal to 17, while in other cases the dealer must stick if the value equals 17 

    Case #1: Dealer HITS on 17 
    Case #2: Dealer STICKS on 17 
    """
    done = False                                    # Initialize DONE flag to False
    dealer_value = state[1]                         # Initialize new state of the dealer to the current state (will be updated depending on action taken)

    while done is not True:                         # While DEALER_VAL <17

        dealer_value += deck_of_cards[card_cnt]     # Dealer Draws a new card and Updates dealer_value
        card_cnt += 1                               # Update the card index 

        if dealer_policy == 1:                      # HIT on 17 
            if dealer_value >17:                    # If dealer_value is >17 set DONE -> True
                done = True                         

        if dealer_policy == 2:                      # STICK on 17 
            if dealer_value =>17:                   # If Dealer_value is => 17 set DONE -> True
                done = True

    return dealer_value, card_cnt


def policy(player_state, dealer_state, useable_ace): 




    return 

def check_ace_useability(current_state, new_card_value): 

    current_value = current_state[0]                # Get Current Player SUM value from the current STATE               

    if new_card_value == 1:                         # Check if new card value is an ACE (default value = 1)

        useable_ace_value = current_value + 11      # IF new card is an ACE, check whether a value of 11 is still value

        if useable_ace_value <= 21:                  # If old player value + 11 is valid (aka <=21) then return True
            return True
        else: 
            return False                            # If the ace is NOT useable return False

    else: 
        return False                                # If new card is NOT an ACE return False

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
    state = (random.randint(0,21), random.randint(1,10), random.randint(0,1))

    done = False                                    # Set DONE Flag for End of Episode 
    card_counter = 0                                # Initialize Counter for which current card to pull from deck                            

    R_intermediate = 0                              # Intermediate Rewards during Game are ZERO
    new_state = state                               # Initialize the New state from the current state

    while done is not True:                         # While Player is still HITTING loop

        player_action = policy(state)               # Sample Players action from the current state of the MDP

        if player_action == 0:                      # Player HITS

            new_state[0] += card_deck[card_counter] # Player Dealt single card (Update Value of Players hand)
            ace_check = check_ace_useability(state, card_deck[card_counter])    # Check if new Card is a useable ACE    
            card_counter += 1                        # Increment the deck counter

            if ace_check is True:                   # If ACE is useable update new state 
                new_state[2] = True                 # Update state[2] tuple value

            else: 
                # New Card is either NOT an ace 
                # OR 
                # Not a useable ACE
                
        elif player_action == 1:                    # Player STICKS
            done = True                             # Change Loop Stopping Condition 

        episode_trajectory.append(state, player_action, R_intermediate, new_state)
        state = new_state                           # Update the current state to the new state

    dealer_val, card_counter = dealer_action(state, card_deck, card_counter, dealer_policy)

    if state[0] > 21 or state[0] < dealer_val: 

        R_game = -1

    if state[0] ==21 and dealer_val != 21: 

        R_game = 1

    if state[0] ==dealer_val: 

        R_game = 0 

    episode_trajectory.append(state, 1, R_game, state)












if __name__ == '__main__':


    create_deck()




import numpy as np 
import random 

def policy(): 
    return 1

def state_trans_prob(head_probs=.9, tail_probs=.1): 

    sample = random.uniform(0,1)

    if sample >= 0 and sample <= head_probs: 

        action = 0 
        prob = .9
    else: 

        action = 1
        prob .1

    return action, prob

def get_reward(input_state, action, betting_style): 
    # Heads := 0 & Tails := 1 
    if betting_style == 0: # Aggressive Policy (Bet complete value owned)
        if action == 0: 
            reward = input_state

        else:
            reward = -input_state 

    elif betting_style == 1: # Conservative Policy (Bet $1 regardless of value owned)
        if action == 0: 
            reward = 1

        else:
            reward = -1

    elif betting_style == 2: # Random Policy (Select Bet from Uniform Dist. bounded by 0 and value owned)
        
        value = random.randint(1, input_state)
        
        if action == 0: 
            reward = value

        else:
            reward = -value

    return  reward







if __name__ == '__main__': 

    init_state = 5 
    gamma = 1

    V = [init_state]



    while True: 

        pi = policy()
        action, P = state_trans_prob() 
        R = get_reward(input_state=, action, betting_style=0)

        V[] = V[] + pi*P*(R + gamma*V[])





        if state < 0 or state > 10: 
            break 


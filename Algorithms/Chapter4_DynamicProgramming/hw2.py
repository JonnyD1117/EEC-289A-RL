import numpy as np 
import random 

# GAMBLERS Problem: 

# State: Capital (maximmum value = 10)

# Action: Bets/Stakes waged 

# Reward: 0 ~ Lossed or 1 ~ if Won 

num_states = 10


V = np.zeros(num_states)

init_state = 5

num_actions = np.min(num_states, (num_states - init_state))



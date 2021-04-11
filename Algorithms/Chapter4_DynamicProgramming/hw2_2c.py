import numpy as np 
import random 

# GAMBLER'S Problem: 

# State: Capital (maximmum value = 10)

# Action: Bets/Stakes waged 

# Reward: 0 ~ Lossed or 1 ~ if Won 

if __name__ == '__main__': 
    max_num_states = 10
    V = np.zeros(max_num_states + 1)

    init_state = 5
    gamma = 1

    theta = .001
    betting_style = 0
    P_h = .1 
    P_t = .9

    counter = 0
    current_state = None

    while True: 

        delta = 0 
        counter += 1

        for state in range(1, max_num_states): 

            v = 0 
            v_state = V[state]
            current_state = state

            pi = 1.0/state

            for bet in range(1, state+1): 

                win_state = min((state + bet), 10)
                loss_state = max((state - bet), 0)

                R_win = bet
                R_loss = -bet 

                v += pi*P_h*(R_win + gamma*V[win_state]) + pi*P_t*(R_loss + gamma*V[loss_state])

            V[state] = v
            delta = max(delta, np.abs(v_state - V[state]))

        if delta < theta: 
            break 

    print(f"Gambler's Problem: Value Function: - Num Itter {counter}")
    print(V)


            




    






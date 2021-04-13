import numpy as np 
import random 

# GAMBLER'S Problem: 
# State: Capital (maximmum value = 10)
# Action: Bets/Stakes waged 
# Reward: 0 ~ Lossed or 1 ~ if Won 

if __name__ == '__main__': 
    max_num_states = 10
    V = np.zeros((max_num_states))

    theta = .0001

    gamma = 1

    counter = 0

    while True: 

        delta = 0 
        counter += 1

        for state in range(0, max_num_states): 

            if state == 0: 
                P_h = 0 
                P_t = 0
                
            else: 
                P_h = .1 
                P_t = .9

            v = 0 
            v_state = V[state]

            # win_state = min((state + state), 10)
            # loss_state = max((state - state), 0)

            win_state = (state + 1)
            loss_state = (state - 1)

            R_win = 1
            R_loss = -1

            if win_state >=10: 
                win_state =0
                
            if loss_state <=0: 
                loss_state = 0
                

            v_win = P_h*(R_win + gamma*V[win_state])
            v_loss = P_t*(R_loss + gamma*V[loss_state])

            v = v_win + v_loss

            V[state] = v
            delta = max(delta, np.abs(v_state - V[state]))

        if delta < theta: 
            break

    print(f"Gambler's Problem: Value Function: - Num Itter {counter}")
    print("$1 Betting Strategy")
    print(V)


            




    






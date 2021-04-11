import numpy as np 
import random 
import matplotlib.pyplot as plt

# GAMBLER'S Problem: 
if __name__ == '__main__': 
    max_num_states = 100
    V = np.zeros(max_num_states + 1)

    gamma = 1

    theta = .0000001
    P_h = .4 
    P_t = .6

    counter = 0
    current_state = None


    while True: 

        delta = 0 
        counter += 1    

        for state in range(0, max_num_states): 

            v = 0 
            v_state = V[state]

            max_bet_value = 0

            for bet in range(1, (state + 1)): 

                win_state = min((state + bet), 100)
                loss_state = max((state - bet), 0)

                if win_state == 100: 
                    R = 1
                else: 
                    R = 0

                v = P_h*(R + gamma*V[win_state]) + P_t*(R + gamma*V[loss_state])
                
                if v > max_bet_value:

                    max_bet_value = v 
                    V[state] = v                

            
            delta = max(delta, np.abs(v_state - V[state]))
        
        if counter == 1 or counter ==5 or counter == 10 or counter ==14: 
            plt.plot(V[:])

        if delta < theta: 
            break 

    print(f"Gambler's Problem: Value Function: - Num Itter {counter}")
    print("Max Betting Strategy")
    print(V)

    plt.show()
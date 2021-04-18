import numpy as np 
import random 




def policy_evaluation(policy): 


    max_num_states = 10
    V = np.zeros(max_num_states)

    gamma = 1

    theta = .001

    counter = 0

    while True: 

        delta = 0 
        counter += 1

        for state in range(0, max_num_states): 

            if state == 0: 
                P_h = 0 
                P_t = 0
                
            else: 
                P_h = .9 
                P_t = .1

            v = 0 
            v_state = V[state]
            # current_state = state

            pi = 1
            
            bet = policy[state]

            win_state = (state + bet)
            loss_state = (state - bet)

            R_win = bet
            R_loss = -bet 

            if win_state >=10: 
                win_state = 0
            if loss_state <=0: 
                loss_state = 0

            # print(f"Win State {win_state}")
            # print(f"Loss State {loss_state}")

            v_win = pi*P_h*(R_win + gamma*V[win_state])
            v_loss = pi*P_t*(R_loss + gamma*V[loss_state])

            v = v_win + v_loss

            V[state] = v
            delta = max(delta, np.abs(v_state - V[state]))

        if delta < theta: 
            break

    return V

def policy_improvement(init_policy): 

    # Initial Value Func. Approximation (given deterministic Policy)
    value_func = policy_evaluation(init_policy)

    # Initialize policy to the initial policy 
    pi = init_policy

    max_state_num = 10
    old_action = [] 
    new_policy = [] 

    stable_flag, _ = improvement_loop(init_policy, value_func)

    while stable_flag is False: 

        stable_flag, improved_policy = improvement_loop(pi, value_func)
        pi = improved_policy
        value_func = policy_evaluation(pi)

    return pi

def improvement_loop(pi, V_func): 

    P_h = .9 
    P_t = .1
    gamma = 1
    max_state_num = 10

    old_action = np.zeros(max_state_num, dtype=int)
    new_policy = np.zeros(max_state_num, dtype=int)

    stability = True

    for state in range(0, max_state_num): 
        
        old_action[state] = pi[state]
        bet = old_action[state]

        R_win = bet
        R_loss = -bet

        win_state = state + bet
        loss_state = state - bet

        if win_state >=10: 
                win_state = 0
        if loss_state <=0: 
                loss_state = 0

        v_win = P_h*(R_win + gamma*V_func[win_state])
        v_loss = P_t*(R_loss + gamma*V_func[loss_state])

        new_policy[state] = bet

        if old_action[state] != new_policy[state]: 

            stability = False
            break

    return stability, new_policy







if __name__ == '__main__': 


    init_policy = np.ones(10, dtype=int)

    init_policy[1] = int(1)


    # converged_value_func = policy_evaluation(init_policy)

    # print(converged_value_func)

    optimal_policy = policy_improvement(init_policy)
    print(optimal_policy)
    
    






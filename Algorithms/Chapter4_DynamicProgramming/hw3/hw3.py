import numpy as np 
import random 




def policy_evaluation(policy):

    max_num_states = 10
    V = np.zeros(max_num_states)

    gamma = 1
    theta = .0001
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

            pi = 1
            bet = policy[state]

            win_state = (state + bet)
            loss_state = (state - bet)

            R_win = bet
            R_loss = -bet 

            if win_state >= 10:
                win_state = 0
            if loss_state <= 0:
                loss_state = 0

            v_win = pi*P_h*(R_win + gamma*V[win_state])
            v_loss = pi*P_t*(R_loss + gamma*V[loss_state])

            v = v_win + v_loss

            V[state] = v
            delta = max(delta, np.abs(v_state - V[state]))

        if delta < theta: 
            break

    # print(f"Policy Evaluation Counter {counter}")

    return V

def policy_improvement(init_policy): 

    # Initial Value Func. Approximation (given deterministic Policy)
    value_func = policy_evaluation(init_policy)
    print(f"Initial Value Function {value_func}")

    # Initialize policy to the initial policy 
    pi = init_policy

    imprv_counter = 0 

    max_state_num = 10
    old_action = [] 
    new_policy = []

    stable_flag = False

    # stable_flag, _ = improvement_loop(init_policy, value_func)

    while stable_flag is False: 

        imprv_counter += 1

        if imprv_counter % 1000 ==0:
            print(f"Improvement Cycles {imprv_counter}")

        stable_flag, improved_policy = improvement_loop(pi, value_func)
        pi = improved_policy
        value_func = policy_evaluation(pi)

    print(f"Policy Improvement Counter: {imprv_counter}")

    return pi, value_func

def improvement_loop(pi, V_func): 


    gamma = 1
    max_state_num = 10

    old_action = np.zeros(max_state_num, dtype=int)
    new_policy = np.zeros(max_state_num, dtype=int)

    stability = True

    for state in range(0, max_state_num): 

        if state == 0: 
            P_h = 0
            P_t = 0 
        else: 
            P_h = .9
            P_t = .1
        
        old_action[state] = pi[state]

        action_values = []


        if state == 0: 

            new_policy[state] = 0
            action_values.append(0) 
        else: 
            

            for bet in range(state):

                v = 0 
                # bet = old_action[state]

                R_win = bet
                R_loss = -bet

                win_state = state + bet
                loss_state = state - bet

                if win_state >= 10:
                        win_state = 0
                if loss_state <= 0:
                        loss_state = 0

                v_win = P_h*(R_win + gamma*V_func[win_state])
                v_loss = P_t*(R_loss + gamma*V_func[loss_state])

                v = v_win + v_loss

                action_values.append(v)

            new_policy[state] = np.argmax(action_values)

        # print("Value Func", V_state_max)
        print("Max Action", new_policy[state])


        if old_action[state] != new_policy[state]: 

            stability = False
            break

    return stability, new_policy



if __name__ == '__main__': 


    init_policy = np.random.randint(1, 9, size=10,dtype=int)
    print(init_policy)

    optimal_policy, optimal_value_func = policy_improvement(init_policy)
    print("Optimal Policy")
    print(optimal_policy)
    print("Optimal Value Function")
    print(optimal_value_func)
    
    






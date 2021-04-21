import numpy as np 
import random 


# Policy Iteration
def policy_evaluation(policy):
    """
    Evaluates given policy to a numerical precision set by theta within function 

    :param policy:      The policy being evaluated 
    :return: returns the converged Value function 
    """
    max_num_states = 10                             # Max Number of States in MDP
    V = np.zeros(max_num_states)                    # Initialize Value Func. to zeros

    gamma = 1                                       # Discount Factor                                       
    theta = .0001                                   # Value Func. Precision Threshold param
    counter = 0                                     # Loop Counter 

    while True:                                     # Loop Forever, until desired precision is achieved  

        delta = 0                                   # Initialize Error to zero at every loop start
        counter += 1                                # Increment Counter 

        for state in range(0, max_num_states):      # Loop Over all states in MDP 

            if state == 0:                          # If state == 0, state does not transition 
                P_h = 0 
                P_t = 0
                
            else:                                   # If state !=0, define transition probilities 
                P_h = .9 
                P_t = .1

            v = 0                                   # Intialize temp value func (for current state) to zero 
            v_state = V[state]                      # Store copy of initial value (at current state) for comparison later

            pi = 1                                  # Deterministic policy 100% of selecting action 
            bet = policy[state]                     # Define the action according to current policy

            win_state = (state + bet)               # After taking action, compute future state in HEADs
            loss_state = (state - bet)              # After taking action, compute future state in TAILs

            R_win = bet                             # Compute Reward if HEADs 
            R_loss = -bet                           # Compute Reward if TAILs

            if win_state >= 10:                     # Prevent win & loss states from going out of value function bounds
                win_state = 0
            if loss_state <= 0:
                loss_state = 0

            v_win = pi*P_h*(R_win + gamma*V[win_state])     # Compute new value if HEADs 
            v_loss = pi*P_t*(R_loss + gamma*V[loss_state])  # Compute new value if TAILs

            v = v_win + v_loss                              # Sum to find total value at current state

            V[state] = v                                    # Store updated value at current state 
            delta = max(delta, np.abs(v_state - V[state]))  # Compute delta (precision error)

        if delta < theta:                           # if precision error is less than precision parameter STOP policy evaluation 
            break

    return V

def policy_iteration(init_policy): 
    """
    Implements Policy Evaluation, and then uses the derived value function to improve the policy 

    :param init_policy ~ Supplies the initial "guess" policy
    :return pi  ~ Optimal Policy 
    :return value_func  ~ Optimal Value Function obtained from optimal policy
        
    """

    value_func = policy_evaluation(init_policy)                             # Initial Value Func. Approximation (given deterministic Policy)
    print(f"Initial Value Function {value_func}")
 
    pi = init_policy                                                        # Initialize working policy to the initial policy                        

    imprv_counter = 0                                                       # Initialize Loop Counter to zero
    stable_flag = False                                                     # Initialize STABLE_FLAG -> False

    while stable_flag is False:                                             # While the Policy is UN-stable (aka has not converged) loop                                      

        imprv_counter += 1                                                  # Increment Loop Counter 

        if imprv_counter % 1000 == 0:                                       # Print Loop counter IF policy improvement is taking thousands of iterations
            print(f"Improvement Cycles {imprv_counter}")

        stable_flag, improved_policy = improvement_loop(pi, value_func)     # Use most recent Policy (pi) and Value Func. (value_func) and enter improvement function 
        pi = improved_policy                                                # Once new policy is output, update the old policy to the new policy 
        value_func = policy_evaluation(pi)                                  # Once new value func. is output, update the old value func. to the new value func. 
                                                                            # Repeat UNTIL policy has converged and STABLE_FLAG is set to TRUE by "impprovement_loop"
    print(f"Policy Improvement Counter: {imprv_counter}")                   # Once Policy is Converged Print Loop Counter 

    return pi, value_func                                                   # Return: new policy (pi) and new value Function (value_func) 

def improvement_loop(pi, V_func): 
    """
    Given a policy and its value function, apply Policy Improvement to improve the current policy. 
    :param: pi ~ Current Policy to be Improved 
    :param: V_func ~ Current Policies value function (obtained by Policy Evaluation)

    :return stability ~ IF policy has converged (aka no longer changes during improvement) returns True Else: False
    :return new_policy ~ Return the new policy obtained by policy improvement 
    """

    gamma = 1                                                                   # Discount Factor 
    max_state_num = 10                                                          # Max Number of states in MDP 

    old_action = [pi[state] for state in range(0, max_state_num)]               # Create copy of old policy via list comprehension 
    new_policy = np.zeros(max_state_num, dtype=int)                             # Create array for new policy (initialized to zeros)

    stability = True                                                            # Set Stability -> True to test for improved policy convergence 

    for state in range(0, max_state_num):                                       # Loop over every state in the MDP 
      
        if state == 0:                                                          # If the current state == 0 the only action possible is the zero action ($0 bet)
            new_policy[state] = 0                                               # Update zero-th element of new policy with only action possible from state == 0 
            continue                                                            # Skip remaining loop and continue to next state in MDP 

        action_values = [-np.inf]                                               # Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

        for bet in range(1, (state+1)):                                         # For every possible action (aka Bet) possible from the current state: Compute the 
            Q = 0                                                               # Action value for current action TAKEN from the current state
            P_h = .9                                                            # Define Probability of Transition into heads ONCE action (aka bet) is taken                                                          
            P_t = .1                                                            # Define Probability of Transition into tails ONCE action (aka bet) is taken 

            R_win = bet                                                         # Define reward for Winning (aka Heads)
            R_loss = -bet                                                       # Define reward for lossing (aka Tails) 

            win_state = state + bet                                             # Compute new state if HEADs
            loss_state = state - bet                                            # Compute new state if TAILs

            if win_state >= 10:                                                 # Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                win_state = 0
            if loss_state <= 0:
                loss_state = 0

            v_win = P_h*(R_win + gamma*V_func[win_state])                       # Compute the updated value of winning the coin toss
            v_loss = P_t*(R_loss + gamma*V_func[loss_state])                    # Compute the updated value of lossing the coin toss 

            Q = v_win + v_loss                                                  # Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
            action_values.append(Q)                                             # Append Q to list of action values for the CURRENT state 

        new_policy[state] = np.argmax(action_values)                            # Once all possible actions have been taken (for current state) select the MAX Action-Value 

        if old_action[state] != new_policy[state]:                              # Check for Convergence Stabilty. IF the old Policy does not match the new Policy then the policy has not finished converging 
            stability = False 
 
    # print(f"Old Policy {old_action}")                                           # Print Old Policy for each iteration of policy improvement 
    # print(f" New Policy {new_policy}")                                          # Print New Policy for each Iteration of policy improvement 

    return stability, new_policy                                                # Return: The stability flag and the updated (improved) policy


# Value Iteration 
def value_iteration(): 

    """
    Evaluates given policy to a numerical precision set by theta within function 

    :param policy:      The policy being evaluated 
    :return: returns the converged Value function 
    """
    max_num_states = 10                             # Max Number of States in MDP
    V = np.zeros(max_num_states)                    # Initialize Value Func. to zeros
    new_policy = np.zeros(max_num_states, dtype=int)                             # Create array for new policy (initialized to zeros)

    gamma = 1                                       # Discount Factor                                       
    theta = .0001                                   # Value Func. Precision Threshold param
    counter = 0                                     # Loop Counter 

    # Update Value Function 
    while True:                                     # Loop Forever, until desired precision is achieved  

        delta = 0                                   # Initialize Error to zero at every loop start
        counter += 1                                # Increment Counter 

        for state in range(0, max_num_states):      # Loop Over all states in MDP 

            if state == 0:                          # If state == 0, state does not transition 
                P_h = 0 
                P_t = 0

                continue
                
            else:                                   # If state !=0, define transition probilities 
                P_h = .1 
                P_t = .9

            v_state = V[state]                      # Store copy of initial value (at current state) for comparison later

            max_state_value = [-np.inf]                                               # Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

            for bet in range(1, (state+1)):                                         # For every possible action (aka Bet) possible from the current state: Compute the 
                v = 0                                                               # Action value for current action TAKEN from the current state                                                         # Define Probability of Transition into tails ONCE action (aka bet) is taken 

                R_win = bet                                                         # Define reward for Winning (aka Heads)
                R_loss = -bet                                                       # Define reward for lossing (aka Tails) 

                win_state = state + bet                                             # Compute new state if HEADs
                loss_state = state - bet                                            # Compute new state if TAILs

                if win_state >= 10:                                                 # Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                    win_state = 0
                if loss_state <= 0:
                    loss_state = 0

                v_win = P_h*(R_win + gamma*V[win_state])                       # Compute the updated value of winning the coin toss
                v_loss = P_t*(R_loss + gamma*V[loss_state])                    # Compute the updated value of lossing the coin toss 

                v = v_win + v_loss                                                  # Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
                max_state_value.append(v)                                             # Append Q to list of action values for the CURRENT state 

            V[state] = max(max_state_value)
            delta = max(delta, np.abs(v_state - V[state]))  # Compute delta (precision error)

        if delta < theta:                           # if precision error is less than precision parameter STOP policy evaluation 
            break



    # Output Deterministic Policy: 
    V_func = V

    for state in range(0, max_num_states):      # Loop Over all states in MDP 

            if state == 0:                          # If state == 0, state does not transition 
                P_h = 0 
                P_t = 0

                continue
                
            else:                                   # If state !=0, define transition probilities 
                P_h = .1 
                P_t = .9

            action_values = [-np.inf]                                               # Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

            for bet in range(1, (state+1)):                                         # For every possible action (aka Bet) possible from the current state: Compute the 
                Q = 0                                                               # Action value for current action TAKEN from the current state                                                         # Define Probability of Transition into tails ONCE action (aka bet) is taken 

                R_win = bet                                                         # Define reward for Winning (aka Heads)
                R_loss = -bet                                                       # Define reward for lossing (aka Tails) 

                win_state = state + bet                                             # Compute new state if HEADs
                loss_state = state - bet                                            # Compute new state if TAILs

                if win_state >= 10:                                                 # Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                    win_state = 0
                if loss_state <= 0:
                    loss_state = 0

                v_win = P_h*(R_win + gamma*V_func[win_state])                       # Compute the updated value of winning the coin toss
                v_loss = P_t*(R_loss + gamma*V_func[loss_state])                    # Compute the updated value of lossing the coin toss 

                Q = v_win + v_loss                                                  # Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
                action_values.append(Q) 
            
            new_policy[state] = np.argmax(action_values)                            # Once all possible actions have been taken (for current state) select the MAX Action-Value 

    return V_func, new_policy


if __name__ == '__main__': 
    print("##############################################")
    print(" ---------- Policy Iteration -----------------")
    print("##############################################")
    print("                                              ")

    init_policy = np.random.randint(1, 9, size=10,dtype=int)                    # Initialize Init_policy randomly 
    init_policy[0] = 0                                                          # Set the policy to 0 for state == 0 

    # init_policy = np.ones(10,dtype=int)                                       # Initialize Init_policy to all ones (aka. $1 betting strategy as seen in HW2)
    # init_policy[0] = 0                                                        # Set the policy to 0 for state == 0 
    

    


    print("Initial Random Policy ",init_policy)

    optimal_policy, optimal_value_func = policy_iteration(init_policy)        # Perform Policy Improvement and output: Optimal Policy & Optimal Value Function

    print("Optimal Policy")
    print(optimal_policy)
    print("Optimal Value Function")
    print(optimal_value_func)



    print("                                              ")
    print("                                              ")

    print("##############################################")
    print(" ---------- Value Iteration -----------------")
    print("##############################################")
    print("                                              ")


    opt_value_func, opt_policy = value_iteration()
    print("Optimal Policy")
    print(opt_policy)
    print("Optimal Value Function")
    print(opt_value_func)


    # init_policy = np.ones(10,dtype=int)                                       # Initialize Init_policy to all ones (aka. $1 betting strategy as seen in HW2)
    # init_policy[0] = 0  


    # ones_val = policy_evaluation(init_policy)
    # print(ones_val)
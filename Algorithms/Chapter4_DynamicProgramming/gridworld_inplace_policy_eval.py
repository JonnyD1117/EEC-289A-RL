import numpy as np 
import random

def coord2index(row, col):

    if row == 0:
        index = (row + col) 
    else: 
        index = (4*row + col)  
    
    return index

def index2coord(state): 

    row_num = int(state/4)
    col_num = state - 4*row_num

    return row_num, col_num

def get_reward(current_state_ind):

    return -1 

def policy():

    a_prob = .25

    return a_prob

def trans_prob(cur_state_ind, goal_indices):

    if cur_state_ind in goal_indices: 
        return 0
    
    else:
        return 1

def is_state_valid(row, col): 

    new_row = row
    new_col = col

    valid_state = True

    if new_row < 0 or new_row > 3 or new_col < 0 or new_col > 3: 
        valid_state = False

    return valid_state

def compute_next_state(current_state_ind, action):

    cur_row, cur_col = index2coord(current_state_ind)

    new_row = cur_row
    new_col = cur_col

    if action == 0: # up 
        new_row-=1

    elif action == 1: # Down 
        new_row += 1
    
    elif action == 2: # Left 
        new_col-=1

    elif action == 3: # Right
        new_col += 1

    new_state_ind = coord2index(new_row, new_col)
    valid_state_flag = is_state_valid(new_row, new_col)

    if valid_state_flag: 
        return new_state_ind

    else:
        return current_state_ind

if __name__ == '__main__': 
    grid_x = 4
    grid_y = 4


    num_iter = 100
    num_actions = 4 
    num_states = grid_x*grid_y

    V = np.zeros(grid_x*grid_y)
    # V_new = np.zeros(grid_x*grid_y)

    goal_state_ind = [0, 15]
    gamma = 1
    delta = 0

    theta = .001
    counter = 0
    term_flag = False

    while True:
        counter += 1
        delta = 0
        v_state = V[1] 
        
        for state in range(num_states): 
            v = 0
                       
            
            for action in range(num_actions): 
                next_state = compute_next_state(state, action)

                pi = policy()
                P = trans_prob(state, goal_state_ind)
                R = get_reward(state)
                    
                v += pi*P*(R + gamma*V[next_state])

            V[state] = v


        delta = max(delta, np.abs(v_state - V[1])) 

        if delta < theta: 
            term_flag = True
            break

    print("Policy Iteration: # Iterations =", counter)
    print(V)
    # print(V_new)







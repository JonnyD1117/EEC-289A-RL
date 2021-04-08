import numpy as np 


def coord2index(row, col):

    if row == 0:
        index = (row + col) 
    else: 
        index = (4*row + col)  
    
    return index

def index2coord(state): 

    row_num = int(state/4)
    col_num = state - 4*row_num

    return (row_num, col_num)

def policy(state): 
    # Equiprobable 
    pi = .25
    return pi

def state_trans_mode(): 

    return 1

def get_reward(state, goal_states): 

    if state in goal_states: 

        r = 0 
    else: 
        r = -1

    return r

def move2nextstate(cur_state, action): 

    cur_row = cur_state[0]
    cur_col = cur_state[1]

    new_row = cur_row
    new_col = cur_col


    if action == 0: # Up 
        new_row -= 1    

    elif action == 1: # Down 
        new_row += 1      

    elif action == 2: # Left
        new_col -= 1      

    elif action == 3: # Right
        new_col += 1      

    # Check if New State is Valid 
    valid_state = True

    if new_row < 0 or new_col < 0:
        valid_state = False 

    elif new_row > 3 or new_col > 3: 
        valid_state = False

    if valid_state: 

        return (new_row, new_col), valid_state
    else: 
        return (cur_row, cur_col), valid_state
    
        
if __name__ == '__main__': 

    grid_x = 4 
    grid_y = 4

    V = np.zeros(grid_x*grid_y)
    V_new = np.zeros(grid_x*grid_y)


    num_actions = 4
    num_itter = 1
    gamma = .98

    # goal_state = [(0,0), (3,3)] 
    goal_state = [0, 15] 


    for iterr in range(num_itter): 
        # Iterate over Policy Evaluation as till contvergence
        for state in range(grid_x*grid_y): 
            # For each state in value function 
            coord = index2coord(state)
            for action in range(num_actions): 
                new_coord, valid_state = move2nextstate(coord, action)
                row, col = new_coord

                new_state = coord2index(row, col)

                reward = get_reward(new_state, goal_state)

                if state in goal_state: 

                    V_new[state] += .25*0*(reward + gamma*V[new_state])

                else:
                            
                    V_new[state] += .25*1*(reward + gamma*V[new_state])

                        


    print(V_new)


%% EEC 289A Homework #5
% SARSA' & Q-Learning 
% Cliff Walking (4x12)




%% SARSA' (On-Policy TD: Model-Free Control) 

clear all 
clc

num_episodes = 500;                 % Number of Episodes
num_runs = 1000;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

grid_x = 12;                        % X-Dim of Grid World 
grid_y = 4;                         % Y-Dim of Grid World
num_actions = 4;                    % Number of Actions possible from each state

start_state = [1,1];                % 
goal_state = [grid_x, 1]; 

Q = zeros(grid_x, grid_y, num_actions);
Q(12, 1,:) = 0;

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(grid_x, grid_y); % Initialize Cliff Zone to zeros 
cliff_zone(2:11, 1) = 1;            % Seed Cliff Zone with 1's where cliff exists

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
    disp("RUN #")
    run
    
    Q = zeros(grid_x, grid_y, num_actions);
    Q(12, 1,:) = 0;
    
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
        term_flag = 0; 
        
        disp("Episode")
        eps
                                    
        reward_sum = 0 ;            % Initialize Reward_SUM to zero 
        state = start_state;        % Initialize START State 
        state_x = 1;   % Get X Position 
        state_y = 1;   % Get Y Position 
        
        action = action_selection(state_x, state_y, Q, epsilon);      % Eps-Greedy Action Selection 
        game_cnt = 0;
        
        while term_flag == 0  % Loop UNTIL state == terminal state 
            game_cnt = game_cnt + 1; 
            new_state = apply_action(state, action);                % Given Initial action Compute NEW state            
            [new_state, state_valid] = check_valid_state(new_state, state, grid_x, grid_y);      % Check whether NEW state is a valid state or NOT 
            
            state_new_x = new_state(1);             % Get X Pos from Updated State
            state_new_y = new_state(2);             % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_x, state_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = s_0x;                 % Send Agent Back to Starting X Position 
                state_new_y = s_0y;                 % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end 
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(state_new_x, state_new_y, Q, epsilon);      % Eps-Greedy Action Selection 
            Q(state_x, state_y, action) = Q(state_x, state_y, action) + alpha*(R + gamma*Q(state_new_x, state_new_y, action_prime) - Q(state_x, state_y, action)); % Update Q-Function according to TD-0 target
            
            Q(12, 1,:) = 0;
            
            state = new_state; 
            action = action_prime; 
            
            if state_new_x == 12 && state_new_y == 1
                term_flag = 1; 
            end 
        end      
        disp("Game Counter")
        game_cnt
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 


avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 


end 


figure(1)
plot(avg_reward_sum)
xlabel("Number of Episodes")
ylabel("Sum of Rewards")
title("SARA' Performance: Cliff Walking")



%% Q-Learning (Off-Policy TD: Model-Free Control) 

clear all 
clc

num_episodes = 500;                 % Number of Episodes
num_runs = 1000;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

grid_x = 12;                        % X-Dim of Grid World 
grid_y = 4;                         % Y-Dim of Grid World
num_actions = 4;                    % Number of Actions possible from each state

start_state = [1,1];                % 
goal_state = [grid_x, 1]; 

Q = ones(grid_x, grid_y, num_actions);
Q(12, 1,:) = 0;

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(grid_x, grid_y); % Initialize Cliff Zone to zeros 
cliff_zone(2:11, 1) = 1;            % Seed Cliff Zone with 1's where cliff exists

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
    disp("RUN #")
    run
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
        term_flag = 0; 
        
        disp("Episode")
        eps
                                    
        reward_sum = 0 ;            % Initialize Reward_SUM to zero 
        state = start_state;        % Initialize START State 
        state_x = 1;   % Get X Position 
        state_y = 1;   % Get Y Position 
        
        action = action_selection(state_x, state_y, Q, epsilon);      % Eps-Greedy Action Selection 
%         disp('Episode')
%         eps
        while term_flag == 0  % Loop UNTIL state == terminal state 
%             disp('IN WHILE LOOP')
            new_state = apply_action(state, action);                % Given Initial action Compute NEW state            
            [new_state, state_valid] = check_valid_state(new_state, state, grid_x, grid_y);      % Check whether NEW state is a valid state or NOT 
            
            state_new_x = new_state(1);             % Get X Pos from Updated State
            state_new_y = new_state(2);             % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_x, state_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = s_0x;                 % Send Agent Back to Starting X Position 
                state_new_y = s_0y;                 % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end 
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(state_new_x, state_new_y, Q, epsilon);      % Eps-Greedy Action Selection 
            Q(state_x, state_y, action) = Q(state_x, state_y, action) + alpha*(R + gamma*Q(state_new_x, state_new_y, action_prime) - Q(state_x, state_y, action)); % Update Q-Function according to TD-0 target
            
            Q(12, 1,:) = 0;
            
            state = new_state; 
            action = action_prime; 
            
            if state_new_x == 12 && state_new_y == 1
                term_flag = 1; 
            end 
        end      
        
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 


avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 


end 


figure(1)
plot(avg_reward_sum)
xlabel("Number of Episodes")
ylabel("Sum of Rewards")
title("SARA' Performance: Cliff Walking")








%% Expected-SARSA' (On-Policy TD: Model-Free Control) 

clear all 
clc

num_episodes = 500;                 % Number of Episodes
num_runs = 1000;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

grid_x = 12;                        % X-Dim of Grid World 
grid_y = 4;                         % Y-Dim of Grid World
num_actions = 4;                    % Number of Actions possible from each state

start_state = [1,1];                % 
goal_state = [grid_x, 1]; 

Q = ones(grid_x, grid_y, num_actions);
Q(12, 1,:) = 0;

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(grid_x, grid_y); % Initialize Cliff Zone to zeros 
cliff_zone(2:11, 1) = 1;            % Seed Cliff Zone with 1's where cliff exists

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
    disp("RUN #")
    run
    
    Q = ones(grid_x, grid_y, num_actions);
    Q(12, 1,:) = 0;
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
        term_flag = 0; 
        
        disp("Episode")
        eps
                                    
        reward_sum = 0 ;            % Initialize Reward_SUM to zero 
        state = start_state;        % Initialize START State 
        state_x = 1;   % Get X Position 
        state_y = 1;   % Get Y Position 
        
        action = action_selection(state_x, state_y, Q, epsilon);      % Eps-Greedy Action Selection 
%         disp('Episode')
%         eps
        while term_flag == 0  % Loop UNTIL state == terminal state 
%             disp('IN WHILE LOOP')
            new_state = apply_action(state, action);                % Given Initial action Compute NEW state            
            [new_state, state_valid] = check_valid_state(new_state, state, grid_x, grid_y);      % Check whether NEW state is a valid state or NOT 
            
            state_new_x = new_state(1);             % Get X Pos from Updated State
            state_new_y = new_state(2);             % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_x, state_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = s_0x;                 % Send Agent Back to Starting X Position 
                state_new_y = s_0y;                 % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end 
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(state_new_x, state_new_y, Q, epsilon);      % Eps-Greedy Action Selection 
            Q(state_x, state_y, action) = Q(state_x, state_y, action) + alpha*(R + gamma*Q(state_new_x, state_new_y, action_prime) - Q(state_x, state_y, action)); % Update Q-Function according to TD-0 target
            
            Q(12, 1,:) = 0;
            
            state = new_state; 
            action = action_prime; 
            
            if state_new_x == 12 && state_new_y == 1
                term_flag = 1; 
            end 
        end      
        
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 


avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 


end 


figure(1)
plot(avg_reward_sum)
xlabel("Number of Episodes")
ylabel("Sum of Rewards")
title("SARA' Performance: Cliff Walking")


%% Function Definitions 


function [state, state_valid] = check_valid_state(cur_state, prev_state, grid_x, grid_y)
    
    x_state = cur_state(1);         % Obtain X Position in Grid World for NEW position
    y_state = cur_state(2);         % Obtain Y Position in Grid World for NEW position

    if x_state> grid_x || y_state > grid_y      % IF X or Y states are larger than max Grid World Dimensions -> invalid state (return previous state)
        
        state_valid = 0; 
        state = prev_state;
        
    elseif x_state < 1 || y_state < 1           % IF X or Y states are smaller than min Grid World Dimensions -> invalid state (return previous state)
        
        state_valid = 0; 
        state = prev_state;        
        
    else % State ->  VALID
        
        state = cur_state;
        state_valid = 1; 
        
    end 

end 

function action_to_take = action_selection(state_x, state_y, Q_func, eps)


    sample = rand();                % Randomly Sample to determine whether action selection is greedy or random
    
    if sample <= eps                % Selection action Randomly 
        
        action_to_take = randi([1,4]); 
        
    else                            % Selection Action Greedily
        
        [max_val, arg_max] = max(Q_func(state_x, state_y, :));      % Evaluate Q-Function at CURRENT state and selection the action which maximizes the Q_func
        
        action_to_take = arg_max; 
        
    end 
end 

function new_state = apply_action(cur_state, action)

    % ACTION: {1: UP, 2: DOWN, 3: LEFT, 4: RIGHT}

    x_state = cur_state(1);                 % Get Current X Position 
    y_state = cur_state(2);                 % Get Current Y Position 
    
    if action == 1                          % Move UP (+y)
        y_state = y_state + 1;              % Increment Y Position 
        
    elseif action == 2                      % Move DOWN (-y)
        y_state = y_state - 1 ;             % Decrement Y Position 
        
    elseif action == 3                      % Move LEFT (-x)
        x_state = x_state - 1;              % Decrement X Position 
        
    elseif action == 4                      % Move RIGHT(+x)
        x_state = x_state + 1 ;             % Increment X Position 
            
    end 

    new_state = [x_state, y_state];         % Create NEW State 
end 

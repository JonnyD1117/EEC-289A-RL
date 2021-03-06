%% EEC 289A Homework #5
% SARSA' & Q-Learning 
% Cliff Walking (4x12)




%% SARSA' (On-Policy TD: Model-Free Control) 

clear all 
clc

num_episodes = 500;                 % Number of Episodes
num_runs = 100;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

num_actions = 4;                    % Number of Actions possible from each state

start_state = [4,1];                % 
goal_state = [4, 12]; 

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(4, 12); % Initialize Cliff Zone to zeros 
cliff_zone(4, 2:11) = 1;            % Seed Cliff Zone with 1's where cliff exists

Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
%     disp("RUN")
%     run

    Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;
    
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
%         disp("Num. Episodes")
%         eps
        
        reward_sum = 0 ;                                                                % Set Reward_SUM to zero 
        state = [4, 1];                                                                 % Initialize START State 
        state_x = 4;                                                                    % Get X Position 
        state_y = 1;                                                                    % Get Y Position 
        
        action = action_selection(state, Q, epsilon);                                   % Eps-Greedy Action Selection 

        while true 
            state_x = state(1);                                                                    % Get X Position 
            state_y = state(2);
            
            % Loop UNTIL state == terminal state 
            new_state = apply_action(state, action);                                    % Given Initial action Compute NEW state                        
            state_new_x = new_state(1);         % Get X Pos from Updated State
            state_new_y = new_state(2);         % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_new_x, state_new_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = 4;                % Send Agent Back to Starting X Position 
                state_new_y = 1;                % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end             
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(new_state, Q, epsilon);      % Eps-Greedy Action Selection 
            Q(state_x, state_y ,action) = Q(state_x,state_y ,action) + alpha*(R + gamma*Q(state_new_x, state_new_y, action_prime) - Q(state_x, state_y ,action)); % Update Q-Function according to TD-0 target
  
            Q(4, 12,:) = 0;                 % Make sure Q(term_state, :) -> 0 

            if state_new_x == 4 && state_new_y == 12    % If state is Terminal State 
                break  
            end
            
            state = new_state; 
            action = action_prime; 
        end  
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 

% rewards_table = movmean(rewards_table, 10);

avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 

end 



sarsa_mov_avg = movmean(avg_reward_sum, 15);


%% Q-Learning 


% clear all 
% clc

num_episodes = 500;                 % Number of Episodes
num_runs = 100;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

num_actions = 4;                    % Number of Actions possible from each state

start_state = [4,1];                % 
goal_state = [4, 12]; 

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(4, 12); % Initialize Cliff Zone to zeros 
cliff_zone(4, 2:11) = 1;            % Seed Cliff Zone with 1's where cliff exists

Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
%     disp("RUN")
%     run

    Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;
    
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
%         disp("Num. Episodes")
%         eps
        
        reward_sum = 0 ;                                                                % Set Reward_SUM to zero 
        state = [4, 1];                                                                 % Initialize START State 
        state_x = 4;                                                                    % Get X Position 
        state_y = 1;                                                                    % Get Y Position 
        

        while true 
            action = action_selection(state, Q, epsilon);                                   % Eps-Greedy Action Selection 

            state_x = state(1);                                                                    % Get X Position 
            state_y = state(2);
            
            % Loop UNTIL state == terminal state 
            new_state = apply_action(state, action);                                    % Given Initial action Compute NEW state                        
            state_new_x = new_state(1);         % Get X Pos from Updated State
            state_new_y = new_state(2);         % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_new_x, state_new_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = 4;                % Send Agent Back to Starting X Position 
                state_new_y = 1;                % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end             
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(new_state, Q, epsilon);      % Eps-Greedy Action Selection 
            Q(state_x, state_y ,action) = Q(state_x,state_y ,action) + alpha*(R + gamma*max(Q(state_new_x, state_new_y, :)) - Q(state_x, state_y ,action)); % Update Q-Function according to TD-0 target
  
            Q(4, 12,:) = 0;                 % Make sure Q(term_state, :) -> 0 

            if state_new_x == 4 && state_new_y == 12    % If state is Terminal State 
                break  
            end
            
            state = new_state; 
        end  
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 


avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 

end 



qlearn_mov_avg = movmean(avg_reward_sum, 15);


%% SARSA' & Q-Learning Plot 

figure(1)
hold on 
plot(sarsa_mov_avg)
plot(qlearn_mov_avg)

xlim([0,500])
ylim([-100,-20])
xlabel("Number of Episodes")
ylabel("Sum of Rewards")
title(" ' Performance: Cliff Walking")
legend('SARSA','Q-Learning')
%% Expected SARSA'

num_episodes = 500;                 % Number of Episodes
num_runs = 50;                    % Number of Runs made to compute "average" reward for given number of episodes

epsilon = .1;                       % Epsilon-Greedy Exploration Probability 
gamma = 1;                          % Discount Factor 
alpha = 0.5;                        % Learning Rate  

num_actions = 4;                    % Number of Actions possible from each state

start_state = [4,1];                % 
goal_state = [4, 12]; 

rewards_table = zeros(num_runs, num_episodes);

cliff_zone = zeros(4, 12); % Initialize Cliff Zone to zeros 
cliff_zone(4, 2:11) = 1;            % Seed Cliff Zone with 1's where cliff exists

Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;

for run = 1:1:num_runs              % Iterate over Total number of averaging RUNS 
%     disp("RUN")
%     run

    Q = zeros(4, 12 ,num_actions);
    Q(4, 12,:) = 0;
    
    for eps = 1:1:num_episodes      % Iterate over Total number of Episodes 
%         disp("Num. Episodes")
%         eps
        
        reward_sum = 0 ;                                                                % Set Reward_SUM to zero 
        state = [4, 1];                                                                 % Initialize START State 
        state_x = 4;                                                                    % Get X Position 
        state_y = 1;                                                                    % Get Y Position 
        

        while true 
            action = action_selection(state, Q, epsilon);                                   % Eps-Greedy Action Selection 

            state_x = state(1);                                                                    % Get X Position 
            state_y = state(2);
            
            % Loop UNTIL state == terminal state 
            new_state = apply_action(state, action);                                    % Given Initial action Compute NEW state                        
            state_new_x = new_state(1);         % Get X Pos from Updated State
            state_new_y = new_state(2);         % Get Y Pos from Updated State 
            
            on_cliff = cliff_zone(state_new_x, state_new_y); % Check if state is ON the Cliff
            
            if on_cliff == 1                    % If state is ON the Cliff 
                
                R = -100;                       % Compute CLIFF Reward 
                state_new_x = 4;                % Send Agent Back to Starting X Position 
                state_new_y = 1;                % Send Agent Back to Starting Y Position 
                
                new_state = [state_new_x, state_new_y]; 
                
            else                                % If state is NOT on the Cliff 
                R = -1;                         % IF state is NOT on the cliff assign reward of -1 for all transitions 
            end             
            
            reward_sum = reward_sum + R;        % Update the Reward SUM at each step of Episode 
            
            action_prime = action_selection(new_state, Q, epsilon);      % Eps-Greedy Action Selection 
            
            expected_targ = Expected_Sarsa_Return(new_state, Q, epsilon);
            
            Q(state_x, state_y ,action) = Q(state_x,state_y ,action) + alpha*(R + gamma*expected_targ - Q(state_x, state_y ,action)); % Update Q-Function according to TD-0 target
  
            Q(4, 12,:) = 0;                 % Make sure Q(term_state, :) -> 0 

            if state_new_x == 4 && state_new_y == 12    % If state is Terminal State 
                break  
            end
            
            state = new_state; 
        end  
        rewards_table(run, eps)  = reward_sum;      % Update Reward Table to Compute Average Reward Sums late 
    end     
end 


avg_reward_sum = zeros(1, num_episodes);

for i = 1:1:num_episodes
avg_reward_sum(i) = mean(rewards_table(:, i)); 

end 




exp_sarsa_mov_avg = movmean(avg_reward_sum, 15);

%% SARSA, Q-Learning, & Expected SARSA Plots


figure(2)
hold on 
plot(sarsa_mov_avg)
plot(qlearn_mov_avg)
plot(exp_sarsa_mov_avg)


xlim([0,500])
ylim([-100,-20])
xlabel("Number of Episodes")
ylabel("Sum of Rewards")
title(" ' Performance: Cliff Walking")
legend('SARSA','Q-Learning', 'Expected SARSA')


%% Function Definitions 

function action_to_take = action_selection(state, Q_func, eps)
    
    state_x = state(1);
    state_y = state(2);

    sample = rand();                % Randomly Sample to determine whether action selection is greedy or random
    
    if sample < eps                % Selection action Randomly 
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
    
    if action == 1                          % Move UP (-x)
        x_state = x_state - 1;              % Increment Y Position 
        
    elseif action == 2                      % Move DOWN (+x)
        x_state = x_state + 1 ;             % Decrement Y Position 
        
    elseif action == 3                      % Move LEFT (-y)
        y_state = y_state - 1;              % Decrement X Position 
        
    elseif action == 4                      % Move RIGHT(+y)
        y_state = y_state + 1 ;             % Increment X Position 
            
    end 

    
    x_state = max(1,x_state);
    x_state = min(4, x_state); 
    
    y_state = max(1,y_state);
    y_state = min(12, y_state); 
        
    new_state = [x_state, y_state];         % Create NEW State 
end 

function target = Expected_Sarsa_Return(new_state, Q_func, eps)

new_state_x = new_state(1);
new_state_y = new_state(2);

[max_val, argmax] = max(Q_func(new_state_x, new_state_y, :)); 

target = 0; 

    for i = 1:1:4

        if i == argmax
            pi = 1-eps;

        else

            pi = eps;
        end 

        target = target + (pi*Q_func(new_state_x, new_state_y, i));

    end 
end 

%% EEC 289A Homework #3 
% Jonathan Dorsey 

 %% 
  
 clear all 
 clc
            

init_policy = ones(1,10);
init_policy(1) = 0    ;      


[optimal_policy, optimal_value_func] = policy_iteration(init_policy)


%     opt_value_func, opt_policy = value_iteration()






















%%
% Policy Iteration
function V = policy_evaluation(policy)

    max_num_states = 10  ;                           % Max Number of States in MDP
    V = zeros(1, max_num_states)  ;                  % Initialize Value Func. to zeros

    gamma = 1  ;                                     % Discount Factor                                       
    theta = .0001 ;                                  % Value Func. Precision Threshold param
    counter = 0  ;                                   % Loop Counter 

    while true                                    % Loop Forever, until desired precision is achieved  

        delta = 0 ;                                  % Initialize Error to zero at every loop start
        counter = counter + 1 ;                               % Increment Counter 

        for state  = [1:1: (max_num_states)]      % Loop Over all states in MDP 

            if (state-1) == 0                          % If state == 0, state does not transition 
                P_h = 0 ;
                P_t = 0;
                
            else                                   % If state !=0, functionine transition probilities 
                P_h = .9 ;
                P_t = .1;
                
            end 

            v = 0;                                   % Intialize temp value func (for current state) to zero 
            v_state = V(state);                      % Store copy of initial value (at current state) for comparison later

            pi = 1;                                  % Deterministic policy 100% of selecting action 
            bet = policy(state);                     % functionine the action according to current policy

            win_state = (state + bet);               % After taking action, compute future state in HEADs
            loss_state = (state - bet);              % After taking action, compute future state in TAILs

            R_win = bet;                             % Compute Reward if HEADs 
            R_loss = -bet  ;                         % Compute Reward if TAILs

            if win_state >= 11                     % Prevent win & loss states from going out of value function bounds
                win_state = 1;
            end 
            if loss_state <= 1
                loss_state = 1;
            end 

            v_win = pi*P_h*(R_win + gamma*V(win_state));     % Compute new value if HEADs 
            v_loss = pi*P_t*(R_loss + gamma*V(loss_state));  % Compute new value if TAILs

            v = v_win + v_loss ;                             % Sum to find total value at current state

            V(state) = v   ;                                 % Store updated value at current state 
            delta = max(delta, abs(v_state - V(state)));  % Compute delta (precision error)
        end 
        
        if delta < theta                           % if precision error is less than precision parameter STOP policy evaluation 
            break
        end 
    end 
    
end 

function [pi, value_func] = policy_iteration(init_policy) 


    value_func = policy_evaluation(init_policy) ;                            % Initial Value Func. Approximation (given deterministic Policy)
%     print(f"Initial Value Function {value_func}")
 
    pi = init_policy;                                                        % Initialize working policy to the initial policy                        

    imprv_counter = 0 ;                                                      % Initialize Loop Counter to zero
    stable_flag = false;                                                     % Initialize STABLE_FLAG -> False

    while stable_flag == false                                             % While the Policy is UN-stable (aka has not converged) loop                                      

        imprv_counter = imprv_counter + 1;                                                  % Increment Loop Counter 

        if imprv_counter % 1000 == 0:                                       % Print Loop counter IF policy improvement is taking thousands of iterations
%             print(f"Improvement Cycles {imprv_counter}")
                imprv_counter
        end 

        [stable_flag, improved_policy] = improvement_loop(pi, value_func);     % Use most recent Policy (pi) and Value Func. (value_func) and enter improvement function 
        pi = improved_policy;                                                % Once new policy is output, update the old policy to the new policy 
        value_func = policy_evaluation(pi);                              % Once new value func. is output, update the old value func. to the new value func. 
    end                                                                     % Repeat UNTIL policy has converged and STABLE_FLAG is set to TRUE by "impprovement_loop"
%     print(f"Policy Improvement Counter: {imprv_counter}")                   % Once Policy is Converged Print Loop Counter 

end

        
function [stability, new_policy]  = improvement_loop(pi, V_func) 


    gamma = 1 ;                                                                  % Discount Factor 
    max_state_num = 10  ;                                                        % Max Number of states in MDP 

    
    for i  = [1:1:(max_state_num)]
        old_action(i) = pi(i);
    end
    
    new_policy = zeros(1, max_state_num);                                       % Create array for new policy (initialized to zeros)

    stability = true      ;                                                      % Set Stability -> True to test for improved policy convergence 

    for state  = [1:1:(max_state_num)]                                       % Loop over every state in the MDP 
      
        if (state-1) == 0                                                          % If the current state == 0 the only action possible is the zero action ($0 bet)
            new_policy(state) = 0 ;                                              % Update zero-th element of new policy with only action possible from state == 0 
            continue  
        end % Skip remaining loop and continue to next state in MDP 

        action_values = [-inf] ;                                                 % Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

        for bet  = [2:1:state]                                                   % For every possible action (aka Bet) possible from the current state: Compute the 
            Q = 0;                                                               % Action value for current action TAKEN from the current state
            P_h = .9 ;                                                           % functionine Probability of Transition into heads ONCE action (aka bet) is taken                                                          
            P_t = .1 ;                                                           % functionine Probability of Transition into tails ONCE action (aka bet) is taken 

            R_win = bet ;                                                        % functionine reward for Winning (aka Heads)
            R_loss = -bet  ;                                                     % functionine reward for lossing (aka Tails) 

            win_state = state + bet;                                             % Compute new state if HEADs
            loss_state = state - bet ;                                           % Compute new state if TAILs

            if win_state >= 11                                                % Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                win_state = 1;
            end 
            if loss_state <= 1
                loss_state = 1;
            end 

            v_win = P_h*(R_win + gamma*V_func(win_state)) ;                      % Compute the updated value of winning the coin toss
            v_loss = P_t*(R_loss + gamma*V_func(loss_state)) ;                   % Compute the updated value of lossing the coin toss 

            Q = v_win + v_loss ;                                                 % Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
            action_values(end+1) = (Q)   ;                                          % Append Q to list of action values for the CURRENT state 
        end 
            
        [max_val, arg_max] = max(action_values);
        new_policy(state) = arg_max  ;                                           % Once all possible actions have been taken (for current state) select the MAX Action-Value 

        if old_action(state) ~= new_policy(state)                               % Check for Convergence Stabilty. IF the old Policy does not match the new Policy then the policy has not finished converging 
            stability = false ;
        end 
                                                                                % Return: The stability flag and the updated (improved) policy
    end
    
end

% Value Iteration 
function [V_func, new_policy] = value_iteration() 

    max_num_states = 10;                             % Max Number of States in MDP
    V = zeros(1, max_num_states);                    % Initialize Value Func. to zeros
    new_policy = zeros(1,max_num_states);                             % Create array for new policy (initialized to zeros)

    gamma = 1 ;                                      % Discount Factor                                       
    theta = .0001 ;                                  % Value Func. Precision Threshold param
    counter = 0  ;                                   % Loop Counter 

    % Update Value Function 
    while true                                     % Loop Forever, until desired precision is achieved  

        delta = 0;                                   % Initialize Error to zero at every loop start
        counter = counter + 1;                                % Increment Counter 

        for state = [1:1:(max_num_states+1)]       % Loop Over all states in MDP 

            if state == 0                          % If state == 0, state does not transition 
                P_h = 0 ;
                P_t = 0;

                continue
                  
            else                                  % If state !=0, functionine transition probilities 
                P_h = .1; 
                P_t = .9;
                
            end 

            v_state = V(state);                      % Store copy of initial value (at current state) for comparison later

            max_state_value = [-inf];                                               % Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

            for bet = [1:1:(state+1)]                                         % For every possible action (aka Bet) possible from the current state: Compute the 
                v = 0  ;                                                             % Action value for current action TAKEN from the current state                                                         % functionine Probability of Transition into tails ONCE action (aka bet) is taken 

                R_win = bet ;                                                        % functionine reward for Winning (aka Heads)
                R_loss = -bet ;                                                      % functionine reward for lossing (aka Tails) 

                win_state = state + bet ;                                            % Compute new state if HEADs
                loss_state = state - bet ;                                           % Compute new state if TAILs

                if win_state >= 11                                                 % Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                    win_state = 1;
                end 
                if loss_state <= 1
                    loss_state = 1;
                end

                v_win = P_h*(R_win + gamma*V(win_state)) ;                      % Compute the updated value of winning the coin toss
                v_loss = P_t*(R_loss + gamma*V(loss_state)) ;                   % Compute the updated value of lossing the coin toss 

                v = v_win + v_loss;                                                  % Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
                max_state_value(end+1) = v ;                                            % Append Q to list of action values for the CURRENT state 
            end
            
            V(state) = max(max_state_value);
            delta = max(delta, abs(v_state - V(state))) ; % Compute delta (precision error)
        end 
        
        if delta < theta                           % if precision error is less than precision parameter STOP policy evaluation 
            break
        end 
        
    end
    




    % Output Deterministic Policy: 
    V_func = V;

    for state = [0:1:(max_num_states+1)]            % Loop Over all states in MDP 

            if state == 0                          % If state == 0, state does not transition 
                P_h = 0 ;
                P_t = 0;

                continue
                
            else                                  % If state !=0, functionine transition probilities 
                P_h = .1 ;
                P_t = .9;
            end 

            action_values = [-inf];                                               % Initialize Action-Value function for CURRENT state NOTE: Q(0) = -infinity to garuntee argmax improvement does no select infeasible action   

            for bet = [1:1:(state+1)]                                         % For every possible action (aka Bet) possible from the current state: Compute the 
                Q = 0  ;                                                             % Action value for current action TAKEN from the current state                                                         % functionine Probability of Transition into tails ONCE action (aka bet) is taken 

                R_win = bet ;                                                        % functionine reward for Winning (aka Heads)
                R_loss = -bet ;                                                      % functionine reward for lossing (aka Tails) 

                win_state = state + bet;                                             % Compute new state if HEADs
                loss_state = state - bet ;                                           % Compute new state if TAILs

                if win_state >= 11                                                 % Bound win and loss states to prevent OUT OF BOUNDS index for value function 
                    win_state = 1;
                    
                end 
                if loss_state <= 1
                    loss_state = 1;
                    
                end

                v_win = P_h*(R_win + gamma*V_func(win_state))  ;                     % Compute the updated value of winning the coin toss
                v_loss = P_t*(R_loss + gamma*V_func(loss_state));                    % Compute the updated value of lossing the coin toss 

                Q = v_win + v_loss     ;                                             % Sum to find the action-value Q(s,a) in the CURRENT state under the CURRENT action (bet) 
                action_values(end + 1) = Q ;
            end 
            
            max_val, argmax = max(action_values)  ;  
            new_policy(state) = argmax;                            % Once all possible actions have been taken (for current state) select the MAX Action-Value 
    end 
end                                
            
            
            
     
            
            

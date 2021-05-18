% EEC 289A HW #6

% Game Rules: 
% Random Walk Dynamics (Walk Left: .5) (Walk Right: .5)
% 1-1000 State [Left -> Right]
% Episode: Initial State = 500, Terminal State = (1 & 1000)
% 
% Reward: 
%   Left Term Reward: -1 
%   Right Term Reward: 1 
%   ALL other Transitions : 0 

% Parameters 
theta = .000001;                           % Accuracy Param
gamma = 1.0;                              % Discount Factor
v_true = .5*ones(1,1002);                  % Initialize True Value Function

v_true(1002) = 0;                        
v_true(1) = 0;


% Iterative Policy Evaluation 
while true

    delta = 0;                         % Set Break Parameter to Zero  
    for s = 1:1:1002                   % Loop over ALL states
        
        v = v_true(s); 
        v_temp = 0; 
        for a = [-1, 1]            
            for step = 1:1:100
                
                s_prime = s + step*a;                
                s_next = max(min(s_prime,1002),1);
                
                r = reward_func(s_next); 
                v_temp = v_temp + .5*(1/100)*(r + gamma*v_true(s_next));

            end 

        end
        
        v_true(s) = v_temp;
        v_true(1002) = 0;                        
        v_true(1) = 0;
        
        
        delta = max(delta, abs(v - v_true(s)));            

    end
    
    if delta < theta
        break
    end 
end 


v_true(1002) = 0.921963997433083;                        
v_true(1) = -0.921956024324813;


figure();
plot(v_true);
xlabel("States");
ylabel("Value Scales");
title("1000-State Random Walk");


% Gradient Monte Carlo (w/Linear Function Approx) 

num_eps = 100000; 
alpha = 2*10^(-5);

W = zeros(1,10);

for eps = 1:1:num_eps
    delta = 0 ; 
    
    traj = generate_trajectory();     
    num_state_in_traj = length(traj(:,1));
    
    for steps = 1:1:(num_state_in_traj-1)
            W = W + alpha(G_t - value_function(state, W))*state;
    end 
    
    
    
%     delta = max(delta, abs(v - value_mc(s))); 
%     
%     if delta < theta_mc      
%         break 
%     end 
end 





%% Function Definitions 

function r = reward_func(state)

    if state == 1
        r = -1;
    elseif state == 1002 
        r = 1;     
    else
        r = 0 ; 
    end

end 

function r = mc_reward_func(state)

    if state == 1
        r = -1;
    elseif state == 12
        r = 1;     
    else
        r = 0 ; 
    end

end 

function traj = generate_trajectory()

    term_flag = false;                      % Initialize Termination Flag -> False
    temp_traj = [] ;                        % Create Empty Matrix for trajectory transitions
    
    s_prime = 5;                     % Initialize first state
    index = 1;                              % Trajectory Index
    
    while term_flag ~= true
        
        state = s_prime;
        action = take_random_action();          % Randomly Select First action
        s_prime = state + action;               % Compute New state given previous action 
        s_prime = max(min(s_prime,12),1);       % Saturate States at Limits of State Space    
        reward = mc_reward_func(s_prime);  
        
        temp_traj(index,:) = [state, action, reward, s_prime];  
        index = index + 1; 
         
        if s_prime == 1 || s_prime == 12
           term_flag = true;  
        end
        
    end 
    
    traj = temp_traj;
end 

function action = take_random_action()

    action_prob = rand();                   % Take first action according to initial policy
    
    if action_prob >=0 && action_prob <.5
        action = -1; 
    else
        action = 1; 
    end 
end

function v_hat = value_function(state, W)
    
    if state>=2 && state <101
        features = [1, 0,0,0,0,0,0,0,0,0];
        
    elseif state>=101 && state <201
        features = [0, 1,0,0,0,0,0,0,0,0];
        
    elseif state>=201 && state <301
        features = [0, 0,1,0,0,0,0,0,0,0];
        
    elseif state>=301 && state <401
        features = [0, 0,0,1,0,0,0,0,0,0];
        
    elseif state>=401 && state <501
        features = [0, 0,0,0,1,0,0,0,0,0];
        
    elseif state>=501 && state <601
        features = [0, 0,0,0,0,1,0,0,0,0];
        
    elseif state>=601 && state <701
        features = [0, 0,0,0,0,0,1,0,0,0];
        
    elseif state>=701 && state <801
        features = [0, 0,0,0,0,0,0,1,0,0];
        
    elseif state>=801 && state <901
        features = [0, 0,0,0,0,0,0,0,1,0];
        
    else
        features = [0, 0,0,0,0,0,0,0,0,1];
    end 

    v_hat = dot(W, features); 

end 

function Return = compute_MC_return(trajectory)

traj_len = length(trajectory(:,1));

    



end

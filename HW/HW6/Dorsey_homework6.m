% EEC 289A HW #6
% Jonathan Dorsey

% Game Rules: 
% Random Walk Dynamics (Walk Left: .5) (Walk Right: .5)
% 1-1000 State [Left -> Right]
% Episode: Initial State = 500, Terminal State = (1 & 1000)
% 
% Reward: 
%   Left Term Reward: -1 
%   Right Term Reward: 1 
%   ALL other Transitions : 0 

%% Gradient Monte Carlo Learning (RUN TIME: 32 seconds)

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

num_eps = 100000;                               % Number of Episodes to Train 
alpha = .00002;                              % Set Learning Rate 
W = zeros(1,10);                                % Initialize Feature Weights
gamma = 1; 



for eps = 1:1:num_eps                           % Iterate Over Episodes
    Gt = 0; 
    [traj, traj_length] = generate_trajectory();               % Generate Complete Episode Trajectory
    
    for steps = 1:1:(traj_length)               % Iterate Over each Episode Transition
        
        state = traj(steps,1);                  % Extract Current State 
        Gt = traj(end,3);         % Compute MC Learning based Return
        
        features = create_features(state);      % Use Current State to Define current "feature"

        W = W + alpha*(Gt - value_function(state, W))*features;
    end 
end 

value_mc = zeros(1,1000);
for state = 1:1:1000
    
    value_mc(state) = value_function(state, W);
    
end 

value_mc(1) = value_mc(2);

figure(1)
hold on
plot(value_mc, "b")
plot(v_true, "r")

xlabel("State")
ylabel("Value Scale")
title("Fig 9.1 Reproduction")
legend("Gradient MC","True Value Func.")

%% Semi-Gradient TD(0)(RUN TIME: 32 seconds)

% Use the SAME parameters as Problem #1 (According to HW Directions) 
num_eps = 100000;                               % Number of Episodes to Train 
alpha = .00002;                                 % Set Learning Rate 
W = zeros(1,10);                                % Initialize Feature Weights
gamma = 1; 


for eps = 1:1:num_eps                           % Iterate Over Episodes
    
    term_flag = false;
    s_prime = 500;

    while term_flag ~= true
    
        state = s_prime;
        action = take_random_action();          % Randomly Select First action
        s_prime = state + action;               % Compute New state given previous action 
        s_prime = max(min(s_prime,1002),1);       % Saturate States at Limits of State Space    
        reward = TD0_reward_func(s_prime);  

        features = create_features(state);      % Use Current State to Define current "feature"
        if s_prime == 1 || s_prime ==1002
            W = W + alpha*(reward + 0 - value_function(state, W))*features;

        else
            W = W + alpha*(reward + gamma*value_function(s_prime,W) - value_function(state, W))*features;

        end
        
        if s_prime <=1 || s_prime >=1002
            term_flag= true; 

        end 
    end
end 

value_td = zeros(1,1000);
for state = 1:1:1000
    
    value_td(state) = value_function(state, W);
    
end 
value_td(1) = value_td(2);

figure(2)
hold on
plot(value_mc, "k")
plot(value_td, "b")
plot(v_true, "r")

xlabel("State")
ylabel("Value Scale")
title("Problem #2 Semi-Gradient TD(0)")
legend("Gradient MC","Semi-Gradient TD(0)","True Value Func.")


%% Reproduce Figure 9.2 (RUN TIME: 90 seconds)

num_eps = 300000;                               % Number of Episodes to Train 
alpha = .00002;                              % Set Learning Rate 
W = zeros(1,10);                                % Initialize Feature Weights
gamma = 1; 


for eps = 1:1:num_eps                           % Iterate Over Episodes
    
    term_flag = false;
    s_prime = 500;

    while term_flag ~= true
    
        state = s_prime;
        action = take_random_action();          % Randomly Select First action
        s_prime = state + action;               % Compute New state given previous action 
        s_prime = max(min(s_prime,1002),1);       % Saturate States at Limits of State Space    
        reward = TD0_reward_func(s_prime);  

        features = create_features(state);      % Use Current State to Define current "feature"
        if s_prime == 1 || s_prime ==1002
            W = W + alpha*(reward + 0 - value_function(state, W))*features;

        else
            W = W + alpha*(reward + gamma*value_function(s_prime,W) - value_function(state, W))*features;

        end
        
        if s_prime <=1 || s_prime >=1002
            term_flag= true; 

        end 
    end
end 

value_td = zeros(1,1000);
for state = 1:1:1000
    
    value_td(state) = value_function(state, W);
    
end 
value_td(1) = value_td(2);



figure(3)
hold on
plot(value_td, "b")
plot(v_true, "r")

xlabel("State")
ylabel("Value Scale")
title("Fig 9.2 Reproduction")
legend("Semi-Gradient TD(0)","True Value Func.")


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

    if state <= 1
        r = -1;
    elseif state >= 1002
        r = 1;     
    else
        r = 0 ; 
    end

end 

function r = TD0_reward_func(state)

    if state <= 1
        r = -1;
    elseif state >= 1002
        r = 1;     
    else
        r = 0 ; 
    end

end 

function [new_traj, real_ind] = generate_trajectory()

    term_flag = false;                      % Initialize Termination Flag -> False
    traj = zeros(100000,4) ;                        % Create Empty Matrix for trajectory transitions
    
    s_prime = 500;                     % Initialize first state
    index = 1;                              % Trajectory Index
    
    while term_flag ~= true
        
        state = s_prime;
        action = take_random_action();          % Randomly Select First action
        s_prime = state + action;               % Compute New state given previous action 
        s_prime = max(min(s_prime,1002),1);       % Saturate States at Limits of State Space    
        reward = mc_reward_func(s_prime);  
        
        traj(index,:) = [state, action, reward, s_prime];  
        index = index + 1; 
         
        if s_prime <= 1 || s_prime >= 1002
           term_flag = true;  
        end
                
    end 
     
   real_ind = index -1;
   new_traj = traj(1:real_ind,:);
end 

function action = take_random_action()

    action_prob = rand();                   % Take first action according to initial policy
    
    if action_prob <.5
        dir = -1; 
    else
        dir = 1; 
    end 
    
    step_size = randi([1,100],1,1); 
    
    action = dir*step_size;
end

function v_hat = value_function(state, W)
    
    feat = create_features(state);
    
    v_hat = dot(W,feat); 

end 

function features = create_features(state)

        features = zeros(1,10);


    if state>=2 && state <101
        features(1) = 1; 
        
    elseif state>=101 && state <201
        features(2) = 1;   
        
    elseif state>=201 && state <301
        features(3) = 1;
        
    elseif state>=301 && state <401
        features(4) = 1;
        
    elseif state>=401 && state <501
        features(5) = 1;
        
    elseif state>=501 && state <601
        features(6) = 1;
        
    elseif state>=601 && state <701
        features(7) = 1;
        
    elseif state>=701 && state <801
        features(8) = 1;
        
    elseif state>=801 && state <901
        features(9) = 1;
        
    else
        features(10) = 1;
    end 
end 

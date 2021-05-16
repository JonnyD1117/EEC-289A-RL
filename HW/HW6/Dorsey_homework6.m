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
theta = .01;                           % Accuracy Param
gamma = 1;                              % Discount Factor
v_true = zeros(1,1002);                  % Initialize True Value Function
v_true = linspace(-1,1, 1002)     ;            % Initialize True Value Function1


% Policy Iteration 
while true

    delta = 0;                          % Set Break Parameter to Zero  
    for s = 2:1:1001                    % Loop over ALL states
        
        v = v_true(s);         
        for a = [-1, 1]            
            for step = 1:1:100
                
                s_prime = s + step*a;                
                s_next = max(min(s_prime,1002),1);
                
                r = reward_func(s_next);           
                v_true(s) = v_true(s) + .5*(1/100)*(r + v_true(s_next));

            end 

        end   
        
    delta = max(delta, abs(v - v_true(s)));            

    end
    
    if delta < theta
        break
    end 
end 

                v_true(1002) = 0;                        
                v_true(1) = 0;

disp("DONE")

% Gradient Monte Carlo (w/Linear Function Approx) 




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

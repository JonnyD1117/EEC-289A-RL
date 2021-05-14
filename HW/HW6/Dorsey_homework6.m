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
theta = .001;                           % Accuracy Param
gamma = 1;                              % Discount Factor
v_true = ones(1,1002);                  % Initialize True Value Function
v_true(1002) =0;                        % Make Sure Right terminal State value = 0 
v_true(1) =0;                           % Make Sure Left terminal State value = 0 


% Policy Iteration 
while 1==1

    delta = 0;                          % Set Break Parameter to Zero  
    for s = 2:1:1001                    % Loop over ALL states
        
        v = v_true(s); 
        
        for a = [1,2]
            
            [s_next, P] = state_transition(s,a); 
            
            if s_next == 1
                r = -1;
            elseif s_next == 1002
                r = 1;
            else
                r = 0; 
            end
            
            v_true(s) = .5*P*(r+gamma*v_true(s_next));
            v_true(1002) =0;                        
            v_true(1) =0;
            
            delta = max(delta, abs(v - v_true(s)));            
        end         
    end
    
    if delta < theta
        break
    end 
end 

disp("DONE")

% Gradient Monte Carlo (w/Linear Function Approx) 




%% Function Definitions 



function [s_prime, P_prob] = state_transition(state,action)


     move = randi(100,[1,1]);           % Randomly Select State to Transition to 
     
     if action == 1                 % Move Left
        s_prime = state - move;     % Update State Value
                
     end
     
     if action == 2                 % Move Right
         s_prime = state + move;    % Update State Value
     end                            
     
     
     
     
     
     
     
     
     
     if s_prime <2                  % Check if State is <= Left Term State
         s_prime = 1;
         
     elseif s_prime >1001           % Check if State is >= Right Term State
         s_prime = 1002;
         
     end 
    

end


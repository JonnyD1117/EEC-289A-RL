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
theta = .1;                           % Accuracy Param
gamma = 1;                              % Discount Factor
v_true = zeros(1,1002);                  % Initialize True Value Function
v_true(1002) =0;                        % Make Sure Right terminal State value = 0 
v_true(1) =0;                           % Make Sure Left terminal State value = 0 


% Policy Iteration 
while 1==1

    delta = 0;                          % Set Break Parameter to Zero  
    for s = 1:1:1002                    % Loop over ALL states
        
        v = v_true(s); 
        
        for a = [1,2]
            
            for step = 1:1:100
                
                if a == 1
                    s_prime = s - step;
                else
                    s_prime = s + step; 
                end 
                
                
                s_next = max(min(s_prime,1002),1);
            
            if s_next == 1
                r = -1;
            elseif s_next == 1002
                r = 1;
            else
                r = 0; 
            end
            
            v_true(s) = v_true(s) + .5*(1/100)*(r + gamma*v_true(s_next));

            v_true(1002) =0;                        
            v_true(1) =0;
            
            if v_true(s) == inf || v_true(s) == -inf
                disp(s)
                disp(a)
                disp(s_next)
                pause(100); 
            end 
                
            end 
            
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

function [s_prime] = state_transition(state, action)


     move = randi(100,[1,1]);       % Randomly Select State to Transition to 
     
     if action == 1                 % Move LEFT
        s_prime = state - move;     % Update State Value        
     end
     
     if action == 2                 % Move RIGHT
         s_prime = state + move;    % Update State Value
     end                                
     
     
     % Saturate the State So that they never exceed the terminal state
     % positions
     if s_prime <2                  % Check if State is <= Left Term State
         s_prime = 1;
         
     elseif s_prime >1001           % Check if State is >= Right Term State
         s_prime = 1002;
         
     end 
     
     
     P_prob = .005;                   % Default Transition Probability (given curren state & current action) 
     
     
     % If S' is within 100 of a terminal state compute Updated Transition
     % Probability. 
     
     if s_prime <= (1 + 100)         
        dist_term = 100 - s_prime; 
         
         if action == 1             
             P_prob = dist_term/200;             
         end 
           
     elseif s_prime >= (1002 - 100)         
         dist_term = 1002 - s_prime; 
         
         if action == 2             
             P_prob = dist_term/200;
         end 
         
         
     end 
    

end


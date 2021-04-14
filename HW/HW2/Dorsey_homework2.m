%% EEC 289a: Homework #2 
% Jonathan Dorsey 
% 4/12/2021



%% Problem #1.A ~ Agressive betting

max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .9 ;
P_t = .1;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;
                
        else 
                P_h = .9 ;
                P_t = .1;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = (state_val + bet_val) + 1;
            loss_state = (state_val - bet_val) + 1;

            R_win = bet_val;
            R_loss = -bet_val;
            
            
            if win_state >=10 
                win_state =1;
                
            end
            
                
            if loss_state <=0
                loss_state = 1;
                
            end
            
            

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #1: Max Bet")
disp(V)



%% Problem #1.B ~ Conservative Betting ($1) 

max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .9 ;
P_t = .1;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;
                
        else 
                P_h = .9 ;
                P_t = .1;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = (state_val + 1) + 1;
            loss_state = (state_val - 1) + 1;

            R_win = 1;
            R_loss = -1;
            
            
            if win_state >=11 
                win_state =1;
                
            end
            
                
            if loss_state <=1
                loss_state = 1;
                
            end
            
            

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #1: Conservative Bet")
disp(V)


%% Problem #1.C 


max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .9 ;
P_t = .1;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;       
        else 
                P_h = .9;
                P_t = .1;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;
            
            if state_val == 0 
                pi = 0;
            else 
                pi = 1.0/state_val;
            end 
            
                for bet = 1:1:(state_val)


                win_state = (state_val + bet) + 1;
                loss_state = (state_val - bet) + 1;

                R_win = bet;
                R_loss = -bet;


                    if win_state >=11 
                        win_state =1;

                    end


                    if loss_state <=1
                        loss_state = 1;

                    end



                v =  v + pi*P_h*(R_win + gamma*V(win_state)) + pi*P_t*(R_loss + gamma*V(loss_state));
            
                end 
            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #1: Uniform Random Bet")
disp(V)




%% Problem #2.A 



max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;
                
        else 
                P_h = .1 ;
                P_t = .9;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = (state_val + bet_val) + 1;
            loss_state = (state_val - bet_val) + 1;

            R_win = bet_val;
            R_loss = -bet_val;
            
            
            if win_state >=10 
                win_state =1;
                
            end
            
                
            if loss_state <=0
                loss_state = 1;
                
            end
            
            

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #2: Max Bet")
disp(V)



%% Problem #2.B ~ Conservative Betting ($1) 

max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;


counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;
                
        else 
                P_h = .1 ;
                P_t = .9;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = (state_val + 1) + 1;
            loss_state = (state_val - 1) + 1;

            R_win = 1;
            R_loss = -1;
            
            
            if win_state >=11 
                win_state =1;
                
            end
            
                
            if loss_state <=1
                loss_state = 1;
                
            end
            
            

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #2: Conservative Bet")
disp(V)


%% Problem #2.C 


max_num_states = 10;
V = zeros(1, 10) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)
        
        if state_ind == 1 
                P_h = 0; 
                P_t = 0;       
        else 
                P_h = .1;
                P_t = .9;
                
        end 

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;
            
            if state_val == 0 
                pi = 0;
            else 
                pi = 1.0/state_val;
            end 
            
                for bet = 1:1:(state_val)


                win_state = (state_val + bet) + 1;
                loss_state = (state_val - bet) + 1;

                R_win = bet;
                R_loss = -bet;


                    if win_state >=11 
                        win_state =1;

                    end


                    if loss_state <=1
                        loss_state = 1;

                    end



                v =  v + pi*P_h*(R_win + gamma*V(win_state)) + pi*P_t*(R_loss + gamma*V(loss_state));
            
                end 
            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter;
disp("Problem #2: Uniform Random Bet")
disp(V)





%% EEC 289a: Homework #2 
% Jonathan Dorsey 
% 4/12/2021



%% Problem #1.A 

max_num_states = 11;
V = zeros(1, 11) ;

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

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = min((state_val + bet_val), 10) + 1;
            loss_state = max((state_val - bet_val), 0) + 1;

            R_win = bet_val;
            R_loss = -bet_val;

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #1: Max Bet")
disp(V)



%% Problem #1.B 


max_num_states = 11;
V = zeros(1, max_num_states) ;

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

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);

            win_state = min((state_val + 1), 10) + 1;
            loss_state = max((state_val - 1), 0) + 1;

            R_win = 1;
            R_loss = -1;

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #1: $1 Bet")

disp(V)


%% Problem #1.C 




max_num_states = 11;
V = zeros(1, 11) ;

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

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            
            pi = 1.0/state_val;
            
            for bet = 1:1:state_val

                win_state = min((state_val + bet), 10) + 1;
                loss_state = max((state_val - bet), 0) + 1;

                R_win = bet;
                R_loss = -bet;

                v = v +  pi*P_h*(R_win + gamma*V(win_state)) + pi*P_t*(R_loss + gamma*V(loss_state));
            end 
            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #1: Uniform Random Bet")

disp(V)


%% Problem #2.A 

max_num_states = 11;
V = zeros(1, 11) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .1 ;
P_t = .9;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            bet_val = state_val;

            win_state = min((state_val + bet_val), 10) + 1;
            loss_state = max((state_val - bet_val), 0) + 1;

            R_win = bet_val;
            R_loss = -bet_val;

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #2: Max Bet")
disp(V)


%% Problem #2.B 

max_num_states = 11;
V = zeros(1, 11) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .1 ;
P_t = .9;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);

            win_state = min((state_val + 1), 10) + 1;
            loss_state = max((state_val - 1), 0) + 1;

            R_win = 1;
            R_loss = -1;

            v = P_h*(R_win + gamma*V(win_state)) + P_t*(R_loss + gamma*V(loss_state));

            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #2: $1 Bet")

disp(V)


%% Problem #2.C 


max_num_states = 11;
V = zeros(1, 11) ;

state_list = [0:1:(max_num_states-1)];

gamma = 1;

theta = .0001;
P_h = .1 ;
P_t = .9;

counter = 0;


while true

    delta = 0 ;
    counter  = counter + 1;

    for state_ind  = 1:1:(max_num_states)

            v = 0 ;
            v_state = V(state_ind);
            
            state_val = state_list(state_ind);
            
            pi = 1.0/state_val;
            
            for bet = 1:1:state_val

                win_state = min((state_val + bet), 10) + 1;
                loss_state = max((state_val - bet), 0) + 1;

                R_win = bet;
                R_loss = -bet;

                v = v +  pi*P_h*(R_win + gamma*V(win_state)) + pi*P_t*(R_loss + gamma*V(loss_state));
            end 
            V(state_ind) = v;
            delta = max(delta, abs(v_state - V(state_ind)));
            
    end 

        if delta < theta
            break 

        end 
end

counter
disp("Problem #2: Uniform Random Bet")

disp(V)




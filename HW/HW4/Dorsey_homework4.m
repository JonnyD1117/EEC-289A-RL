%% EEC 289A: Homework #4 
% Jonathan Dorsey 



%% Monte Carlo Learning 

clear all 
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%                           Initialize MC                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init_policy = zeros(21,10,2); 
new_policy = init_policy;


Q = zeros(21, 10, 2, 2);
N = zeros(21, 10, 2, 2);
Return = zeros(21, 10, 2, 2);
gamma = 1; 
dealer_policy = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%                           Run MC                      %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for eps = 1:1:500000
    
    traj = generate_blackjack_trajectory(init_policy_ace, dealer_policy);
    num_t = length(traj);
    
    G = 0; 
    
    for T = 1:1: num_t 
        
        state = traj{T}{1};
        action = traj{T}{2};
        reward = traj{T}{3};
        new_state = traj{T}{4};
        
        s1 = state(1); 
        s2 = state(2);
        s3 = state(3);
        
        G = gamma*G + reward;
        
%         Return(s1,s2,s3, (action+1)) = G; 
%         Q(s1, s2, s3, (action+1)) = mean(Return(s1, s2, s3, (action+1)))  ;

        N(s1, s2, 2, (action+1)) = N(s1, s2, 2, (action+1)) + 1; 
        Q(s1, s2, 2, (action+1)) = Q(s1, s2, 2, (action+1)) + (1/N(s1, s2, 2, (action+1)))*(G - Q(s1, s2, 2, (action+1)));      

     if Q(s1, s2, 2, 1) > Q(s1, s2, 2, 2)

                max_action = 1;

        else

                max_action = 0; 
        end

            new_policy_ace(s1, s2, 2) = max_action;


        end 
    

    
     init_policy_ace = new_policy_ace;
     eps
end 



%%
[X,Y] = meshgrid(1:1:10,1:1:21);
surf(X,Y,Q(:,:,1))

%%

pcolor(init_policy_ace(:,:,2))

xlabel('Dealer Showing')
ylabel('Player Sum')



%% Function Defitions: 

function shuf_deck = generate_deck()
% Generate Shuffled Deck

suit_value = [1,2,3,4,5,6,7,8,9,10,10,10,10]; 
new_deck = [suit_value, suit_value, suit_value, suit_value] ;
shuf_deck = new_deck(randperm(length(new_deck)));

end 

function final_trajectory = generate_blackjack_trajectory(policy, dealer_policy)

card_deck = generate_deck();                % Generate Shuffled Deck of Cards
trajectory = {};                            % Initialize Empty Trajectory (Cell Array) 

player_init_cards = [card_deck(1), card_deck(2)];               % Deal Player TWO cards from the top of the shuffled Deck
dealer_init_cards = [card_deck(3), card_deck(4)];               % Deal Dealer TWO cards from the shuffled Deck
delaer_value = card_deck(3) + card_deck(4);
card_counter = 5;                                               % Update Card Index

player_init_state = card_deck(1) + card_deck(2);                % Compute Player Initial State
dealer_init_state = card_deck(3);                               % Compute Dealer Initial State (Only one of the two cards drawn is shown)

usable_ace_bool = check_player_usable_ace(player_init_state);     % Check if it is possible for Player to have USABLE ACE 
usable_ace_state = sample_usable_ace(usable_ace_bool);            % IF Player CAN have USABLE ACE, Randomly Sample whether it IS a usable ACE   

state = [player_init_state, dealer_init_state, usable_ace_state];      % Initialize Initial State of BlackJack Trajectory
action = init_action();                                           % Randomly Select Initial Action


%     if action == 1                                                % If Initial Action is HIT (play through rest of game according to policy) 
% 
%          % Deal Players Cards (according to current Player POLICY)
%         [card_counter, trajectory, bust] = players_turn(card_deck, card_counter, state, policy, trajectory);
%         new_state = trajectory{end}{1};                             % Extract NEW state from trajectory 
% 
%     else                                                            % If Initial Action is STICK (end of player turn)
% 
%         trajectory{end + 1} = {state, 0, 0, state};
% 
%     end 
    
        [card_counter, trajectory, bust] = players_turn(card_deck, card_counter, state, policy, trajectory);
        new_state = trajectory{end}{1}; 
   
    % Deal Dealers Cards (according to fix Dealer Policy)
    if bust == 1                                                    % If Player ALREADY bust then Dealer already WON
        final_trajectory = trajectory; 
    else                                                            % IF Player DIDN'T bust then Dealer Still needs to Draw cards 

        [dealer_value, card_counter] = dealers_turn(card_deck, card_counter, dealer_init_cards, dealer_policy);     % Dealer Draws Cards until Dealer_value >=17 

        terminal_reward = who_won(new_state, dealer_value);         % Determine Who WON 
        trajectory{end+1} = {new_state, 0, terminal_reward, new_state};  % Return Trajectory
        final_trajectory = trajectory;
        
    end 




end

function bool_check = check_dealer_soft_seventeen(dealer_cards)

card_1 = dealer_cards(1); 
card_2 = dealer_cards(2);

    if card_1 == 1 && card_2 == 7

        bool_check = 1;

    elseif card_1 == 7 && card_2 == 1

        bool_check = 1;

    else 
        bool_check = 0; 
    end
end

function bool_check = check_player_usable_ace(player_hand_value)
% Given a Players Current Value is useable ACE Possible   

    if player_hand_value <=10       % If Players Hand is valued above 10 then ACE is NOT useable
    
        bool_check = 1; 
    else
       
        bool_check = 0; % FALSE No USeable ACE
   end 
end 

function usable_ace_state = sample_usable_ace(usable_ace_bool)


    if usable_ace_bool == 1

        p = rand(); 

        if p <= .5
            usable_ace_state = 2 ;

        else 
            usable_ace_state = 1 ;
        end 
    else 
        usable_ace_state = 2;
    end 


end 

function action = init_action()

p = rand(); 

    if p >=5
        action = 0;
    else
        action = 1;

    end 

end 

function reward = who_won(state, dealer_value)

player_value = state(1); 

    if player_value > 21
        R = -1; 

    elseif dealer_value >21 && player_value < 21
        R = 1;

    elseif player_value > dealer_value
        R = 1;

    elseif dealer_value > player_value
        R = -1;

    elseif dealer_value == player_value
        R = 0;
    end
    
    reward = R;
end 

function [card_counter, trajectory, bust] = players_turn(card_deck, card_counter, init_state, policy, trajectory)
    
    cur_state = init_state;                             % Initialize Current State    
    new_state = init_state;                             % Initialize New State 
    
    bust = 0;                                           % Set BUST flag to 0 

    
    while true                                          % Loop Until Policy Sticks or Player BUSTs
        
        s1 = cur_state(1);                               % Define current Player Value
        s2 = cur_state(2);                              % Define current Dealer Showing Value
        s3 = cur_state(3);                              % Define current Player Usable ACE
        
        player_value = s1;
        dealer_value = s2;
        usable_ace_state = s3;
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%                       PLAYER HITS                             %%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if policy(s1, s2, s3) == 1                      % If Policy HITS (draw new card)
            new_card_value = card_deck(card_counter);   % Draw a new card from the deck 
            card_counter = card_counter + 1;            % Increment Card Counter
        
            if new_card_value == 1                      % Check if Player drew an ACE
                    
                usable = check_player_usable_ace(player_value);        % Check if ACE is usable 
            
                if usable == 1                          % If ACE is usable 
                    new_card_value = 11;                % ACE == 11
                    usable_ace_state = 1;               % Change usable Ace state to True
                end 
                               
            end 
            
            player_value = player_value + new_card_value;   % Update Player Value 
            new_state = [player_value, dealer_value, usable_ace_state];   % Define NEW state of the MDP

            if player_value > 21                        % If Player BUSTs then stop playing and get reward of R = -1
                bust = 1;
                trajectory{end + 1} = {cur_state, 1, -1, new_state}; % Update MDP Trajectory 
                break                                   % BREAK from WHILE loop if BUST 
            else
                trajectory{end + 1} = {cur_state, 1, 0, new_state}; % Update MDP Trajectory                  
                cur_state = new_state;                  % Update Current State Definition
            end
            
        end 
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%                       PLAYER STICK                            %%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if policy(s1, s2, s3) == 0                      % If Policy STICKS (break loop & do not update state) 

            trajectory{end + 1} = {cur_state, 0, 0, cur_state}; % Update MDP Trajectory     
            break                                       % BREAK from WHILE loop 
        end 
    end 



end 

function [dealer_value, card_counter] = dealers_turn(card_deck, card_counter, dealer_cards, dealer_policy)

dealer_value = dealer_cards(1) + dealer_cards(2);               % Dealers Initial Card Value
soft_17_check  = check_dealer_soft_seventeen(dealer_cards);     % Check if Initial Dealer Cards are Soft-17


if dealer_policy == 1                                           % Under Dealer CASE #1
    
    if soft_17_check == 1                                       % IF Dealer has Soft-17: HIT                       
        new_card_val = card_deck(card_counter);                 % Draw Card From Deck
        card_counter = card_counter + 1;                        % Increment Card Counter 
        dealer_value = 17 +  new_card_val;                      % IF dealer has Soft-17 update value
    
    elseif soft_17_check == 0 && dealer_value >= 17             % IF Dealer Doesn't Have Soft-17 BUT has a value >=17: STICK
        dealer_value = dealer_value;
        
    else                                                        % IF Dealer does NOT have Soft-17 but has value < 17 : HIT
        
        [dealer_value, card_counter] = dealer_draws_card(card_deck, card_counter, dealer_value);
    end 
    
else % dealer_polcy == 2 
    
    if soft_17_check == 1                                       % IF Dealer has Soft-17: STICK                       
        dealer_value = dealer_value; 
        
    elseif soft_17_check == 0 && dealer_value >= 17             % IF Dealer Doesn't Have Soft-17 BUT has a value >=17: STICK
        dealer_value = dealer_value;
        
    else                                                        % IF Dealer does NOT have Soft-17 but has value < 17; HIT
        
        [dealer_value, card_counter] = dealer_draws_card(card_deck, card_counter, dealer_value);
    end     
    
    
end 

% Dealer Policy == 1 

    % Check if Dealer Initial Cards == Soft-17
    % IF: True : HIT
    % ELSEIF: dealer_value >= 17 : STICK
    % ELSE: 
    
        % WHILE: dealer_value < 17: HIT             
            % Check if Dealer has USABLE ACE
            
            % IF ACE is usable: Check if new_dealer_val > 17 (AKA soft-18 or greater) STICK
            % ELSE: HIT
                
            % IF ACE is NOT usable: 

end 

function [dealer_value, card_counter] = dealer_draws_card(card_deck, card_counter, dealer_value)

   while dealer_value < 17                                      % While Dealer has < 17 Keep Drawing Cards
       
       new_card_value = card_deck(card_counter);                % Draw NEW card from deck
       card_counter = card_counter + 1;                          % Increment Deck Counter
       
       if new_card_value == 1                                   % If new card is an ACE
           
            if dealer_value <= 10                               % Test Whether ACE is Usable
                
                usable = 1; 
                new_card_value = 11;                            % IF usable, card value == 11
            else 
                usable = 0;                                     % ELSE card value == 1
            end 
       end 
       
       dealer_value = dealer_value + new_card_value;            % Update Dealer Value
       
           
           if dealer_value > 17                                 % Does Dealer have > Soft-17
               break                                            % If Dealer has > Soft-17 then BREAK Loop 
           end            
           
       
   end 

end 




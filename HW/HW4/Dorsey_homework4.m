


%% EEC 289A: Homework #4 
% Jonathan Dorsey 



%% Black Jack Simulator

dealer_case = 1; 
current_player_policy = ones(21,10,2);


trajectory = generate_blackjack_trajectory(current_player_policy, dealer_case)


%% Monte Carlo Learning 













%% Function Defitions: 

function shuf_deck = generate_deck()
% Generate Shuffled Deck

suit_value = [1,2,3,4,5,6,7,8,9,10,10,10,10]; 
new_deck = [suit_value, suit_value, suit_value,suit_value] ;
shuf_deck = new_deck(randperm(length(new_deck)));

end 

function trajectory = generate_blackjack_trajectory(current_player_policy, dealer_case)

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

cur_state = [player_init_state, dealer_init_state, usable_ace_state];      % Initialize Initial State of BlackJack Trajectory
new_state = cur_state; 

% Deal Players Cards (according to current Player POLICY)

   
% Deal Dealers Cards (according to fix Dealer Policy)

    

% Determine Who WON 
    terminal_reward = who_won(new_state, dealer_value);

% Return Trajectory 

trajectory{end+1} = {cur_state, 0, terminal_reward, new_state};

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
       
        bool_check = 0;
   end 
end 

function usable_ace_state = sample_usable_ace(usable_ace_bool)


    if usable_ace_bool == 1

        p = rand(); 

        if p <= .5
            usable_ace_state = 0 ;

        else 
            usable_ace_state = 1 ;
        end 
    else 
        usable_ace_state = 0;
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
        
        s1 = cur_state(1);                              % Define current Player Value
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

function [] = dealers_turn(card_deck, card_counter, dealer_cards, dealer_policy)

% General Dealer Policy: STICK if dealer value >= 17

% Check if Dealer has Soft-17 




% Dealer Policy == 1 

    % Check if Dealer Initial Cards  == Soft-17
    % IF: True : HIT
    % ELSEIF: dealer_value >= 17 : STICK
    % ELSE: 
    
        % WHILE: dealer_value < 17: HIT             
            
            % IF Dealer Value < 17: HIT
            % ELSEIF Dealer Value == Soft-17 HIT
            % ELSE: STICK




            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            

% Dealer Policy == 2

    % Check if Dealer Initial Cards  == Soft-17
    % IF: True : Stick
    
    
    % Dealer Draws a Card 
    % Check if Dealer has Usable ACE


    % IF Dealer Value < 17: HIT
    % ELSEIF Dealer Value == Soft-17 STICK
    % ELSE: STICK




































    

    soft_17 = check_dealer_soft_seventeen(dealer_init_cards);

    if dealer_case == 1             % HIT on soft-17
        
        if soft_17 == 1
            
            dealer_value = dealer_value + card_deck(card_counter);
            
        else
            
            [dealer_value, card_counter] = dealer_turn(card_deck, card_counter, dealer_init_cards);
            
        end 
        
    
    end     
        
    if dealer_case == 2             % STICK on soft-17
        
        if soft_17 == 1
            dealer_value = dealer_value;
        else
            [dealer_value, card_counter] = dealer_turn(card_deck, card_counter, dealer_init_cards);
        end     
    end 



end 





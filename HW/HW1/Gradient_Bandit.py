import numpy as np 
import matplotlib.pyplot as plt
import time
from random import choices, choice

def bandit_prob(action_taken, rw_mean_list):
	
	# Take Actual Mean from reward Mean, and use that to generate the normally distributed reward for the current action being taken
	reward_mean = rw_mean_list[action_taken]
	reward = np.random.normal(reward_mean, 1)
	
	return reward

def soft_max(H_pref, num_act):

	pi = (np.exp(H_pref))/(np.sum(np.exp(H_pref)))

	return pi 

	
if __name__ == '__main__':

	t = time.time()
	
	k = 10 			      # Number of bandits
	num_runs = 1000 	  # Number of runs taken for a single bandit problem 
	num_trial = 2000	  # Number of bandit problems total  

	alpha  = .1 		  # Step Size
	pi = None
	act_list = np.arange(k)	  # List of the action possible

	reward_list = np.zeros((num_trial, num_runs))	# Initialize Reward List
	avg_reward = np.zeros(num_runs)					# Initialize Average Reward List
	opt_act = np.zeros((num_trial, num_runs))
	opt_act_mean = np.zeros(num_runs)	

	for i in range(num_trial):		# Iterate over the total number of bandit trial

		if i % 100 == 0: 
			print("Num Trial:", i)

		H = np.zeros(k)
		pi = soft_max(H, k)
		Rt = 0

		actual_rewards = np.random.normal(4, 1, k)	 # Use normal dist to set "actual" reward values for each bandit "trial"

		for j in range(num_runs):		# Iterate over the total number of runs for single bandit problem
				
			action_num = choices(act_list, pi)	
			R = bandit_prob(action_num, actual_rewards)
			Rt = np.mean(reward_list[i,:])

			if action_num == np.argmax(H): 
				opt_act[i,j] = 1
			else:
				opt_act[i,j] = 0 


			for a in range(k): 
				if a == action_num: 
					H[a] = H[a] + alpha*(R - Rt)*(1 - pi[a])
				else:
					H[a] = H[a] - alpha*(R - Rt)*pi[a]

			pi = soft_max(H, k)						# Action Probabilities
			reward_list[i,j] = R	

		for run in range(len(avg_reward[:])): 
			avg_reward[run] = np.mean(reward_list[:,run]) 
			opt_act_mean[run] = np.mean(opt_act[:,run])
	# print(avg_reward)

	plt.plot(avg_reward)
	plt.plot(opt_act_mean)
	plt.show()


	
				
			
		
				
				  
			
				
					
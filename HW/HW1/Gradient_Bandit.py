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

	pi = (np.exp(H_pref - np.max(H_pref)))/(np.sum(np.exp(H_pref- np.max(H_pref))))

	return pi 

	
if __name__ == '__main__':

	t = time.time()
	
	k = 10 			      # Number of bandits
	num_runs = 1000 	  # Number of runs taken for a single bandit problem 
	num_trial = 2000	  # Number of bandit problems total  

	alpha  = .1 		  # Step Size
	act_list = np.arange(k)	  # List of the action possible

	avg_reward = np.zeros((4,num_runs))					# Initialize Average Reward List
	opt_act_mean = np.zeros((4,num_runs))	

	alpha_list = [.1, .1, .4, .4 ]
	Rt_flag = None

	for ind, alpha in enumerate(alpha_list): 

		if ind == 1: 

			Rt_flag = True

		if ind == 3: 

			Rt_flag = True

		opt_act = np.zeros((num_trial, num_runs))
		reward_list = np.zeros((num_trial, num_runs))	# Initialize Reward List


		for i in range(num_trial):		# Iterate over the total number of bandit trial

			if i % 100 == 0: 
				print("Num Trial:", i)

			H = np.zeros(k)
			pi = soft_max(H, k)
			Rt = 0

			actual_rewards = np.random.normal(0, 1, k)	 # Use normal dist to set "actual" reward values for each bandit "trial"

			for j in range(num_runs):		# Iterate over the total number of runs for single bandit problem
					
				action_num = choices(act_list, pi)[0]	
				R = bandit_prob(action_num, actual_rewards)

				if Rt_flag: 
					Rt = np.mean(reward_list[i,:])

				elif Rt_flag is False: 
					Rt = 0

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

			for run in range(len(avg_reward[0, :])): 
				avg_reward[ind, run] = np.mean(reward_list[:,run]) 
				opt_act_mean[ind, run] = np.mean(opt_act[:,run])
		
		# print(avg_reward)
		# plt.plot(avg_reward)
	
	plt.plot(opt_act_mean[0,:])
	plt.plot(opt_act_mean[1,:])
	plt.plot(opt_act_mean[2,:])
	plt.plot(opt_act_mean[3,:])
	
	# plt.plot(avg_reward[0,:])
	# plt.plot(avg_reward[1,:])
	# plt.plot(avg_reward[2,:])
	# plt.plot(avg_reward[3,:])

	plt.xlabel("Steps")
	plt.ylabel("Optimal Actions") 
	plt.legend()
	plt.show()


	
				
			
		
				
				  
			
				
					
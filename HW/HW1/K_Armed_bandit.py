import numpy as np 
import matplotlib.pyplot as plt
import time

def bandit_prob(action_taken, rw_mean_list):
	# Take Actual Mean from reward Mean, and use that to generate the normally distributed reward for the current action being taken
	reward_mean = rw_mean_list[action_taken]
	
	reward = np.random.normal(reward_mean, 1)
	
	return reward
	
	

if __name__ == '__main__':

	t = time.time()
	
	k = 10 						  # Number of bandits
	num_runs = 1000 	  # Number of runs taken for a single bandit problem 
	num_trial = 2000		# Number of bandit problems total  
	# eps = .1 						# E-Greedy Parameter

	eps_list = [0, .1, .01] 


	reward_list = np.zeros((num_trial, num_runs))
	avg_reward = np.zeros((len(eps_list), num_runs))
	
	print(reward_list.shape)

	for ep_count, eps in enumerate(eps_list):
	
		for i in range(num_trial):		# Iterate over the total number of bandit trial
			Q = np.zeros(k)			# Initialize Action Values to zeros 
			N = np.zeros(k) 		 # Initialize "number of times bandit has been visited" to zeros
		
			actual_rewards = np.random.normal(0,1, k)	 # Use normal dist to set "actual" reward values for each bandit "trial"
			
			for j in range(num_runs):		# Iterate over the total number of runs for single bandit problem
				
				eps_prob = np.random.uniform(0,1) 	# Compute epsilon probability for action selection 
				
				if j  ==0: 
					action_num = np.random.randint(1,k)
				
				elif eps_prob > eps:
					# if epsilon probability is greater than the epsilon parameter select action with max value 									
					action_num = np.argmax(Q)
					
				else:
					# if epsilon probaility is less than the epsilon parameter select random action 
					action_num = np.random.randint(1,k)
				
				R = bandit_prob(action_num, actual_rewards)
				
				reward_list[i,j] = R			
								
				N[action_num] += 1
				Q[action_num] += (1./N[action_num])*(R - Q[action_num])
				
		for run in range(len(avg_reward[0,:])): 
			avg_reward[ep_count, run] = np.mean(reward_list[:,run]) 

	eps1 = avg_reward[0, :]
	eps2 = avg_reward[1, :]
	eps3 = avg_reward[2, :]

	# do stuff
	elapsed = time.time()-t

	print("Total Time Elapsed:", elapsed)

	plt.plot(eps1)
	plt.plot(eps2)
	plt.plot(eps3)

	plt.title("10-Armed Bandit")
	plt.xlabel("Steps")
	plt.ylabel("Average Reward")
	plt.legend(["epsilon: 0","epsilon: 0.1","epsilon: 0.01"])
	plt.show()



	
				
			
		
				
				  
			
				
					
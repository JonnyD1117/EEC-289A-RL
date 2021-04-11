    delta = max(delta, np.abs(v_state - V[state]))

                if delta < theta: 
                    term_flag = True
                    break 
from keras.models import Sequential
from keras.layers.core import Dense, Activation
from keras.optimizers import RMSprop,Adam
import numpy as np
import pandas as pd
import itertools
from random import choice
from keras.models import load_model

def use_predicted_probability(predicted_classs):
	
	if predicted_classs == 0:
		hand_to_play = (0, 1, 2)
		
	elif predicted_classs == 1:
		hand_to_play = (0, 1, 3)
		
	elif predicted_classs == 2:
		hand_to_play = (0, 1, 4)
		
	elif predicted_classs == 3:
		hand_to_play = (0, 2, 1)
		
	elif predicted_classs == 4:
		hand_to_play = (0, 2, 3)
		
	elif predicted_classs == 5:
		hand_to_play = (0, 2, 4)
		
	elif predicted_classs == 6:
		hand_to_play = (0, 3, 1)
		
	elif predicted_classs == 7:
		hand_to_play = (0, 3, 2)
		
	elif predicted_classs == 8:
		hand_to_play = (0, 3, 4)
		
	elif predicted_classs == 9:
		hand_to_play = (0, 4, 1)
		
	elif predicted_classs == 10:
		hand_to_play = (0, 4, 2)
		
	elif predicted_classs == 11:
		hand_to_play = (0, 4, 3)
		
	elif predicted_classs == 12:
		hand_to_play = (1, 0, 2)
		
	elif predicted_classs == 13:
		hand_to_play = (1, 0, 3)
		
	elif predicted_classs == 14:
		hand_to_play = (1, 0, 4)
		
	elif predicted_classs == 15:
		hand_to_play = (1, 2, 0)
		
	elif predicted_classs == 16:
		hand_to_play = (1, 2, 3)
		
	elif predicted_classs == 17:
		hand_to_play = (1, 2, 4)
		
	elif predicted_classs == 18:
		hand_to_play = (1, 3, 0)
		
	elif predicted_classs == 19:
		hand_to_play = (1, 3, 2)
		
	elif predicted_classs == 20:
		hand_to_play = (1, 3, 4)
		
	elif predicted_classs == 21:
		hand_to_play = (1, 4, 0)
		
	elif predicted_classs == 22:
		hand_to_play = (1, 4, 2)
		
	elif predicted_classs == 23:
		hand_to_play = (1, 4, 3)
		
	elif predicted_classs == 24:
		hand_to_play = (2, 0, 1)
		
	elif predicted_classs == 25:
		hand_to_play = (2, 0, 3)
		
	elif predicted_classs == 26:
		hand_to_play = (2, 0, 4)
		
	elif predicted_classs == 27:
		hand_to_play = (2, 1, 0)
		
	elif predicted_classs == 28:
		hand_to_play = (2, 1, 3)
		
	elif predicted_classs == 29:
		hand_to_play = (2, 1, 4)
		
	elif predicted_classs == 30:
		hand_to_play = (2, 3, 0)
		
	elif predicted_classs == 31:
		hand_to_play = (2, 3, 1)
		
	elif predicted_classs == 32:
		hand_to_play = (2, 3, 4)
		
	elif predicted_classs == 33:
		hand_to_play = (2, 4, 0)
		
	elif predicted_classs == 34:
		hand_to_play = (2, 4, 1)
		
	elif predicted_classs == 35:
		hand_to_play = (2, 4, 3)
		
	elif predicted_classs == 36:
		hand_to_play = (3, 0, 1)
		
	elif predicted_classs == 37:
		hand_to_play = (3, 0, 2)
		
	elif predicted_classs == 38:
		hand_to_play = (3, 0, 4)
		
	elif predicted_classs == 39:
		hand_to_play = (3, 1, 0)
		
	elif predicted_classs == 40:
		hand_to_play = (3, 1, 2)
		
	elif predicted_classs == 41:
		hand_to_play = (3, 1, 4)
		
	elif predicted_classs == 42:
		hand_to_play = (3, 2, 0)
		
	elif predicted_classs == 43:
		hand_to_play = (3, 2, 1)
		
	elif predicted_classs == 44:
		hand_to_play = (3, 2, 4)
		
	elif predicted_classs == 45:
		hand_to_play = (3, 4, 0)
		
	elif predicted_classs == 46:
		hand_to_play = (3, 4, 1)
		
	elif predicted_classs == 47:
		hand_to_play = (3, 4, 2)
		
	elif predicted_classs == 48:
		hand_to_play = (4, 0, 1)
		
	elif predicted_classs == 49:
		hand_to_play = (4, 0, 2)
		
	elif predicted_classs == 50:
		hand_to_play = (4, 0, 3)
		
	elif predicted_classs == 51:
		hand_to_play = (4, 1, 0)
		
	elif predicted_classs == 52:
		hand_to_play = (4, 1, 2)
		
	elif predicted_classs == 53:
		hand_to_play = (4, 1, 3)
		
	elif predicted_classs == 54:
		hand_to_play = (4, 2, 0)
		
	elif predicted_classs == 55:
		hand_to_play = (4, 2, 1)
		
	elif predicted_classs == 56:
		hand_to_play = (4, 2, 3)
		
	elif predicted_classs == 57:
		hand_to_play = (4, 3, 0)
		
	elif predicted_classs == 58:
		hand_to_play = (4, 3, 1)
		
	else:
		hand_to_play = (4, 3, 2)
		
	return hand_to_play


def convert_card_list(card_list_input):
	out_array = []
	for card in card_list_input:
		if card== 'buster':
			out_array.append(1)

		if card== 'arts':
			out_array.append(2)
		if card== 'quick':
			out_array.append(3)
	#print('outarray: ',out_array)
	out_array2 = np.reshape(np.asarray(out_array), (1, 5))
	return 	out_array2
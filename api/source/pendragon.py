import numpy as np
#from grab_screen import grab_screen
import cv2
import time
import os

import torch
import torch.nn as nn
import torch.optim as optim
from torch.optim import lr_scheduler
import numpy as np
import torchvision
from torchvision import datasets, models, transforms
import matplotlib.pyplot as plt
from torch.autograd import Variable
import PIL
import torch.nn.functional as F
#import pyautogui
import pandas as pd

from utils import get_card_raw, image_loader, get_predicted_class
from utils import check_for_chain,brave_chain_checker 
from utils import get_cards,brave_chain_check,pick_cards_from_card_list
from utils import detect_start_turn, rl_bot_card_choice
from utils import detect_round_counter

import argparse



# def main(skill_usage_list):
# 	skill_usage_num = 0
# 	turn_counter = 0
# 	# np_barrage determies if 
# 	# the bot will try to use all the NPs every turn
# 	# most of the time it will use it after it has finished
# 	# all the commands in the battle plan.
# 	# the other way is if no battle plan is provided. 
# 	# and the first item in the skill usage list is `brute_force`
# 	# then from the get go it will use NPs. This is the basic
# 	# bot behavior from before the updates. 
# 	if skill_usage_list[0] == 'brute_force':
# 		np_barrage = True
# 	else:
# 		np_barrage = False
# 	try:
# 		while(1):
# 			time.sleep(3)
# 			#print('')
# 			#keypressed = input("Press 1 to continue... q to quit ")
# 			turn_start = detect_start_turn()
# 			print('testing_turn',turn_start)			
# 			
# 			
# 			if turn_start == True:
# 				# round number testing, doing a 2 out of 3 type thing
# 				# idea is to try to avoid false positives
# 				# 
# 				round_number_list = []
# 				for i in range(3):
# 					round_number_list.append(detect_round_counter())
# 
# 				round_number = max(set(round_number_list), key=round_number_list.count)
# 
# 				print(round_number,round_number_list)
# 				turn_counter+=1 #still tracking turn counter based on detecting the attack button				
# 
# 				#grab the current string for actions. 
# 				if skill_usage_num >= len(skill_usage_list):
# 					skill_list1 = ['out_of_range_string']
# 					np_barrage = True
# 				else:
# 					string_skills = skill_usage_list[skill_usage_num]
# 					skill_list1 = string_skills.split(',')
# 				
# 				# for testing round number against the battle plan's number
# 				print(round_number,skill_list1[0],round_number == skill_list1[0])
# 				# if the round number and the battle plan round number are equal then
# 				# then execute the skills and nps
# 				if round_number == skill_list1[0]:
# 					
# 					for command_ in skill_list1[1:]:
# 						
# 						command = command_.split('_')[0]
# 						if len(command_.split('_')) == 1:
# 							sleep_seconds = 3.0
# 						else:
# 							sleep_seconds = float(command_.split('_')[1])
# 						print(command)
# 						pyautogui.moveTo(skill_dict[command][0],skill_dict[command][1])
# 						pyautogui.click()
# 						time.sleep(sleep_seconds)
# 					skill_usage_num+=1
# 				# if they are not equal then press the attack button and gogogo
# 				# if np_barrage is True then the bot will try to use all the NPs
# 				elif round_number != skill_list1[0]:
# 					pyautogui.moveTo(skill_dict['attack'][0],skill_dict['attack'][1])
# 					pyautogui.click()
# 					time.sleep(2.0)
# 
# 					if np_barrage is True:
# 						click_location("NP1")
# 						click_location("NP2")
# 						click_location("NP3")
# 				# this small bit at the end is the previous core for Pendragon Alter
# 				# basically get the screen capture and feed the card lists to the
# 				# RL bot. I have more or less disabled the saimese nn for the time being
# 				screen = grab_screen_fgo()
# 				card_list, brave_chain_raw_img_list = get_cards(screen)
# 				
# 				#brave_chain_bool = False
# 				#if brave_chain_bool == True:
# 				#	print('brave')
# 				#	pick_cards_from_card_list(card_list_brave)
# 
# 				
# 				print('rl_bot')
# 				rl_bot_card_choice(card_list)
# 
# 			else:
# 				continue
# 
# 	except KeyboardInterrupt:
# 		print('interrupted!')


####################################################
#parse the skill dictionary and battle plans
####################################################
skill_dat = pd.read_csv('skill_sheet.csv')
skill_dict = {}
for index,row in skill_dat.iterrows():
	skill = row['shorthand']
	coord = [row['x1'],row['y1']]
	
	skill_dict[skill] = coord

parser = argparse.ArgumentParser(description='specify battle plan for pendragon')
parser.add_argument('-bp', dest = 'battle_plan',type=str, default='brute_force',
                    help='csv containing the battle plan, default is `brute_force` where no skills will be used')

args = parser.parse_args()

if args.battle_plan == 'brute_force':
	skill_usage_list=['brute_force']
else:
	skill_usage_list = []
	skill_dat2 = pd.read_csv(args.battle_plan)
	for index,row in skill_dat2.iterrows():
		battle = row['battle']
		plan = row['plan']
		skill_usage_list.append(battle+','+plan)
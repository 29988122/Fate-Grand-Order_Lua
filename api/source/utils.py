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
from siamese_net_model import SiameseNetwork
import torch.nn.functional as F
#import pyautogui
import torch.cuda

from keras.models import load_model

from reinforcement_model_helper import convert_card_list, use_predicted_probability
# grab_screen_fgo is location of FGO itself
#need to define, card location, attack button location, turn counter location, which are all subsets of the screen_fgo function 

# screen crop location is 
imsize = 224


device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")


loader = transforms.Compose([transforms.Resize((imsize,imsize)),
	#transforms.CenterCrop(imsize), 
	transforms.ToTensor(),
	transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])])

#for brave chain
scale=transforms.Compose([transforms.Resize((224,224)),
							transforms.ToTensor()
							 ])
## each of the card slots should be in a lookup
def get_card_raw(card_slot, raw_image):
	if card_slot == 1:
		sliced = raw_image[205:310, 27:109]
		#cv2.imshow("cropped", sliced)
		cv2.waitKey(0)

	elif card_slot == 2:
		sliced = raw_image[205:310, 156:240]
		#cv2.imshow("cropped", sliced)
		#cv2.waitKey(0)

	elif card_slot == 3:
		sliced = raw_image[205:310, 287:370]
		#cv2.imshow("cropped", sliced)
		#cv2.waitKey(0)

	elif card_slot == 4:
		sliced = raw_image[205:310, 415:500]
		#cv2.imshow("cropped", sliced)
		#cv2.waitKey(0)

	elif card_slot == 5:
		sliced = raw_image[205:310, 545:634]
		#cv2.imshow("cropped", sliced)
		#cv2.waitKey(0)

	#elif card_slot == "NP1":
	#	sliced = raw_image[89:200, 232:313]

	#elif card_slot == "NP2":
	#	sliced = raw_image[89:200, 362:444]

	#elif card_slot == "NP3":
	#	sliced = raw_image[89:200, 494:571]

	return sliced

def image_loader(image_name):
	"""load image, returns cuda tensor"""
	image = PIL.Image.fromarray(image_name)
	image = loader(image).float()
	image = Variable(image, requires_grad=True)
	image = image.unsqueeze(0)  #this is for VGG, may not be needed for ResNet
	return image.cuda()  #assumes that you're using GPU


def get_predicted_class(image_array):
	labels = { 0:'arts', 1:'buster',2:'quick'}
	#load model architecture
	card_resnet = models.resnet50(pretrained=False)
	num_ftrs = card_resnet.fc.in_features
	card_resnet.fc = nn.Linear(num_ftrs, 3)
	card_resnet = card_resnet.to(device)
	card_resnet.load_state_dict(torch.load('models/card_resnet50.pth'))
	card_resnet.eval()

	image = image_loader(image_array)
	y_pred = card_resnet(image)
	label_out = labels[y_pred.cpu().data.numpy().argmax()]
	del card_resnet
	return label_out, y_pred


# def click_location(loc_name):
# 	#for the NPs
# 	sleep_time_ = .01
# 	if loc_name == 'NP1':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(998,508)
# 		pyautogui.click()
# 	elif loc_name == 'NP2':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(1105,508)
# 		pyautogui.click()
# 	elif loc_name == 'NP3':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(1220,508)
# 		pyautogui.click()
# 
# 
# 	if loc_name == 'c1':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(844, 662)
# 		pyautogui.click()
# 	if loc_name == 'c2':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(978, 662)
# 		pyautogui.click()
# 	if loc_name == 'c3':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(1108, 662)
# 		pyautogui.click()
# 	if loc_name == 'c4':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(1235, 662)
# 		pyautogui.click()
# 	if loc_name == 'c5':
# 		time.sleep(sleep_time_)
# 		pyautogui.moveTo(1367, 662)
# 		pyautogui.click()

def check_for_chain(card_type,card_list):
	indices = [i for i, s in enumerate(card_list) if card_type in s]
	return indices


def brave_chain_checker(base_card,raw_card_list):
	match_list = []

	siamese_model = SiameseNetwork()
	siamese_model.load_state_dict(torch.load('models/siamese_network_cards.pth'))
	siamese_model = siamese_model.to(device)
	siamese_model.eval()
	
	for img in raw_card_list:

		img = scale(img).unsqueeze(0)

		output1,output2 = siamese_model(base_card.cuda(),img.cuda())
		euclidean_distance = F.pairwise_distance(output1, output2)
		#print(euclidean_distance)
		if euclidean_distance <=.45:
			match_list.append('match')
		else:
			match_list.append('not_same')

	del siamese_model
	return check_for_chain('match',match_list)

# def grab_screen_fgo():
# 	#goes through picking cards for brave, buster, arts, quick chains
# 
# 	screen = grab_screen(region=(774,399,1424,764)) #need to make this easier 
# 	screen = cv2.cvtColor(screen, cv2.COLOR_BGR2RGB)
# 	return screen

def get_cards(screen):

	card_list = []
	brave_chain_raw_img_list = []
	for i in range(5):
		raw_card = get_card_raw(i+1, screen)
		#for brave lists
		brave_cards = PIL.Image.fromarray(raw_card)
		brave_chain_raw_img_list.append(brave_cards)
		pred_class ,raw_pred= get_predicted_class(raw_card)
		card_list.append(pred_class)

	return card_list, brave_chain_raw_img_list


def brave_chain_check(card_list, brave_chain_raw_img_list):
	'''
	can modify the brave chain check such that if it finds a brave chain it just returns those indicies? 
	'''
	

	for base_card in brave_chain_raw_img_list:

		img_base = scale(base_card).unsqueeze(0)
		brave_chain_list = brave_chain_checker(img_base,brave_chain_raw_img_list)
		chain_is_brave = False
		#print(brave_chain_list)
		#print(card_list)
		if len(brave_chain_list) >=3:
			chain_is_brave = True	
			for i in range(len(card_list)):
				if i not in brave_chain_list:
					#print('not in',i)
					card_list[i]= 'not_brave'
				else:
					#print('in',i)
					continue
			break
		#print(card_list, brave_chain_list)

		#if card_list.count('not_brave') > 2:
		#	chain_is_brave = True	

	return card_list, brave_chain_list,chain_is_brave
	
def pick_cards_from_card_list(card_list): 
	'''
	this is the section that I can tear out
	actually... keep this for brave chains and run it if there is one... 

	then add a new function if there is no brave chain. 
	'''
	arts = check_for_chain('arts',card_list)
	buster = check_for_chain('buster',card_list)
	quick = check_for_chain('quick',card_list)
	if len(arts) >= 3:
		card_indices = arts[:3]
	elif len(buster) >= 3:
		card_indices = buster[:3]
	elif len(quick) >= 3:
		card_indices = quick[:3]
	else: 
		card_indices = []
		card_indices = card_indices + arts + buster + quick
		card_indices = card_indices[:3]

	#final clicking card
# 	for card_index in card_indices:
# 		if card_index == 0:
# 			click_location('c1')
# 		elif card_index == 1:
# 			click_location('c2')
# 		elif card_index == 2:
# 			click_location('c3')
# 		elif card_index == 3:
# 			click_location('c4')
# 		else:
# 			click_location('c5')

def rl_bot_card_choice(card_list):
	'''
	arts = check_for_chain('arts',card_list)
	buster = check_for_chain('buster',card_list)
	quick = check_for_chain('quick',card_list)
	if len(arts) >= 3:
		card_indices = arts[:3]
	elif len(buster) >= 3:
		card_indices = buster[:3]
	#elif len(quick) >= 3:
		#card_indices = quick[:3]
	else: 
	'''
	rl_model = load_model('models/9_18_run_3_iteration_50000.h5')
	print('rl card: ',card_list)
	processed_card_list = convert_card_list(card_list)
	print('processed rl card: ',processed_card_list)
	predicted_array = rl_model.predict(processed_card_list, batch_size=1)
	predicted_classs = np.argmax(predicted_array)
	print('pred class: ',predicted_classs)
	card_indices = use_predicted_probability(predicted_classs)
	print(card_indices)
	del rl_model
# 	for card_index in card_indices:
# 		if card_index == 0:
# 			click_location('c1')
# 		elif card_index == 1:
# 			click_location('c2')
# 		elif card_index == 2:
# 			click_location('c3')
# 		elif card_index == 3:
# 			click_location('c4')
# 		else:
# 			click_location('c5')
	
	

def detect_start_turn():
	#630, 327 xy 730 415

	attack_model = models.resnet34(pretrained=True)
	num_ftrs = attack_model.fc.in_features
	attack_model.fc = nn.Linear(num_ftrs, 2)
	attack_model = attack_model.to(device)
	attack_model.load_state_dict(torch.load('models/attack_resnet34.pth'))
	attack_model = attack_model.eval()

	labels = { 0:'attack', 1:'not_attack'}
# 	screen = grab_screen_fgo()
# 
# 	attack_button = screen[268:350, 532:621] #x1,y1 x2,y2
# 	attack_button = cv2.cvtColor(attack_button, cv2.COLOR_BGR2RGB)

# 	image = image_loader(attack_button)
# 	y_pred = attack_model(image)
# 
# 	label_out = labels[y_pred.cpu().data.numpy().argmax()]
# 
# 	del attack_model
# 	return label_out == 'attack'

def detect_round_counter(stageCounterSnapshot):
	labels = {0:'1', 1:'3',2: '2'}

	turn_resnet = models.resnet50(pretrained=False)
	num_ftrs = turn_resnet.fc.in_features
	turn_resnet.fc = nn.Linear(num_ftrs, 3)
	turn_resnet = turn_resnet.to(device)
	turn_resnet.load_state_dict(torch.load('models/turncounter_resnet50.pth'))
	turn_resnet = turn_resnet.eval()
	stageCounterSnapshot = cv2.imread(stageCounterSnapshot)
	stageCounterSnapshot = image_loader(stageCounterSnapshot)
	#stageCounterSnapshot = cv2.cvtColor(stageCounterSnapshot,cv2.COLOR_GRAY2RGB)
	y_pred = turn_resnet(stageCounterSnapshot)
	label_out = labels[y_pred.cpu().data.numpy().argmax()]
	
	del turn_resnet

	return label_out
# 	screen = grab_screen_fgo()
# 	sliced = image_loader(screen[6:21, 436:449])

# 	y_pred = turn_resnet(sliced)
# 	label_out = labels[y_pred.cpu().data.numpy().argmax()]
# 
# 	del turn_resnet
# 	
# 	return label_out



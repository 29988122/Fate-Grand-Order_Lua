from flask import Flask
from flask import request
from flask import jsonify
from flask import g
from PIL import Image
from werkzeug.utils import secure_filename
import binascii
import os
import helper
#import imageio
import json
import pytesseract
import player
import time
import re
import cv2 as cv
import numpy as np
from threading import Thread
from functools import wraps
import utils

#Change the following to your Tesseract folder
pytesseract.pytesseract.tesseract_cmd = r"C:\Users\PC1\Downloads\Tesseract-OCR\tesseract.exe"
tessdata_dir_config = r'--tessdata-dir "C:\Users\PC1\Downloads\Tesseract-OCR\tessdata"'

UPLOAD_FOLDER = './tmp'
DEBUG_FOLDER = './debug'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['DEBUG_FOLDER'] = DEBUG_FOLDER
quests = json.loads(open('./config/quests.json', 'r', encoding='utf8').read())



def binarize_image(filename, threshold):
    img = cv.imread(filename)
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    _, result = cv.threshold(img, threshold, 255, cv.THRESH_BINARY)
    return result, np.count_nonzero(result)



# def getEstimatedQuest(fileName, retry = 0):
#     highest = 0
#     result = None
#     name = ''
#     if (retry == 0):
#         image = Image.open(fileName)
#         name = pytesseract.image_to_string(image, lang='jpn', config='--psm 7')
#     elif (retry < 6):
#         image = binarize_image(fileName, 140 + 10 * (retry - 1))[0]
#         name = pytesseract.image_to_string(image, lang='jpn', config='--psm 7')
#     else:
#         return { 'id': -1, 'name': 'error' }, 0
#     name = ''.join(name.split())
#     print('predict', name)
# 
#     for quest in quests:
#         similarity = helper.similar(name, quest['name'])
#         if (similarity > highest):
#             highest = similarity
#             result = quest
#     if (highest > 0.5):
#         return result, highest
#     return getEstimatedQuest(fileName, retry + 1)


def getQuest(id):
    for quest in quests:
        if (quest['id'] == id):
            return quest
    print('Quest Not Found')
    return -1


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if request.headers.get('X-FGO-TOKEN') is None:
            return jsonify({'success': False, 'message': 'Authentication required'})
        else:
            g.user = player.get(request.headers.get('X-FGO-TOKEN'))
        return f(*args, **kwargs)
    return decorated_function


@app.route('/battle/current-stage', methods=['POST'])
def battleCurrentStage():
    if ('file' not in request.files):
        return jsonify({'success': False, 'message': 'File Not Found'})
    file = request.files.get('file')
    if file.filename == '':
        return jsonify({'success': False, 'message': 'No selected file'})
    fileName = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))
    filteredImage, _ = binarize_image(os.path.join(app.config['UPLOAD_FOLDER'], fileName), 230)
    result = pytesseract.image_to_string(filteredImage, config = tessdata_dir_config + ' --psm 8 --oem 0 -c tessedit_char_whitelist=12345')
    print(result)
    print('Stage:', result)
    return jsonify(
        {
            'success': True,
            'message': {
                'stage': result
            }
        }
    )

@app.route('/quest/<int:id>/start', methods=['POST'])
@login_required
def questStart(id):
    quest = getQuest(id)
    user = g.user
    user.count += 1
    user.update()
    return jsonify(
        {
            'success': True,
            'message': 'ok'
        }
    )


@app.route('/quest/<int:id>/end', methods=['POST'])
@login_required
def questEnd(id):
    quest = getQuest(id)
    return jsonify(
        {
            'success': True,
            'message': 'ok'
        }
    )


# @app.route('/quest', methods=['POST'])
# def quest():
#     if ('file' not in request.files):
#         return jsonify({'success': False, 'message': 'File Not Found'})
#     file = request.files.get('file')
#     if file.filename == '':
#         return jsonify({'success': False, 'message': 'No selected file'})
#     fileName = secure_filename(file.filename)
#     file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))
#     result, rating = getEstimatedQuest(
#         os.path.join(app.config['UPLOAD_FOLDER'], fileName))
# 
#     print('EST:', result['name'], 'Rating:', rating)
#     return jsonify(
#         {
#             'success': True,
#             'message': {
#                 'quest': result
#             }
#         }
#     )


@app.route('/servant/np', methods=['POST'])
def servantNP():
    if ('file' not in request.files):
        return jsonify({'success': False, 'message': 'File Not Found'})
    file = request.files.get('file')
    if file.filename == '':
        return jsonify({'success': False, 'message': 'No selected file'})
    fileName = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))
    image, total = binarize_image(os.path.join(app.config['UPLOAD_FOLDER'], fileName), 70)
    NP = total / len(image[0]) * 100
    print('NP:', str(int(NP)) + '%')
    return jsonify(
        {
            'success': True,
            'message': {
                'NP': NP
            }
        }
    )


# @app.route('/servant/skill', methods=['POST'])
# def servantSkill():
#     if ('file' not in request.files):
#         return jsonify({'success': False, 'message': 'File Not Found'})
#     file = request.files.get('file')
#     if file.filename == '':
#         return jsonify({'success': False, 'message': 'No selected file'})
#     fileName = secure_filename(file.filename)
#     file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))
#     filteredImage, _ = binarize_image(os.path.join(app.config['UPLOAD_FOLDER'], fileName), 250)
#     predict = pytesseract.image_to_string(filteredImage, config='--oem 0 --psm 8 digits')
#     predict = ''.join(predict.split())
#     print('Lv:', predict)
#     return jsonify(
#         {
#             'success': True,
#             'message': {
#                 'level': int(predict)
#             }
#         }
#     )


# @app.route('/player/ap', methods=['POST'])
# def playerAP():
#     if ('file' not in request.files):
#         return jsonify({'success': False, 'message': 'File Not Found'})
#     file = request.files.get('file')
#     if file.filename == '':
#         return jsonify({'success': False, 'message': 'No selected file'})
#     fileName = secure_filename(file.filename)
#     file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))
# 
#     filteredImage, _ = binarize_image(os.path.join(
#         app.config['UPLOAD_FOLDER'], fileName), 172)
#     AP = pytesseract.image_to_string(filteredImage, config='--psm 8')
#     print(AP)
#     current, total = AP.split('/')
#     print('AP: {}/{}'.format(current, total),
#         ', Time:', (int(total) - int(current)) * 5, '(mins)')
#     return current


def validateFile():
    if ('file' not in request.files):
        raise ValueError('File Not Found')
    file = request.files.get('file')
    if file.filename == '':
        raise ValueError('No selected file')
    fileName = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], fileName))

    return file

@app.route('/search', methods=['POST'])
def search():
    try:
        file = validateFile()
        img = cv.imdecode(np.fromstring(file.read(), np.uint8), cv.IMREAD_UNCHANGED)
    except Exception as error:
        return jsonify({'success': False, 'message': error})

    return 'OK'

@app.route('/log', methods=['POST'])
def log():
    print(request.form.get('message'))

    return 'OK'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

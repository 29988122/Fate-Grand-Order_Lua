from pathlib import Path
import json

class Player:
    def __init__(self, user):
        self.id = user['id']
        self.AP = user['AP']
        self.bond = user['bond']
        self.count = user['count']

    def update(self):
        players = read()
        for idx, user in enumerate(players):
            if (user['id'] == self.id):
                players[idx] = self.__dict__
                break
        else:
            players.append(self.__dict__)
        with open('players.json', 'w') as f:
            json.dump(players, f)
            f.close()

def read():
    file = Path('players.json')
    if (file.exists()):
        with open('players.json', 'r') as f:
            return json.load(f)
    return []

def get(token):
    for user in read():
        if (user['id'] == token):
            return Player(user)
    return register(token)

def register(token):
    players = read()
    user = {'id': token, 'AP': -1, 'bond': 0, 'count': 0}
    players.append(user)
    with open('players.json', 'w') as f:
        json.dump(players, f)
        f.close()
    return Player(user)

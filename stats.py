import sys
import json
import re

to_find = ["example@email.com", "+0 0000000", "0.0.0.0"]

tokens_all = 0
tokens_removed = [0,0,0]
documents_all = 0
documents_with_removed = [0,0,0]

for line in sys.stdin:
    try:
        j = json.loads(line)
        documents_all +=1
        text = j["text"]
        tokens_all += len(text.split(" "))
        matches = [text.count(f) for f in to_find]
        for i,m in enumerate(matches):
            tokens_removed[i] += m
            if m>0:
                documents_with_removed[i] +=1
    except:
        continue
        

print(f'All tokens: {tokens_all}')
print(f'Removed tokens (email, number, IP): {tokens_removed}')
print(f'All documents: {documents_all}')
print(f'Documents with removed tokens (email, number, IP): {documents_with_removed}')
weighted_sum = sum(tokens_removed)+tokens_removed[1] # weight by phonenumbers which is 2 tokens
print(f'Percentage of tokens removed: {weighted_sum/tokens_all}')
print(f'Individual precentages (phone weighted by 2, as there is approx. 2 "words" in a phone number):')
print(f'Email: {tokens_removed[0]/tokens_all}')
print(f'Phone: {2*tokens_removed[1]/tokens_all}')
print(f'IP: {tokens_removed[2]/tokens_all}')
print("")
print(f'{tokens_all}\t{documents_all}\t{tokens_removed[0]}\t{tokens_removed[1]}\t{tokens_removed[2]}\t{documents_with_removed[0]}\t{documents_with_removed[1]}\t{documents_with_removed[2]}')
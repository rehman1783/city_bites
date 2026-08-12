from collections import Counter
p='lib\\src\\features\\main_navigation\\presentation\\screens\\main_screen.dart'
s=open(p,'r',encoding='utf-8').read()
c=Counter(ch for ch in s if ch in '()[]{}')
print(c)

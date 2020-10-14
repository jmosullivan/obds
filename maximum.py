#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Finding 
@author: jennifer
"""

number_list = [26, 54, 93, 17, 77, 31, 44, 55, 20]



def max_number (number_list):
    number_max = number_list[0] #create variable assuming first variable is maximum
    max_index = 0
    loop_index = 0
    
    for number in number_list:
        if number > number_max:
            number_max = number
            max_index = loop_index
        # print(number, loop_index)
        loop_index += 1 

    return [number_max, max_index] 

#print(max_number(number_list))
    
# the below codes sort the number_list in ascending order

for i in range(len(number_list),1,-1): 
    biggest_number, max_index = max_number(number_list[:i])
    print(number_list[:i])
    print((i), biggest_number, max_index)

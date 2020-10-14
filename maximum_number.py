#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 14:33:13 2020

@author: jennifer
"""

    
number_list = [26, 54, 93, 17, 77, 31, 44, 55, 20]


def max_number (number_list):
    number_max = number_list[0]
    max_index = 0
    loop_index = 0
    
    for number in number_list:
        if number > number_max:
            number_max = number
            max_index = loop_index
        print(number, loop_index)
        loop_index += 1 

    return [number_max, max_index] 
print(max_number(number_list))
    
# the below codes sort the number_list in ascending order

for number_list:
    biggest_number = max_number(number_list)
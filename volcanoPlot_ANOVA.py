# -*- coding: utf-8 -*-
"""
Created on Thu Feb  7 22:02:58 2019

@author: vin_p
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# cd to you working directory with the .csv "C:/Users/vincent/Desktop/"

d=pd.read_csv("edgeR_results All KO ANOVA Like Analysis.csv")

print(d.head())
print(d.info())

d.loc[(d['logFC.group2'] >= 1) & (d['FDR'] < 0.005), 'color'] = "green"  # upregulated
d.loc[(d['logFC.group2'] <=- 1) & (d['FDR'] < 0.005), 'color'] = "red" 
d.loc[(d['logFC.group4'] >= 1) & (d['FDR'] < 0.005), 'color'] = "blue"  # upregulated
d.loc[(d['logFC.group4'] <=- 1) & (d['FDR'] < 0.005), 'color'] = "orange"
d.loc[(d['logFC.group6'] >= 1) & (d['FDR'] < 0.005), 'color'] = "purple"  # upregulated
d.loc[(d['logFC.group6'] <=- 1) & (d['FDR'] < 0.005), 'color'] = "yellow"
d.loc[(d['logFC.group8'] >= 1) & (d['FDR'] < 0.005), 'color'] = "violet"  # upregulated
d.loc[(d['logFC.group8'] <=- 1) & (d['FDR'] < 0.005), 'color'] = "magenta"   # downregulated
d['color'].fillna('grey', inplace=True) # intermediate

# to reduce the noise, filter out genes with low expression counts across treatments 
# (say, < 10 normalized expression count)
# you can change this number as per your requirement and based on expression unit 
# value1 and value2 represents counts for stress and control treatments respectively
# This step isn't entirely necessary, so feel free to ignore it if you don't have counts

d = d.loc[(d['value1'] >= 10) & (d['value2'] >= 10)]

# Now, data is ready for volcano plot
# In volcano plot, Y-axis is -log10 normalized P-value
# NOTE: Here you may get "RuntimeWarning: divide by zero encountered in log10" where 
# there is 0 P-value. To avoid this warning replace 0 with smallest non-zero P-value. 
# To get smallest non-zero P-value, you can use d.nsmallest(2, 'p-value')
# replace 0 P-value with lowest non-zero P-value
# convert P-value to -log10 normalized P-value
d['logpv']=-(np.log10(d['FDR']))

# Lets plot this biatch. 

plt.style.use('seaborn-whitegrid')
plt.scatter(d['logFC.group2'], d['logpv'], c=d['color'], alpha=0.5)
plt.title('Control 24hr Fast vs Control', fontsize=18, fontname='arial', loc='center', fontweight='bold')
plt.xlabel('Log2 Fold Change',fontsize=15, fontname="arial", fontweight="normal")
plt.ylabel('-Log10 P-Value', fontsize=15, fontname="arial", fontweight="normal")
plt.xticks(fontsize=12, fontname="arial")
plt.yticks(fontsize=12, fontname="arial")
plt.savefig('WT Ctl-k 24 vs WT Ctl-k.png', format='png', bbox_inches='tight', dpi=300)

# I have added two gene names. You can add multiple gene names to corresponding point  
# using axis coordinates

plt.text(4.09, 53.65, "CPuORF26")
plt.text(-2.23, 39.73, "CIA")
plt.show()

# To save volcano plot to file, replace  plt.show() with following line

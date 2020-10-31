# Analysis Proposal 
My project proposal involves studying the lipid and cellular metabolism changes in my skin barrier defect mice. \
In doing so, we have generated RNA sequencing dataset from harvested epidermis.

My goal is to visualize all metabolic pathways (lipid biosynthesis, hexose metabolism, glutathione synthesis, \
nucleic acid synthesis, protein synthesis) in control vs diseased mice. For example, I want to be able to take 20 \
genes representative for lipid biosynthesis, aggregate them and display them on violin plots comparing control vs disease.

I have received permission from my labmate to utilize her RNA sequencing data. I will ask her to provide me the path \
to her file in HPC3 as well as ask her to allow me to have read, write, and execute permission. I am limited in doing \
statistics due to the sample size of n =2 for each condition. But the visualizations mentioned above will provide \
direction in understanding global metabolic changes in my skin barrier disease mice. To create my violin plots, I will \
utilize vinPlot from Seurat.

Is this project feasible? The data is readily accessible and already permission has been given (not read, write, or \
execute yet). It involves a singular visualization of the dataset comparing across global metabolic gene signature groups \
and I will be utilizing a function from Seurat in R. Because I am not looking at any one particular gene but rather a \
group of genes that makeup a pathway, it is exploratory in nature as I am not restrained to looking at one gene at a time. \
Then, I would be able to formulate further data-driven hypothesis based on my general understanding of all these pathways \
which may be altered in diseased mice.

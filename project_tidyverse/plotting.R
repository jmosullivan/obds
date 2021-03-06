

library(tidyverse)
library(gridExtra)
library(cowplot)
library(patchwork)

data("mtcars")
head(mtcars)
str(mtcars)

par(mar=c(6,6,5,5), lwd)
table(mtcars$gear)


par(mfrow = c(1,2)) #setting enviroment for filling plot spaces

barplot(table(mtcars$gear),
        xlab="number of gears",
        ylab="A main title\nspread across two lines",
        col = "red")
#abline(h=6, lwd=70)

colours <- c("red", "green", "blue")
names(colours) <-c(3,4,5)
gears_column<-as.character(mtcars$gear)
gears_column
colours[gears_column] #subsetting gears_column by colour

plot(mtcars$mpg, mtcars$hp,
     col = colours[gears_column],
     pch = 16,
     cex = 6,
     xlab = "miles per gallon",
     ylab = "Horse power",
     cex.lab = 2)
legend(legend = sort(unique(mtcars$gear)),
       x = "right",
       fill = c("red", "green", "blue"))

#exercise

BiocManager::install("biomaRt")

#tidying up RNAseq data on mouse T cells.
#knockin, KO, +/-virus, 3 biological repeats (n=12)
#2 files.

BiocManager::install('grimbough/biomaRt')

library(tidyverse)
library(biomaRt)
library(pheatmap)

#tidy count file - 3 cols
sample_table <- read_tsv("obds_sampletable.tsv")
count_table <- read_tsv("obds_countstable.tsv.gz")
View(sample_table)
View(count_table)

processed_counttable <- count_table %>%
    pivot_longer(-Geneid, names_to = "sample", values_to = "count")
View(processed_counttable)

#join with gene info to get mgi_symbol
listMarts()
ensembl <- useMart("ensembl") #connecting to specific database
datasets <- listDatasets(ensembl) #list dataset
head(datasets)
ensembl <- useMart("ensembl",dataset="mmusculus_gene_ensembl")
View(ensembl)

filters <- listFilters(ensembl)
filters[1:5,]
View(filters)

attributes = listAttributes(ensembl)
attributes[1:5,]
View(attributes)
#matching
matching <- getBM(attributes = c("ensembl_gene_id", "mgi_symbol"),
                  values = unique(processed_counttable$Geneid),
                  mart = ensembl)
#remove duplicates
View(matching)

#joining tables to match geneid note different naming btw 2 tables.
processed_counttable <- processed_counttable %>% 
    left_join(matching, by = c("Geneid" = "ensembl_gene_id"))

#tidy metadata file: 1 var per col & remove species and library_layout cols
#separating by cell type, KO/KI, replicate
View(sample_table)

processed_sample_table <- sample_table %>% 
    separate(sample_title, c("gene", "genotype", "cell type", "replicates"), sep = "_") %>%
    unite("Genotype", gene, genotype, sep = "_")  %>% 
    dplyr::select(-library_layout, -read_count)
View(processed_sample_table)
#remove cols

#joining 2 tables
processed_joined <- processed_counttable %>% 
    left_join(processed_sample_table, by = c("sample" = "Sample_accession"))
View(processed_joined)

#calculate CPM (group_by() and mutate()) #log2
calculated <- processed_joined %>% 
    group_by(sample) %>% 
    mutate(total_count_per_sample = sum(count)) %>% 
    mutate(total_count_in_million = total_count_per_sample / 1000000)  %>% 
    mutate(CPM= count / total_count_in_million) %>% 
    mutate(log_CPM = log2(CPM+1))
View(calculated)

#add metadata to table w/ counts & gene info
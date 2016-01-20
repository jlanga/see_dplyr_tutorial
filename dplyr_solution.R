library(dplyr)
library(tidyr)

# Load
liver_messy <- read.table(
    file = "~/tmp/see_dplyr/liver_3.gff",
    sep  = "\t",
    dec  = ".",
    skip = 2,
    stringsAsFactors = F)

liver_messy %>% head()

# Select and rename columns
liver_clean <- liver_messy %>%
    select(
        chr    = V1,
        source = V2,
        type   = V3,
        start  = V4,
        end    = V5,
        qual   = V6,
        strand = V7)

liver_clean %>% head()

# Compute how many transcripts are expressed in the 1st chromosome.
liver_clean %>%
    filter(type == "transcript") %>%
    filter(chr == "1") %>%
    nrow()

# Compute how many transcripts are expressed in the + strand for each chromosome,
# in descending order.
liver_clean %>%
    filter(type == "transcript") %>%
    filter(strand == "+") %>%
    group_by(chr) %>%
    summarise(counts = n()) %>%
    arrange(desc(counts))


# Compute how long is the longest expressed transcript
liver_clean %>%
    filter(type == "transcript") %>%
    mutate(length = end - start + 1) %>%
    arrange(desc(length)) %>%
    head(1) %>%
    select(strand)


# Plot the mean exon distribution in the first 10 chromosomes
liver_clean %>%
    filter(type == "exon") %>%
    mutate(length = end - start +1) %>%
    group_by(chr) %>%
    filter(chr %in% c(1:10)) %>%
    summarise(mean_length = mean(length, na.rm = T)) %>%
    plot()

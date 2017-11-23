## Util for creating required grade summaries. 
library(stringr)

## PARAMETER: directory with csv's to be summarized
dir <- "/Users/mdelhey/Library/Mobile\ Documents/com~apple~CloudDocs/TEACHING-PHIL1010/TEACHING-Fall\ 2017/S&E2-grades/"

## Read in all csv's in dir
fn <- list.files(dir, pattern = "*.csv")
fnd <- paste0(dir, fn)
csv <- lapply(fnd, read.csv, stringsAsFactors = FALSE)

res <- lapply(csv, function(x) {
##  x <- csv[1][[1]]
  ## Remove demo student
  demo_index <- which(x$Last.Name == "Student" & x$First.Name == "Demo")
  x <- x[-demo_index, ]
  
  ## Find grade column
  grade_col <- which(str_detect(names(x), fixed("grade", ignore_case = TRUE)))
  
  ## Create new numeric grade column
  x$grade_col <- as.numeric(x[, grade_col])
  return(x$grade_col)
})

all1 <- unlist(res)

## Round numbers to closest whole integer
all1 <- round(all1, digits = 0)

## If No Show (i.e., grade = 0 or NA), then NA
bad_zero <- which(all1 == 0 | is.na(all1))
all2 <- all1
all2[bad_zero] <- "NoShow"

## If Below 60, then "below 60"
bad_sixty <- which(as.numeric(all2) < 60)
all3 <- all2 
all3[bad_sixty] <- "Below60"

## Table data
all3_fac <- factor(all3, levels = c(100:60, "Below60", "NoShow"))
tab <- table(all3_fac, useNA = "no")
tab <- c(tab, Total=sum(tab))

## Write csv output to DIR
print(tab)
time <- format(Sys.time(), "%d-%b-%Y_%H-%M")
fn_new <- paste0(dir, "grade_summary_", time, ".csv")
write.csv(tab, fn_new)













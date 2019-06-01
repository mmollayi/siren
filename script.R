ms1filename <- "15b.ms1"
ms1file <- readLines(ms1filename)
ms1file <- str_trim(ms1file)
length(ms1file)
ms1file <- ms1file[str_starts(ms1file, "H|Z|D|S", negate = TRUE)]
length(ms1file)
ms1file <- ms1file[(!str_starts(ms1file, "I")) | str_detect(ms1file, "RTime")]
rt_idx <- str_which(ms1file, "RTime")
peaklist <- vector("list", length(rt_idx))
peaklist <- map(rt_idx, ~str_extract(ms1file[.x], "(?<=RTime\t).*$") %>% as.numeric())

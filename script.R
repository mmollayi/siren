ms1filename <- "15b.ms1"
ms1file <- readLines(ms1filename)
ms1file <- str_trim(ms1file)
length(ms1file)
ms1file <- ms1file[str_starts(ms1file, "H|Z|D|S", negate = TRUE)]
length(ms1file)
ms1file <- ms1file[(!str_starts(ms1file, "I")) | str_detect(ms1file, "RTime")]
rt_idx <- str_detect(ms1file, "RTime") %>%
    cumsum()

ms1file_splited <- split(ms1file, rt_idx)

peaklist <- vector("list", 2) %>%
    set_names(c("rtime", "peaks"))

peaklist$rtime <- map_dbl(ms1file_splited,
                      ~str_extract(.x[1], "(?<=RTime\t).*$") %>% as.numeric())

peaklist$peaks <- map(ms1file_splited,
                      ~str_split(.x[-1], " ") %>% map(as.numeric))

peak_df <- as_tibble(peaklist)

peaks <- peaklist$peaks

a <- peaks[[1]]
b <- peaks[[2]]

I <- length(a)
J <- length(b)
svs <- list()
while (i < I && j < J) {
    diff <- a[[i]][1] - b[[j]][1]
    if (abs(diff) <= 0.005) {
        svs <- c(svs, a[[i]])
    }
}

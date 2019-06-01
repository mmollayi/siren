siren <- function(ms1filename) {
    cat("Reading the ms1file")
    ms1file <- readLines(ms1filename)
    scannum <- -1
    peaklist <- list()
    rtime <- 0
    numpeaks <- 0
    ms1file <- str_trim(ms1file)
    ms1file <- ms1file[str_starts(ms1file, "H|Z|D")]
    for (line in ms1file) {
        chr1 <- str_sub(line, 1, 1)
        } else if ((chr1 %in% "I") && str_detect(line, "RTime")) {
            rtime <- as.numeric(str_extract("(?<=\t)(?=\\d).*$)"))
            peaklist <- c(peaklist, rtime)
        } else if (chr1 == "S") {
            if (scannum %% 200 == 0) cat("Reading scan", scannum)
            scannum <- scannum + 1
        } else if (str_length(line) > 1) {
            tokens <- str_trim(line, "right") %>%

        }

    }
}

a <- 1

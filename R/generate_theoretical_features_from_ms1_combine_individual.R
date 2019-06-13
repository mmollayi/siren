read_ms1 <- function(ms1filename) {
    cat("Reading the ms1file\n")
    scannum <- -1
    peaklist <- list()
    rtime <- 0
    numpeaks <- 0
    ms1file <- file(ms1filename, open = "r", raw = TRUE)
    repeat {
        current_line <- readLines(ms1file, n = 1)
        if (length(current_line) == 0) break()
        chr1 <- str_sub(current_line, 1, 1)
        if (chr1 %in% c("H", "Z", "D")) next()
        if (chr1 == "I") {
            if (str_detect(current_line, "RTime")) {
                rtime <- str_extract(current_line, "(?<=RTime\t).*$") %>% as.numeric()
                peaklist <- c(peaklist, list(list(rtime, list())))
            }
            next()
        }
        if (chr1 == "S") {
            if (scannum %% 200 == 0) cat("Reading scan", scannum, "\n")
            scannum <- scannum + 1
            next()
        }
        if (str_length(current_line) > 1) {
            tokens <- str_split(current_line, " ")[[1]]
            mz <- as.numeric(tokens[1])
            intensity <- as.numeric(tokens[2])
            numpeaks <- numpeaks + 1
            peaklist[[length(peaklist)]][[2]] <- c(peaklist[[length(peaklist)]][[2]], list(c(mz, intensity)))
        }
    }
    close(ms1file)
    cat("Numpeaks:", numpeaks, "\n")
    return(peaklist)
}

ms1filename <- "15b.ms1"
peaklist <- read_ms1(ms1filename)

tol <- 0.005
justpeaks <- map(peaklist, 2)
justpeaks <- delete_unduplicated_peaklist(justpeaks, tol)

maxfeatures = 15000
t <- 1

toprint <- FALSE
while (t <= length(justpeaks)) {
    numfeats <- 0
    xs <- list()
    ys <- list()

    while (numfeats < maxfeatures) {
        if (t >= length(justpeaks)) break()
        cat("Numfeats", numfeats, "\n")
        blockpeaks <- map(1:length(justpeaks[[t]]),
                          ~c(justpeaks[[t]][[.x]][1], justpeaks[[t]][[.x]][2], t))

        if (length(blockpeaks) == 0) {
            t <- t + 1
            next()
        }

        tol <- 0.01
        clusts_cixes <- peaklist_to_cluster(blockpeaks, tol)
        clusts <- clusts_cixes[[1]]
        cixes <- clusts_cixes[[2]]

        if (toprint) cat("num clusters:", length(clusts), length(clusts) / length(blockpeaks), "\n")
        features <- list()
        N <- length(clusts)
        maxcharge <- 4

        tol <- .01
        if (toprint) cat("Hypothesizing isotope features \n")

        for (n in seq_len(N)) {
            p <- clusts[[n]]
            n2 <- n + 1

            for (c in maxcharge:1) {
                isop <- PeakCluster(p$minmz + 1 / c, p$maxmz + 1 / c, 0, 0)
                while (n2 < N) {
                    compare
                }

            }
        }
    }
}


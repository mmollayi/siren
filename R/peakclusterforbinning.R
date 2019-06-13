delete_unduplicated_peaklist <- function(peaklists, tol = 0.005) {
    svs <- vector("list", length(peaklists)) %>%
        map2(1:length(peaklists), ~vector("list", 0))

    for (t in 1:(length(svs) - 1)) {
        if (t == 1) {
            a <- peaklists[[t]]
        } else {
            a <- b
        }

        b <- peaklists[[t + 1]]

        if (t %% 100 == 1) cat("t:", t, length(svs[[t]]), length(a), length(b), "\n")

        i <- 1
        j <- 1
        I <- length(a)
        J <- length(b)

        while (i <= I && j <= J) {
            diff <- a[[i]][1] - b[[j]][1]
            if (abs(diff) <= tol) {
                svs[[t]] <- c(svs[[t]], list(a[[i]]))
                svs[[t + 1]] <- c(svs[[t + 1]],list(b[[j]]))
            }
            if (diff > 0) {
                j <- j + 1
            } else {
                i <- i + 1
            }
        }
        svs[[t]] <- unique(svs[[t]])
        ordered_idx <- order(map_dbl(svs[[t]], 1))
        svs[[t]] <- svs[[t]][ordered_idx]
    }
    return(svs)
}

peaklist_to_cluster <- function(peaklist, tol = .005) {
    # the sorting at the first line is omited because peaklist is alreay sorted
    clusters <- list()
    mz <- peaklist[[1]][1]
    intensity <- peaklist[[1]][2]
    realt <- peaklist[[1]][3]
    clusters <- c(clusters, PeakCluster$new(mz, mz, realt, intensity))

    cids <- rep(0, length(peaklist))
    ix <- 2
    for (vec in peaklist[-1]) {
        mz <- vec[1]; intensity <- vec[2]; realt <- vec[3]
        if (clusters[[length(clusters)]]$maxmz > (mz - tol)) {
            clusters[[length(clusters)]]$maxmz <- mz
            cids[ix] <- cids[ix - 1]
            clusters[[length(clusters)]]$peaks <- c(clusters[[length(clusters)]], list(c(realt, intensity)))
        } else {
            clusters <- c(clusters, PeakCluster$new(mz, mz, realt, intensity))
            cids[ix] <- cids[ix - 1] + 1
        }
        ix <- ix + 1
    }
    return(list(clusters, cids))
}

PeakCluster <- R6Class(
    "PeakCluster",
    private = list(
        shared_env = new.env(),
        get_numpcs = function() {
            .numpcs <- private$shared_env$.numpcs
            if (is.null(.numpcs)) .numpcs <- 0
            return(.numpcs)
        }
    ),
    active = list(
        numpcs = function(values) {
            if (missing(values)) {
                private$shared_env$.numpcs
            } else {
                stop("`numpcs` is read-only", call. = FALSE)
            }
        }
    ),
    public = list(
        minmz = NULL,
        maxmz = NULL,
        peaks = NULL,
        initialize = function(mz1, mz2, t, intensity) {
            self$minmz <- mz1
            self$maxmz <- mz2
            self$peaks <- list(c(t, intensity))
            private$shared_env$.numpcs <- private$get_numpcs() + 1
        },

        add = function(mz, tol) {
            if (mz + tol >= self$minmz) {
                if (mz - tol <= self$maxmz) {
                    self$maxmz <- max(self$maxmz, mz)
                    self$minmz <- min(self$minmz, mz)
                    return(TRUE)
                }
            }
            return(FALSE)
        },

        p = function() {
            cat(private$shared_env$.numpcs, " (", self$minmz, ", ", self$maxmz, ")", sep = "")
        },

        pfile = function(fout) {
            write(paste(self$minmz, "\t", self$maxmz, "\n", sep = ""), fout)
        }
    )
)

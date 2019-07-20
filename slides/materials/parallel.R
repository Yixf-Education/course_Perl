#!/usr/bin/Rscript

# print 1 to 10: use 20 seconds
system.time(
  for (i in 1:10) {
    Sys.sleep(2)
    print(i)
  }
)


# print 1 to 10: use 2 seconds
library(foreach)
library(doParallel)

# setup parallel backend to use many processors
# cores <- detechCores()
# no_cores <- cores-1
no_cores <- 10
cl <- makeCluster(no_cores)
registerDoParallel(cl)

system.time(
  x <- foreach (i=1:10) %dopar% {
    Sys.sleep(2)
    print(i)
  }
)

# stop cluster
stopCluster(cl)

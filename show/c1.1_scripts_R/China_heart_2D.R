#!/usr/bin/Rscript

# heart
n <- 30000
p <- sort(runif(n, min = 0, max = pi))
p <- sin(p) + rnorm(n)
plot(
  sort(rnorm(n)),
  -p,
  col = "red",
  pch = "·",
  axes = F,
  ylab = "",
  xlab = ""
)

#plot(sort(rnorm(n)), -p, col="red", pch="·", axes=F, ylab="", xlab=paste("By 微微    ", Sys.Date()), main="Happy Birthday")

#stars
p <- c()
q <- c()
rr <- c(0.68, rep(0.32, 4))
#locator()定的下面坐标，精确但不准确。
m <- c(-1.2511927,-0.7707085,-0.5538095,-0.6129638,-0.8293381)
n <-
  c(-0.079779159, 0.42312375, 0.05632304,-0.45719796,-0.8440031)
for (k in c(1:5)) {
  r = rr[k]
  for (i in 1:5) {
    p[2 * i - 1] <-
      sin(pi * 18 / 90) / sin(pi * 54 / 90) * r * sin(pi * (i * 72 + 36) / 90)
    q[2 * i - 1] <-
      sin(pi * 18 / 90) / sin(pi * 54 / 90) * r * cos(pi * (i * 72 + 36) / 90)
    p[2 * i] <-
      sin(pi * 18 / 90) / sin(pi * 54 / 90) * 0.38 * r * sin(pi * (i * 72 + 18) / 90)
    q[2 * i] <-
      sin(pi * 18 / 90) / sin(pi * 54 / 90) * 0.38 * r * cos(pi * (i * 72 + 18) / 90)
  }
  x <-
    c(p[1], p[2], p[5], p[6], p[9], p[10], p[3], p[4], p[7], p[8], p[1])
  y <-
    c(q[1], q[2], q[5], q[6], q[9], q[10], q[3], q[4], q[7], q[8], q[1])
  x <- x + m[k]
  y <- y + n[k]
  polygon(x, y, col = "yellow", border = "yellow")
}

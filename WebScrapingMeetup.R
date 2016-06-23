library(rvest)
## To install rvest use the following:
# install.packages("rvest")

## To download from Twitter, use package: 
## twitteR

Path <- "http://www.uefa.com/uefaeuro/"
Selector <- ".table_team-points , .table_team-lost , .table_team-drawn , .table_team-won , .table_team-played , .team-name"

a <- read_html(Path)

b <- html_nodes(x = a,css = Selector) 

# as.character(b[[1]])

c <- html_text(b)

d <- gsub(pattern = "\r\n",replacement = "",
          x = c)

e <- gsub("  +","",d)

sum("P" == e)

f <- e[e!="P"& e!="W"& e!="D"& e!="L"& e!="Pts"]

g <- f[89:length(f)]

h <- t(data.frame(split(g, ceiling(seq_along(g)/6))))

g <- data.frame(h)
names(g) <- c("Country","P","W","D","L","Pts")
head(g)

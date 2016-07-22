
library(ggplot2)
data("diamonds")

madamfo <- diamonds

plot(madamfo$carat)

ggplot(data = madamfo, aes(y=price,x=carat)) + geom_point()

names(madamfo)

ggplot(data = madamfo, aes(y=price,x=carat,  alpha=clarity)) + geom_point()


charlieWot <- lm(madamfo$price~madamfo$carat)

summary(charlieWot)

meKo <- iris

names(meKo)
head(meKo, n = 50)
tail(meKo, n = 50)
class(meKo[c(1, 3, 5),2])
as.matrix(meKo)

ggplot(data = meKo, aes(x = Petal.Width, y = Sepal.Length, color = Sepal.Length)) + geom_point()


Mabre <- mtcars

ggplot(Mabre,aes(x=wt, y=mpg)) +geom_point()

summary(Mabre)
str(Mabre)

example(lm)

ThankYou <- lm(Mabre$mpg ~ Mabre$wt)

plot(rstandard(ThankYou))

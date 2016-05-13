

## First r-user meeting: Accra!

#### Why ggplot, dplyr, tidyr? ####
library(ggplot2)
library(ggplot2movies)

## Explore movies
str(movies)
head(movies)
View(movies)



#### Easy EDA ####
names(movies)
ggplot(movies,aes(x=year,y=budget)) + geom_point()
ggplot(movies,aes(x=year,y=budget,color=rating)) + geom_point()
ggplot(movies, aes(x = year, y = budget, color = rating, alpha = votes)) + geom_point() + 
  scale_color_gradient(low="white",high="red")

## Broken down
ggplot(movies, aes(x = year, y = budget, color = rating, alpha = votes, shape=mpaa)) + geom_point() + 
  scale_color_gradient(low="white",high="red") 

ggplot(movies, aes(x = year, y = budget, color = rating, alpha = votes)) + geom_point() + 
  scale_color_gradient(low="white",high="red") + facet_wrap(~mpaa)

ggplot(movies,aes(x=votes,y=rating,color=votes))+geom_point(alpha=0.1)+facet_wrap(~year)

#### Do a bit of data-cleaning ####
library(tidyr)
library(dplyr)

## Remove stupid R columns:
movies[,-grep("r\\d",names(movies))] # base method

# movies <- 
movies %>% select(-(r1:r10)) # dplyr method

## Look closer, group_by and remove NC-17

movies %>% 
  group_by(mpaa, year) %>%
  filter(mpaa != "NC-17") %>%
  summarize(b = mean(budget, na.rm=T),
            r = mean(rating, na.rm=T),
            v = mean(votes, na.rm=T)) %>%
  ggplot( aes(x = year, y = b, color = r)) + geom_point() +
  scale_color_gradient(low="white",high="red") + facet_wrap(~mpaa) 


#### Combine genres into one df and then explore votes by genre ####
gather(data = movies,key = genre,val , Action:Short) %>%
  filter(val==1) %>% 
  ggplot(aes(x=year,y=rating))+geom_point(alpha=0.1)+facet_wrap(~genre)

## Best animations per year
# dplyr approach
movies %>% 
  filter(Animation==1, length<=10) %>% 
  arrange(year,desc(rating)) %>% 
  select(title,year,rating, budget) %>% 
  group_by(year) %>% top_n(3)

#base approach:
a <- movies[movies$Animation==1,c("title","year","rating","budget")]
b <- a[order(a$year,decreasing = T),]
# c <- ....... cut & head?


##### group into variables
movies$decade <- round(movies$year,-1)
movies$decade %>% unique
movies$roundRatings <- 
  round(movies$rating,0)
# movies$roundBudget <- round(movies$budget,-4)
movies$roundBudget %>% unique
movies$roundBudget <- 
  cut(movies$budget,breaks = 10)

ggplot(movies,aes(x=roundRatings,y=roundBudget)) + 
  geom_point(alpha=0.01) + 
  facet_wrap(~decade)


#### Exploring the infinite flexibility of ggplot2 ####
ggplot(mpg,aes(x=cty,y=displ)) + 
  geom_point(size=6,alpha=0.2) + 
  geom_point(size=5,aes(color=fl)) + 
  geom_point(size=3,aes(shape=drv)) 


#### Some HTML_widgets ####

## Rpivot
# devtools::install_github(c("ramnathv/htmlwidgets", "smartinsightsfromdata/rpivotTable"))
library(rpivotTable)
rpivotTable(movies)


## Parallel Coordinates

movies %>% filter(!is.na(budget)) -> d
# devtools::install_github("timelyportfolio/parcoords")
library(parcoords)
parcoords(  d[1:200,1:6],
            reorderable = T,brushMode = "2d-strums",rownames = F)

## Example from author:
pc <- parcoords(  d[1:200,1:6],
                  reorderable = T,brushMode = "2d-strums",rownames = F)

# example how to use tasks to get a dump of brushed data
#  in the console
#  note:  this is just a temporary solution
pc$x$tasks <- list(
  htmlwidgets::JS(
    '
    function(){
    this.parcoords.on("render", function() {
    if(this.brushed()){
    console.log(JSON.stringify(this.brushed()))
    }
    })
    }
    
    '
  )
  )
#  note:  this is just a temporary solution
pc$x$tasks <- list(
  htmlwidgets::JS(
    '
    function(){
    this.parcoords.on("render", function() {
    if(this.brushed()){
    document.getElementById("brushdump").innerText = JSON.stringify(this.brushed())
    }
    })
    }
    '
  )
  )

library(htmltools)
browsable(
  tagList(
    pc,
    tags$textarea(id = "brushdump")
  )
)


######### Resources ####
# http://tryr.codeschool.com/
# http://datascience-africa.org/
# http://www.r-bloggers.com/
# http://gallery.htmlwidgets.org/
# http://www.ggplot2-exts.org/
# http://docs.ggplot2.org/current/
# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
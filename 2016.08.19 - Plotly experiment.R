library(plotly)

x <- seq(-2*pi, 2*pi, length.out = 1000)
df <- data.frame(x, y1 = sin(x), y2 = cos(x))

p <-   plot_ly(df, x = x) %>%
  add_lines(y = ~y1, name = "A") %>%
  add_lines(y = ~y2, name = "B", visible = T)


p <- p %>% layout(
  title = "Drop down menus - Styling",
  xaxis = list(domain = c(0.1, 1)),
  yaxis = list(title = "y"),
  updatemenus = list(
    list(
      y = 0.8,
      buttons = list(
        
        list(method = "restyle",
             args = list("line.color", c("orange","red")),
             label = "whaaaat"),
        
        list(method = "restyle",
             args = list("line.color", "red"),
             label = "Red"))),
    
    list(
      y = 0.7,
      buttons = list(
        list(method = "restyle",
             args = list("visible", list(TRUE, T)),
             label = "Sin"),
        
        list(method = "restyle",
             args = list("visible", list(FALSE, TRUE)),
             label = "Cos")))
  ))

p

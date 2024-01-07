##Chatbot order
df <- data.frame(
  id = (1:4) ,
  menu = c("magarita pizza","hawaiian pizza","carbonara spaghetti","seafood pizza"),
  price = c(4,5,7,8)
  )
  print("Welcome to PIZZA!")
  print(df)
  total_price <- 0
chatbot_order <- function() {
  more <- "Y"
while (more == "Y") {

    order_menu <- as.numeric (readline("Select Menu Number : "))
    order_quantity <- as.numeric (readline("How Many Unit ? : "))
    print(paste("You have :", order_quantity , df[order_menu,2]  ))

              pizza_price <- df[order_menu,3] * order_quantity
              total_price <- pizza_price + total_price


more <- readline("Order More ? : [Y/N] ")
    }
    print (paste ("Total Price : " ,total_price, "Dollar"))
print("Thank You have a good day 😉. ")

}

chatbot_order()

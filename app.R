library(shiny)

# variaveis secretas:
# valid_user
# valid_pass
# powerbi_embed

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      html, body { height:100%; margin:0; }
      .login-box {
        max-width: 300px; margin: 100px auto; padding: 20px;
        border: 1px solid #ccc; border-radius: 8px; background: #f8f8f8;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
      }
      .embed-wrap { position:absolute; inset:0; }
      .embed-wrap iframe { width:100%; height:100%; border:0; }
    "))
  ),
  uiOutput("main_ui")
)

server <- function(input, output, session) {
  logged <- reactiveVal(FALSE)

  output$main_ui <- renderUI({
    if (!logged()) {
      div(
        class = "login-box",
        h3("Login"),
        textInput("user", "Usuário"),
        passwordInput("pass", "Senha"),
        actionButton("login_btn", "Entrar"),
        textOutput("login_msg")
      )
    } else {
      div(class = "embed-wrap", HTML(Sys.getenv("powerbi_embed")))
    }
  })

  observeEvent(input$login_btn, {
    if (identical(input$user, Sys.getenv("valid_user")) &&
      identical(input$pass, Sys.getenv("valid_pass"))) {
      logged(TRUE)
    } else {
      output$login_msg <- renderText("Usuário ou senha incorretos.")
    }
  })
}

shinyApp(ui, server)

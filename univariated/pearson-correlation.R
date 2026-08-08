
if(!require(corrplot)) install.packages("corrplot")
if(!require(dplyr))    install.packages("dplyr")

library(corrplot)
library(dplyr)
library(dplyr)
library(readr)

raw_data <- read.csv2("dados.csv", 
                     sep = ";", 
                     dec = ",", 
                     header = TRUE) 


data_clean <- raw_data %>%
  select(
    # selecionar as variaveis resp.
    SDM,
    SH,
    RL,
    SD,
    F0,
    Fv.Fm,
    Fv.F0,
    PIabs,
    Area,
    ETo.RC,
    Chl.a,
    Chl.b,
    Car,
    MC,
    As,
    Fe,
    Zn,
    Cu
  ) %>%
  mutate(across(
    .cols = everything(), 
    .fns = ~ as.numeric(
      gsub(",", ".",                     
           trimws(                     
             gsub("%", "",              
                  gsub("\\.", "", as.character(.)) 
             )
           )
      )
    )
  ))


M <- cor(data_clean, use = "pairwise.complete.obs")



corrplot(M, 
         method = "color",
         type = "upper",
         addCoef.col = "black",
         tl.col = "black",
         tl.srt = 45,
         diag = FALSE,
         col = colorRampPalette(c("#762a83", "white", "#1b7837"))(200),
         number.cex = 0.65, 
         tl.cex = 0.9      
)

print(correlacao)
dev.off()
print(Figure_Correlation_Dados.tiff)
#Graph
png("Figure_Correlation_Dados_altern.png", width = 2400, height = 2400, res = 300)

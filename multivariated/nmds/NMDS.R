###################################################
##                                               ##
##   Non-metric Multidimensional Scaling (NMDS)  ##
##                                               ##
###################################################

#If you don't have the vegan package installed, run this first: install.packages("vegan")

1) library(vegan)

2) 
2.1 Load the .csv spreadsheet
2.2 Run the attach() and names() commands
2.3 Create the target universe (subset) to run the NMDS: uni <- data[,ni:nff]

# Obs1: To run the NMDS, we can use matrices using Bray-Curtis "bray", Euclidean "euclidean", Jaccard "jac". 

3) 
nmds1 <- metaMDS(uni, k=2, distance="bray")

# Obs2: Importance of the stress value:
# 	Stress > 0.20 The model is non-significant. Indicates low accuracy.
# 	Stress < 0.20 The model is significant and accurate. 
# 	Stress < 0.05 Best possible situation!

4) Plots

# 4.1 Stress plot
goodness(nmds1)
stressplot(nmds1)

# 4.2 Biplot graph for MDS1 and MDS2 axes
plot(nmds1, type="t")
plot(nmds1, type="n")
points(nmds1, pch=16)
ordihull(nmds1, group=nome.tratamento, show="trat1", col="red")
ordihull(nmds1, group=nome.tratamento, show="trat2", col="green3")
ordihull(nmds1, group=nome.tratamento, show="trat3", col="blue")
ordihull(nmds1, group=nome.tratamento, show="trat4", col="gray")
ordihull(nmds1, group=nome.tratamento, show="trat5", col="yellow")
legend("bottomleft", legend=levels(tratamento), lty=1, col=c("red", "green3", "blue", "gray", "yellow"))


###### Combining PCA and NMDS 

5) Run item 3

6) Run a standard PCA without cleaning the target universe variables 
pca <- rda(uni, scale=T) # or F
summary(pca)
biplot(pca)

# Obs3: Observe the overlaps. 

7) Run environmental NMDS
nmds.env <- envfit(nmds1, uni)
nmds.env
plot(nmds1, type="n")
points(nmds1, pch=16, col=c("red","green3","blue", "gray", "yellow")[tratamento])
legend("bottomleft", legend=levels(tratamento), pch=16, col=c("red","green3","blue", "gray", "yellow"))
plot(nmds.env)

8) Restart the script using only the significant variables!
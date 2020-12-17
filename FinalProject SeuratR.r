#install.packages('Seurat')

library(dplyr)
library(Seurat)
library(patchwork)

# Load the skin dataset
skin.data <- Read10X(data.dir = "/Users/jl0l2012/Documents/ee282/wound1")
skin <- CreateSeuratObject(counts = skin.data, project = "skin3k", min.cells = 3, min.features = 200)
skin

# Just looking at the first 10 rows and 30 columns with columns names suppressed
skin.data[1:10,1:30]

dense.size <- object.size(as.matrix(skin.data))
dense.size

skin[["percent.mt"]] <- PercentageFeatureSet(skin, pattern = "^mt-")

head(skin@meta.data, 5)

# Visualize QC metrics as a violin plot
tiff(filename="/Users/jl0l2012/Documents/ee282/wound1/Vinplotmt.tiff")
VlnPlot(skin, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
dev.off()
#They don't have mitochondrial scores. So could they have already been filtered out? But we'd need to have raw data

# FeatureScatter is typically used to visualize feature-feature relationships, but can be used
# for anything calculated by the object, i.e. columns in object metadata, PC scores etc.

plot1 <- FeatureScatter(skin, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(skin, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 + plot2


skin <- subset(skin, subset = nFeature_RNA > 1000 & nFeature_RNA < 4000 & percent.mt < 5)

skin <- NormalizeData(skin, normalization.method = "LogNormalize", scale.factor = 10000)

skin <- FindVariableFeatures(skin, selection.method = "vst", nfeatures = 2000)
top10 <- head(VariableFeatures(skin), 10)
plot1 <- VariableFeaturePlot(skin)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2
#Adjust Above#
all.genes <- rownames(skin)
skin <- ScaleData(skin, features = all.genes)

skin <- RunPCA(skin, features = VariableFeatures(object = skin))

VizDimLoadings(skin, dims = 1:2, reduction = "pca")

DimPlot(skin, reduction = "pca")
DimHeatmap(skin, dims = 1, cells = 500, balanced = TRUE)
DimHeatmap(skin, dims = 1:15, cells = 500, balanced = TRUE)

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time
skin <- JackStraw(skin, num.replicate = 100)
skin <- ScoreJackStraw(skin, dims = 1:20)

JackStrawPlot(skin, dims = 1:15)
ElbowPlot(skin)
#elbow plot is better at showing which PC dim is best so something with std of 2ish

skin <- FindNeighbors(skin, dims = 1:10)
skin <- FindClusters(skin, resolution = 0.5)

# Look at cluster IDs of the first 5 cells
head(Idents(skin), 5)

#reticulate::py_install(packages = 'umap-learn')

skin <- RunUMAP(skin, dims = 1:10)
DimPlot(skin, reduction = "umap")

saveRDS(skin, file = "/Users/jl0l2012/Documents/ee282/wound1/Wound.rds")

# find all markers of cluster 1
cluster1.markers <- FindMarkers(skin, ident.1 = 1, min.pct = 0.25)
head(cluster1.markers, n = 5)

# find markers for every cluster compared to all remaining cells, report only the positive ones
skin.markers <- FindAllMarkers(skin, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
skin.markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_logFC)

cluster1.markers <- FindMarkers(skin, ident.1 = 0, logfc.threshold = 0.25, test.use = "roc", only.pos = TRUE)

tiff(filename="/Users/jl0l2012/Documents/ee282/wound1/VinPlotFeatures.tiff")
VlnPlot(skin, features = c("Eno3", "Pgam2","Cox7a1","Fabp3"))
dev.off()

VlnPlot(skin, features = c("Serpina3n", "Eno3", "Apoe", "Pgam2","Cox7a1"), slot = "counts", log = TRUE)

tiff(filename="/Users/jl0l2012/Documents/ee282/wound1/FeaturesCluster.tiff")
FeaturePlot(skin, features = c("Eno3", "Fabp3", "Pgam2","Cox7a1"))
dev.off()

top10 <- skin.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
DoHeatmap(skin, features = top10$gene) + NoLegend()

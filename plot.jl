import Pkg
Pkg.add("Plots")
Pkg.add("Distributions")
Pkg.add("DataFrames")
Pkg.add("StatsPlots")
using Plots
using Random
using StatsPlots
import Distributions: Uniform, Normal

# x = range(-5:5, length=10000)
# y = rand(Uniform(-1,1), 1000)
# now let's create the dataframe
using DataFrames
df = DataFrame(a=1:10, b=10*rand(10), c=10*rand(10))

# plot the dataframe by declaring the points by the column names
# x = :a, y = [:b :c] (notice that y has two columns!)
@df df plot(:a, [:b :c])
plot(Normal(-5, 5))

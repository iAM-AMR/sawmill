
# Bootstrapping the sawmill Installation

## About

The bootstrap installation method is the quickest and easiest way of getting started with `sawmill`, and is best-suited for novice R users, or experienced R users who want to quickly process timber with default settings.

[Bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping) generally refers to a program that can 'start itself'. Here, it means using code from `sawmill` to download and start `sawmill`.



## Bootstrap

### Get Code

You can download [bootstrap.R](bootstrap.R) by clicking on *bootstrap.R* in the list of files above, right-clicking on the **Raw** button, and selecting "*Save link as..*" or "*Save target as..*" in the context menu. Then, open the file in R or RStudio, and run the code.

Or, you can copy the contents of [bootstrap.R](bootstrap.R) into R or RStudio by clicking on *bootstrap.R* in the list of files above, and copying the contents.

### Run Code

Then, run the code.  

The code will install the requirements to download `sawmill`, then download it, along with its requirements. Then, it'll install it, and start the default processing pipeline.

It *should* be a 'one-click' install and run.



## Restart Processing Pipeline

If you need to restart the pipeline, run `sawmill::start_mill()` -- the last line of code in [bootstrap.R](bootstrap.R).

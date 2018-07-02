# NZ-Crime

This project is designed as a way of measuring crime in a particular New Zealand neighbourhood.

## Requirements

In order to run this analysis, data must first be downloaded from:

1. [http://www.police.govt.nz/about-us/publications-statistics/data-and-statistics/policedatanz](Police data) - the meshblock information providing crime statistics
2. [https://koordinates.com/layer/8578-nz-meshblocks-2013-census/](Meshblock GIS data) from the NZ 2013 census

## Methodology

A crime measure is made by taking each meshblock and its corresponding crime statistic, comparing its distance to other meshblocks and assigning an exponentially decreasing transformation based on distance. The theory behind this is that meshblocks with low crime may be next to meshblocks with high crime - therefore, by normalising we get a better idea of how an area is really looking.

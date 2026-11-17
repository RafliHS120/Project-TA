**Household Electricity Consumption Clustering for Targeted Energy
Efficiency Policies in Jakarta**

> **Rafli Hibriansyah Siregar^1\*^ and Fitri Kartiasih^1^**
>
> ^1^ Politeknik Statistika STIS, Jl. Otto Iskandardinata No. 64C,
> Jakarta 13330, Indonesia
>
> \*Corresponding author's email: <112313326@stis.ac.id>
>
> **Abstract.** Electricity use is the main source of greenhouse gas
> emissions in DKI Jakarta, and electricity sold to households tended to
> increase over 2018--2025. Energy-efficiency policy, however, remains
> general, and the provincial aggregate does not reveal which household
> groups differ in consumption patterns, so programmes cannot yet be
> targeted. This study describes household electricity consumption and
> socioeconomic conditions, groups households by electricity consumption
> and socioeconomic characteristics, and analyses how the resulting
> clusters differ. Using March 2025 Susenas data on 5,001 households,
> K-Means was applied to electricity consumption, non-food expenditure
> excluding electricity, and the household head\'s years of schooling,
> and cluster differences were tested with design-based Rao--Scott and
> Kruskal--Wallis tests. Weighted mean electricity consumption is 369.61
> kWh per month. Households form two clusters whose structure is weak
> (average silhouette coefficient 0.3640) but very stable (mean
> bootstrap Jaccard above 0.98). Cluster 2, representing 39.89 percent
> of households, consumes about 3.46 times as much electricity as
> Cluster 1 and has significantly higher AC ownership, refrigerator
> ownership, and floor area. These findings imply that efficiency
> programmes should be differentiated: cooling-equipment efficiency for
> Cluster 2 and access to energy-efficient cooling for Cluster 1, with
> AC ownership and floor area as practical targeting indicators.
>
> **Keyword:** cluster analysis, electricity consumption, K-Means,
> official statistics, Susenas.

1.  **Introduction**

The background study for Visi Indonesia 2045 places sustainable economic
development among the four pillars of the vision and lists improved
energy efficiency as one of the strategies for low-carbon development
\[1\]. The National Medium-Term Development Plan (RPJMN) 2025--2029
carries this direction forward by making energy self-sufficiency a
national priority \[2\]. The national electricity sector, however,
remains heavily dependent on fossil fuels, particularly coal, which in
2015 accounted for 90 percent of the national generation mix and 91
percent of the Java--Bali system \[3\]. National electricity consumption
reached 1,411 kWh per capita in 2024, and the national electrification
ratio reached 99.83 percent \[4\]. With access now almost universal, the
main issue is no longer only whether households have electricity, but
how intensively and how unequally they use it.

DKI Jakarta Province has reached an electrification ratio of 100 percent
\[4\]. Its average per capita electricity expenditure, IDR 120,220 per
month, is the highest of any province and almost three times the
national average of IDR 41,339 \[5\]. In 2025, households made up 92.49
percent of the province\'s electricity customers and consumed 16.36
billion kWh, about 42.84 percent of total electricity consumption and
more than any other sector \[6\]. Electricity sold to household
customers has also tended to rise from 13.20 billion kWh in 2018 \[6\],
\[7\]. On the environmental side, indirect emissions from electricity
use reached 34,509 Gg CO~2~e in 2024, exceeding total direct emissions
of 30,322 Gg CO~2~e and making electricity use the main contributor to
greenhouse gas emissions in DKI Jakarta, with a 53 percent share \[8\].

Large aggregate consumption does not mean that all households share the
same consumption characteristics. Variation in household electricity
consumption can be influenced by differences in welfare, household size,
the education of the household head, dwelling characteristics, and
ownership of electrical appliances such as air conditioners (AC)
\[9\]--\[12\]. This variation is consistent with the energy ladder
concept, in which rising welfare can encourage the use of modern energy,
although many households use several energy sources at the same time
(fuel stacking) \[13\]. In a metropolitan area such as Jakarta,
electricity demand is also affected by the urban heat island phenomenon
\[14\]. AC ownership increases household electricity consumption by
about 36--57 percent depending on the regional context \[12\], while the
adoption of active cooling in developing countries is influenced by
income and humidity-adjusted temperature. Households that need cooling
but cannot afford it experience an adaptation cooling deficit \[15\].

Research that specifically maps household heterogeneity in DKI Jakarta
remains limited. Kubota et al. \[9\] compared household energy
consumption in Jakarta and Bandung, Takata et al. \[16\] focused on
apartment residents, and Oktasandira \[17\] grouped electricity
customers using utility data. Studies of socioeconomic determinants
\[10\], \[11\] are dominated by regression analysis and therefore do not
directly yield a household typology. What is still missing is a mapping
of household groups in DKI Jakarta based on electricity consumption
patterns and socioeconomic characteristics using Susenas data. This gap
also affects demand-side policy. The National Energy General Plan (RUEN)
frames energy-efficiency activities in general terms, namely applying
the Indonesian National Standard (SNI) to energy-using equipment in the
household sector and providing socialisation and education on energy
saving \[18\]. Households, however, do not respond to energy-saving
efforts in the same way: those with low education are motivated mainly
by financial reasons, whereas those with high education respond more to
environmental reasons \[19\].

This study therefore aims to (1) describe the electricity consumption
profile and socioeconomic conditions of households in DKI Jakarta in
2025, (2) identify and group households based on electricity consumption
patterns and socioeconomic characteristics, and (3) analyse differences
in the socioeconomic characteristics of the resulting clusters. The
hypothesis rests on two empirical findings. In Brazil, India, Indonesia,
and Mexico, AC adoption is higher among households with higher income,
more education, and better housing, and in India and Indonesia education
and housing quality are also more strongly related to refrigerator and
AC adoption \[15\]. In Jakarta, energy consumption for AC can be
explained by floor area and household income \[9\]. The study
accordingly hypothesises that the cluster with higher electricity
consumption has a higher proportion of AC and refrigerator ownership and
a larger floor area than the other cluster. Unlike previous studies,
this study builds the household typology from official statistics,
interprets the clusters through variables not used to form them, and
tests cluster differences with procedures that account for the Susenas
sampling design.

2.  **Research Method**

    1.  *Data and variables*

This study uses secondary data from the March 2025 Susenas for DKI
Jakarta Province, published by Badan Pusat Statistik (BPS) \[20\].
Variables were taken from the core questionnaire (VSEN25.K) and from
Block IV.2 of the consumption and expenditure questionnaire (VSEN25.KP),
and the two sources were merged by household identifier. The household
is both the unit of observation and the unit of analysis. Variables fall
into two groups according to their role in the analysis (table 1):
clustering variables enter the calculation of distances between
households, whereas profiling variables do not form the clusters but are
used to characterise the clusters once formed.

**Table 1.** Research variables and their roles.

  ----------------------------------------------------------------------------
  Variable           Operational definition           Unit        Role
  ------------------ -------------------------------- ----------- ------------
  Electricity        Monthly electricity expenditure  kWh/month   Clustering
  consumption        divided by the tariff of the                 
  (*X*~1~)           connected-power class; used as               
                     ln(1 + *x*)                                  

  Non-food           Monthly non-food expenditure     IDR/month   Clustering
  expenditure        minus electricity expenditure;               
  excluding          used as ln(1 + *x*)                          
  electricity                                                     
  (*X*~2~)                                                        

  Years of schooling Equivalent years converted from  Years       Clustering
  of the household   the highest education level                  
  head (*X*~3~)      attended                                     

  Electricity        Bill payment or token purchase   IDR/month   Basis of
  expenditure        in the last month                            *X*~1~

  Household size     Number of household members      Persons     Profiling

  AC ownership       Household owns an air            Binary      Profiling
                     conditioner                                  

  Refrigerator       Household owns a refrigerator    Binary      Profiling
  ownership                                                       

  Floor area         Floor area of the dwelling       m^2^        Profiling

  Connected-power    Power of the first PLN meter:    Ordinal     Profiling;
  class              450 VA, 900 VA, 1,300 VA or more             tariff basis
  ----------------------------------------------------------------------------

Source: Susenas March 2025 \[20\], processed.

Non-food expenditure excluding electricity serves as a proxy for
household economic capacity. Consumption over a short period such as a
month is more likely to reflect a household\'s general welfare than
income over the same period, which fluctuates more, and in developing
countries expenditure is also easier to measure than income \[21\]. The
electricity component is removed from this variable so that the same
information is not counted twice in the distance calculation. Years of
schooling of the household head follow the BPS conversion table based on
the highest diploma held, ranging from 0 years for no diploma to 18
years for a master\'s or doctoral degree (S2/S3) \[22\]. Because diploma
information was not available, the conversion was applied to the highest
level attended, so the values tend to be slightly higher. Household size
is not included in the distance calculation. In Jakarta, AC energy
consumption, the main contributor to household electricity consumption,
is explained by floor area and income, whereas household size appears as
an explanatory variable for LPG consumption \[9\]. Household size is
therefore treated as a profiling variable.

2.  *Data preparation*

The kWh field in the March 2025 Susenas was empty for sample households
in DKI Jakarta, whereas monthly electricity expenditure was available
and positive for all households. Electricity consumption was therefore
derived by dividing monthly electricity expenditure by the tariff of the
household\'s connected-power class: IDR 415 per kWh for 450 VA and IDR
605 per kWh for 900 VA, as set out in Appendix II of Regulation of the
Minister of Energy and Mineral Resources Number 7 of 2024 \[23\], and
IDR 1,444.70 per kWh for 1,300 VA and above, as stated in the PLN tariff
determination for the first quarter of 2025 \[24\]. The conversion
involves three simplifications. First, all households at 1,300 VA and
above are converted at the R-1/1,300 VA tariff, including those that are
actually R-2 or R-3 customers paying IDR 1,699.53 per kWh. Second, the
prepaid tariff is applied to 450 VA and 900 VA households because
Susenas does not record each household\'s payment scheme. Third, all 900
VA households are converted at the subsidised tariff because Susenas
cannot distinguish them from the R-1/900 VA-RTM class, which pays IDR
1,352 per kWh \[24\]. Under the first and third simplifications,
converted consumption is higher than actual consumption. The variable is
therefore read as a relative measure of electricity use across
households, not as a meter reading.

Merging the two sources produced 5,079 households. Of these, 78
households (1.54 percent), comprising 66 PLN users without a meter and
12 non-PLN users, had no valid tariff class and were excluded, leaving
5,001 households for analysis: 553 at 450 VA, 1,573 at 900 VA, and 2,875
at 1,300 VA or more. In the subsidised classes, some households have
converted consumption above the upper limit of their meter capacity,
which is 324 kWh for 450 VA and 648 kWh for 900 VA if the full power is
used 24 hours a day for 30 days. This applies to 226 of 553 households
at 450 VA (40.87 percent) and 64 of 1,573 households at 900 VA (4.07
percent). The cause cannot be determined from Susenas, and these
observations were retained without correction because there is no valid
basis for assigning a replacement value.

Extreme values of the monetary variables and household size were
winsorized at the 1st and 99th percentiles, which sets the smallest and
largest values equal to the nearest retained value instead of discarding
them \[25\]. This step is taken because K-Means minimises the sum of
squared distances, so observations far from their group receive a large
weight in the criterion \[26\]. Electricity consumption and non-food
expenditure excluding electricity were then transformed with ln(1 + *x*)
because both distributions are right-skewed. Finally, the three
clustering variables were standardised because they are measured in
different units, namely kWh, rupiah, and years \[26\]:

$z_{ij} = \frac{x_{ij} - {\overline{x}}_{j}}{s_{j}}$ (1)

where *x~ij~* is the value of variable *j* (*j* = 1, 2, 3) for household
*i* after data preparation, *x̄~j~* is the mean of variable *j*, and
*s~j~* is the standard deviation of variable *j*.

3.  *Clustering procedure*

Clustering was performed with K-Means, a non-hierarchical method that
assigns each object to the cluster with the nearest centroid and updates
the centroids iteratively \[27\], \[28\]. Distances between households
are measured with the Euclidean distance:

$d\left( z_{i},\ z_{l} \right) = \sqrt{\sum_{j = 1}^{3}\left( z_{ij} - z_{lj} \right)^{2}}$
(2)

The objective function minimised by K-Means is the within-cluster sum of
squares (WCSS):

$WCSS = \sum_{k = 1}^{K}{\sum_{i \in C_{k}}^{}{\sum_{j = 1}^{3}\left( z_{ij} - {\overline{z}}_{kj} \right)^{2}}}$
(3)

where *C~k~* is the set of households in cluster *k* and *z̄~kj~* is the
centroid of cluster *k* on variable *j*. Because K-Means results can
depend on the initial values \[26\], the final K-Means was run with 100
random initialisations and a limit of 1,000 iterations, and the solution
with the lowest WCSS was retained. Hierarchical methods were not used
because a dendrogram of 5,001 objects cannot be read to determine group
boundaries and because merges in hierarchical methods cannot be undone
\[26\], \[28\].

The number of clusters was determined with the elbow method and the
silhouette coefficient for one to eight clusters. Visual identification
of the elbow point involves a subjective element and becomes ambiguous
when WCSS declines gradually \[29\], and WCSS contains no information on
the distance between clusters \[30\]. The silhouette coefficient
compares the average distance *a*(*i*) between object *i* and the other
objects in its own cluster with the smallest average distance *b*(*i*)
between object *i* and the objects of another cluster \[30\]:

$s(i) = \frac{b(i) - a(i)}{\max\left\{ a(i),\ b(i) \right\}}$ (4)

The overall quality of the clustering structure is assessed by the
average silhouette coefficient over all *n* objects:

$\overline{s} = \frac{1}{n}\sum_{i = 1}^{n}{s(i)}$ (5)

Kaufman and Rousseeuw \[31\], as cited in Everitt et al. \[26\], regard
an average silhouette coefficient above 0.5 as characterising an
adequate classification and an average below 0.2 as indicating the
absence of a meaningful cluster structure.

For comparison, K-Medoids with the Partitioning Around Medoids (PAM)
algorithm \[31\] was run on the same distance matrix for two to five
clusters using the cluster package in R \[32\]. In K-Medoids, the centre
of each cluster is an actual object (the medoid), and the objective
function is the sum of distances, rather than squared distances, between
each object and its medoid \[26\]:

$Q = \sum_{k = 1}^{K}{\min_{x_{v} \in C_{k}}{\sum_{i \in C_{k}}^{}{d\left( x_{i},\ x_{v} \right)}}}$
(6)

where *x~v~* is a candidate medoid in cluster *C~k~*. Because its centre
is an actual object that is not pulled by extreme values, K-Medoids is
more resistant to outliers than K-Means \[31\]. Agreement between the
memberships produced by the two methods is measured with the adjusted
Rand index (ARI), which equals 1 for identical clusterings and is close
to 0 when agreement is no better than chance \[33\]. In both methods,
clusters are numbered by their electricity consumption centre, so
Cluster 1 is always the lower-consumption cluster. The final method was
chosen at the same number of clusters using three criteria: the average
silhouette coefficient, bootstrap stability, and the association of
cluster membership with AC and refrigerator ownership, measured with
Cramér\'s *V*. If the two methods do not differ meaningfully, K-Means is
retained because it is consistent with the WCSS criterion used to
determine the number of clusters.

The choice of clustering variables was checked by comparing three
specifications for two to five clusters, with and without winsorizing:
S0 adds household size, S1 uses per capita values, and S2 uses household
totals. The specifications were compared on three criteria applied in
order: the association between cluster membership and AC ownership
(Cramér\'s *V*), the requirement that the smallest cluster contain at
least 10 percent of households, and the average silhouette coefficient.
Because AC ownership serves as a criterion for choosing the
specification, the difference in AC ownership between clusters is not
completely independent of the cluster formation process. Refrigerator
ownership and floor area, which are not used at any stage before
profiling, therefore serve as fully independent comparisons.

4.  *Cluster stability and contribution of clustering variables*

The silhouette coefficient evaluates a single clustering result and does
not show whether the same clusters would reappear if the data changed
slightly. Cluster stability was therefore tested with bootstrap
resampling \[34\]. A total of 100 bootstrap samples of 5,001 households
were drawn with replacement from the standardised data, and each sample
was clustered again with the same method and number of clusters. The
similarity between an original cluster *C* and a cluster *D* is measured
with the Jaccard index:

$\gamma(C,\ D) = \frac{|C \cap D|}{|C \cup D|}$ (7)

and the stability of cluster *C* is the mean Jaccard index between *C*
and its most similar cluster in each bootstrap sample:

${\overline{\gamma}}_{C} = \frac{1}{B}\sum_{b = 1}^{B}{\max_{D \in \Delta_{b}}{\gamma\left( C_{*}^{b},\ D \right)}}$
(8)

where *C*~\*~*^b^* is cluster *C* restricted to the households drawn in
sample *b* and Δ*~b~* is the set of clusters obtained from sample *b*
\[34\]. A mean Jaccard index of 0.5 or less indicates a dissolved
cluster \[35\], whereas a mean of 0.75 or more indicates a stable
cluster and 0.85 or more a very stable cluster \[36\]. High stability
does not guarantee a meaningful cluster, because a rigid method can
produce clusters that are stable but not meaningful \[34\]; the Jaccard
index is therefore read together with the silhouette coefficient. The
procedure was run with the clusterboot function in the fpc package
\[36\] for both K-Means and K-Medoids using the same random seed.

The role of each clustering variable was examined in two ways. First,
the *R*^2^ of each variable was calculated as the ratio of its
between-cluster sum of squares to its total sum of squares \[26\],
\[28\]. Second, K-Means was rerun three times, each time omitting one
clustering variable, and the resulting memberships were compared with
the final clusters using ARI \[33\]; the variable whose removal lowers
ARI the most is the one that most determines cluster membership. Both
measures are descriptive and are not treated as hypothesis tests.

5.  *Cluster profiling and hypothesis testing*

The clusters were formed without survey weights. Cluster analysis is
exploratory, in that it seeks natural groupings among objects based on
measured similarity \[37\]. The clustering stage is therefore directed
at similarity among sample households, while the Susenas weights are
applied at the reporting stage so that the figures describe all
households in DKI Jakarta. The clustering variables are only described,
without statistical tests, because the clustering procedure itself
maximises between-cluster differences on these variables, which makes
standard tests such as analysis of variance inappropriate \[26\]. Tests
are applied only to profiling variables, with the null hypothesis that a
variable\'s distribution is the same in all clusters and the alternative
that it differs in at least one cluster. The study hypothesis is
supported if AC ownership, refrigerator ownership, and floor area differ
significantly at the 1 percent level in the design-based tests and all
three show the hypothesised direction.

Each test was run in two versions, without weights and with the survey
design. Differences in categorical variables were tested with the
Pearson chi-square test of independence:

$\chi^{2} = \sum_{k = 1}^{K}{\sum_{j = 1}^{J}\frac{\left( O_{kj} - E_{kj} \right)^{2}}{E_{kj}}},\quad\quad E_{kj} = \frac{n_{k \cdot}n_{\cdot j}}{n}$
(9)

where *O~kj~* is the number of households in cluster *k* and category
*j*, *E~kj~* is the expected frequency under the null hypothesis,
*n~k~*~·~ and *n*~·*j*~ are the row and column totals, and *n* is the
number of households. Under a sampling design with stratification and
clustering in primary sampling units (PSUs), the Pearson chi-square
statistic no longer follows a chi-square distribution \[38\], so the
weighted version applies the second-order Rao--Scott correction through
the svychisq function in the survey package \[38\], \[39\]. The strength
of association is measured with Cramér\'s *V* \[40\]:

$V = \sqrt{\frac{\chi^{2}}{n\left( \min(K,\ J) - 1 \right)}}$ (10)

which is calculated from the unweighted chi-square statistic. Floor area
and household size were tested with the Kruskal--Wallis test \[41\]:

$H = \frac{12}{N(N + 1)}\sum_{k = 1}^{K}\frac{R_{k}^{2}}{n_{k}} - 3(N + 1)$
(11)

where *R~k~* is the sum of ranks and *n~k~* the number of households in
cluster *k*, and *N* is the total number of households, with a
correction for ties \[41\]. The design-based version replaces sample
ranks with estimated population mid-ranks and compares their weighted
means across clusters; for two groups, the test is carried out as a
weighted *t*-test \[42\] with the svyranktest function. The sampling
design was specified with three elements of the Susenas design (PSU,
strata, and household weights), comprising 512 PSUs in 6 strata, using
the survey package in R \[39\].

3.  **Result and Discussion**

    1.  *Electricity consumption and socioeconomic characteristics of
        households*

The weighted mean electricity consumption of households in DKI Jakarta
is 369.61 kWh per month, with a standard error of 15.83 kWh (table 2).
The distribution is skewed to the right: the sample standard deviation
(353.88 kWh) exceeds the sample mean, and the median of 222.19 kWh lies
far below the sample mean of 327.45 kWh. Most households consume little,
while a small number of very high consumers pull the mean upward. The
weighted mean exceeds the sample mean, indicating that high-consuming
households carry more weight in the population than their share of the
sample suggests.

**Table 2.** Descriptive statistics of the research variables, DKI
Jakarta, March 2025 (*n* = 5,001).

  -----------------------------------------------------------------------------------------
  Variable             Sample mean SD          Min       Max          Weighted    SE
                                                                      mean        
  -------------------- ----------- ----------- --------- ------------ ----------- ---------
  Electricity          327.45      353.88      37.38     2,335.43     369.61      15.83
  consumption                                                                     
  (kWh/month)                                                                     

  Electricity          132.98      172.09      6.43      2,335.43     115.45      5.03
  consumption per                                                                 
  capita (kWh/month)                                                              

  Electricity          348,967     436,012     33,000    2,689,200    423,230     21,808
  expenditure                                                                     
  (IDR/month)                                                                     

  Non-food expenditure 4,654,809   5,918,258   618,667   37,010,083   5,825,672   291,320
  excl. electricity                                                               
  (IDR/month)                                                                     

  Electricity share of 0.0764      0.0414      0.0057    0.4100       0.0728      0.0012
  non-food expenditure                                                            

  Years of schooling   10.98       3.37        0         18           11.39       0.09
  of the head                                                                     

  Household size       3.10        1.37        1         6            3.68        0.03
  (persons)                                                                       
  -----------------------------------------------------------------------------------------

Notes: Minimum and maximum are computed after winsorizing, except for
years of schooling. Standard errors (SE) of weighted means account for
PSUs and strata. Source: Susenas March 2025, processed.

Electricity expenditure follows a similar pattern, with a weighted mean
of IDR 423,230 per month against a median of IDR 204,000. Electricity
nonetheless absorbs only 7.28 percent of non-food expenditure. Economic
capacity, represented by non-food expenditure excluding electricity, has
a weighted mean of IDR 5,825,672 per month and a median of IDR
2,714,820, and its standard deviation again exceeds its mean. Economic
capacity is thus more unequally distributed across households in DKI
Jakarta than electricity consumption. Households with larger non-food
expenditure tend to consume more electricity, but the relationship is
not tight, so clustering on a single economic dimension would not be
adequate. The household head has on average 11.39 years of schooling,
close to completing senior high school, and the average household size
is 3.68 persons.

2.  *Formation of household clusters*

The number of clusters was determined by comparing WCSS through the
elbow method and the average silhouette coefficient for one to eight
clusters (table 3 and figure 1).

**Table 3.** WCSS and average silhouette coefficient by number of
clusters, DKI Jakarta,

March 2025 (*n* = 5,001).

  ------------------------------------------------------------------------
  *K*      WCSS           Decrease in WCSS  Silhouette,    Silhouette,
                                            K-Means        K-Medoids
  -------- -------------- ----------------- -------------- ---------------
  1        15,000.00      --                --             --

  2        8,806.23       6,193.77          0.3640         0.3227

  3        6,578.36       2,227.88          0.3149         0.3064

  4        5,362.93       1,215.43          0.2907         0.2872

  5        4,643.41       719.52            0.2848         0.2481

  6        4,162.75       480.66            0.2643         --

  7        3,751.59       411.17            0.2728         --

  8        3,433.24       318.35            0.2786         --
  ------------------------------------------------------------------------

Notes: WCSS refers to K-Means. The silhouette is undefined for one
cluster;

K-Medoids was run for *K* = 2 to 5.

Source: Susenas March 2025, processed.

![](/tmp/dropmedia/media/image1.png){width="6.2in"
height="2.342594050743657in"}

**Figure 1.** (a) WCSS and (b) average silhouette coefficient by number
of clusters. The vertical axis of (b) starts at 0.20.

WCSS for one cluster is exactly 15,000, the product of 5,000 degrees of
freedom and three clustering variables (table 3). Moving from one to two
clusters reduces WCSS by 6,193.77, more than 40 percent of the total
variance, whereas the next cluster removes only 2,227.88, and the
reductions keep shrinking thereafter. The elbow therefore lies in the
range of two to three clusters. The average silhouette coefficient
reaches its highest value at two clusters, 0.3640 (figure 1(b)), then
declines to a minimum of 0.2643 at six clusters before rising slightly
at seven and eight. Both criteria point in the same direction, and two
clusters were set as the final solution. K-Medoids also yields its
highest silhouette coefficient at two clusters (0.3227), so the number
of clusters does not depend on the choice of method.

The magnitude of the coefficient nevertheless deserves attention. A
value of 0.3640 lies between the 0.5 threshold for an adequate
classification and the 0.2 threshold for the absence of meaningful
structure \[26\], \[31\]. The cluster structure in these data is
therefore weak: households in DKI Jakarta do not separate into groups
with clear boundaries but form a continuous distribution that the
algorithm then divides. The weak structure is unlikely to be an artefact
of the specifications examined. Across the 24 combinations of
specification, winsorizing, and two to five clusters, none exceeded
0.37. At two clusters, the values are 0.2807 for S0, 0.3666 for S1, and
0.3640 for S2, and without winsorizing S2 changes only to 0.3627.
Removing one of the three clustering variables raises the silhouette
coefficient to at most 0.4550. S1 was not chosen despite its slightly
higher silhouette coefficient because its association with AC ownership
is clearly weaker (Cramér\'s *V* 0.436 versus 0.553 for S2). Without the
logarithmic transformation, the silhouette coefficient rises sharply to
0.6548. This gain, however, comes from separating one small cluster of
408 households (8.16 percent of the sample) in the upper tail of the
expenditure distribution, while the association with AC ownership
weakens (*V* = 0.3759). The higher coefficient of the untransformed
version thus reflects the separation of outliers, not a sharper
socioeconomic structure. The comparison with K-Medoids is presented in
table 4.

**Table 4.** Comparison of K-Means and K-Medoids at two clusters, DKI
Jakarta, March 2025.

  ------------------------------------------------------------------------
  Measure                            K-Means            K-Medoids
  ---------------------------------- ------------------ ------------------
  Sample households, cluster 1 /     3,329 / 1,672      2,538 / 2,463
  cluster 2                                             

  Weighted share (%), cluster 1 /    60.11 / 39.89      43.43 / 56.57
  cluster 2                                             

  Average silhouette coefficient     0.3640             0.3227

  Cramér's *V*, AC ownership         0.5530             0.5124

  Cramér's *V*, refrigerator         0.2144             0.2414
  ownership                                             

  Mean bootstrap Jaccard, cluster 1  0.9911 / 0.9823    0.9860 / 0.9857
  / cluster 2                                           
  ------------------------------------------------------------------------

Notes: Weighted shares use Susenas household weights. Jaccard
coefficients are means over 100 bootstrap samples.

Source: Susenas March 2025, processed.

K-Means has a higher average silhouette coefficient than K-Medoids at
every number of clusters, with the largest gap at two clusters (0.3640
versus 0.3227; tables 3 and 4). Its cluster membership is also more
strongly associated with AC ownership (Cramér\'s *V* 0.5530 versus
0.5124), whereas the association with refrigerator ownership is slightly
stronger for K-Medoids (0.2414 versus 0.2144). Stability does not
distinguish the two methods, since every cluster in both has a mean
Jaccard index above 0.98. K-Means was therefore adopted as the final
method. The two memberships are nonetheless not identical: 84.18 percent
of households fall in the same-numbered cluster, with an ARI of 0.4673.
All disagreements involve 791 households that belong to Cluster 1 under
K-Means but to Cluster 2 under K-Medoids. These households have an
average silhouette coefficient of 0.1765 in the K-Means partition, far
below that of the households that do not move (0.3992), so the
reassignment takes place around the boundary between the two clusters.
As a result, the weighted composition reverses from 60.11 and 39.89
percent under K-Means to 43.43 and 56.57 percent under K-Medoids; the
share of each cluster therefore depends on where the method places the
boundary.

K-Means clustering of the 5,001 households yields Cluster 1 with 3,329
households (66.57 percent of the sample) and Cluster 2 with 1,672
households (33.43 percent). With the Susenas weights applied, the shares
become 60.11 and 39.89 percent, respectively. Table 5 presents the
cluster centroids.

**Table 5.** Cluster centroids (z-scores) and contribution of the
clustering variables, K-Means.

  -----------------------------------------------------------------------------
  Clustering variable      Cluster 1 Cluster 2 Difference   *R*^2^   ARI if
                                                            (%)      removed
  ------------------------ --------- --------- ------------ -------- ----------
  ln electricity           −0.4548   0.9055    1.3603       41.19    0.6482
  consumption                                                        

  ln non-food expenditure  −0.5099   1.0152    1.5252       51.78    0.5496
  excl. electricity                                                  

  Years of schooling of    −0.3939   0.7843    1.1783       30.90    0.6880
  the head                                                           
  -----------------------------------------------------------------------------

Notes: Differences are computed from unrounded centroids. ARI compares
K-Means without the variable with the final partition.

Source: Susenas March 2025, processed.

The two clusters separate in a uniform direction (table 5): all three
centroids of Cluster 1 lie below the overall mean, and all three
centroids of Cluster 2 lie above it. The clusters are thus distinguished
by level, with all three variables jointly high or jointly low, rather
than by composition. The centroid gap is largest for non-food
expenditure excluding electricity, followed by electricity consumption
and the household head\'s years of schooling. Removing non-food
expenditure excluding electricity gives the lowest ARI against the final
clusters (0.5496), with 87.10 percent of households remaining in the
same cluster; removing electricity consumption gives an ARI of 0.6482,
with 90.34 percent remaining. Non-food expenditure excluding electricity
is therefore the strongest separator, but electricity consumption still
plays a role, since removing it moves about one in ten households to the
other cluster.

The distributions of the three clustering variables by cluster (figure
2) show the same ordering. For non-food expenditure excluding
electricity, the two histograms overlap only within a relatively narrow
range of z-scores, around 0 to 0.8. The overlap is wider for electricity
consumption, so a fair number of households with similar electricity
consumption fall in different clusters. Years of schooling of the
household head takes only a few values because it follows education
levels; both clusters are common at the value corresponding to completed
senior high school, while higher values come almost entirely from
Cluster 2.

![](/tmp/dropmedia/media/image2.png){width="3.9in" height="3.9in"}

**Figure 2.** Histograms of the clustering variables by cluster on the
z-score scale, DKI Jakarta, March 2025.

Notes: Medium-shaded bars show where the histograms of the two clusters
overlap; the bars at the ends of the first two panels result from
winsorizing at the 1st and 99th percentiles.

Source: Susenas March 2025, processed.

The projection of the three standardised variables onto principal
components (figure 3) supports this result. The first component explains
65.42 percent of the variance and has positive loadings of similar size
(0.5822, 0.6397, and 0.5018), so it can be read as the general level of
electricity consumption and socioeconomic status. The second component
explains 23.88 percent and contrasts electricity consumption with years
of schooling. The centroids of Cluster 1 and Cluster 2 lie at −0.7887
and 1.5703 on the first component, whereas on the second they
practically coincide at zero (0.0002 and −0.0004). The two clusters are
therefore separated along a single axis of electricity consumption and
socioeconomic level. This also explains the weak silhouette coefficient,
since households are spread continuously along that axis without a gap.
The bootstrap results, in contrast, show that the two clusters are very
stable. This stability does not mean that households are naturally
divided into two separate groups, but that the division of the
continuous distribution does not depend on a particular sample.

![](/tmp/dropmedia/media/image3.png){width="3.560249343832021in"
height="2.669288057742782in"}

**Figure 3.** Household clusters on the first two principal components
of the standardised clustering variables, DKI Jakarta, March 2025.
Polygons are the convex hulls of the clusters and the larger markers are
the cluster centroids.

Source: Susenas March 2025, processed.

3.  *Differences in characteristics between clusters*

Table 6 presents the profile of the two clusters. Cluster 1 represents
about 1.74 million households (60.11 percent of households in DKI
Jakarta) and Cluster 2 about 1.16 million (39.89 percent). Mean
consumption in Cluster 2 is 645.34 kWh per month, about 3.46 times the
Cluster 1 mean of 186.61 kWh. The gap persists per household member, at
198.88 versus 60.08 kWh per capita, or about 3.31 times, so it cannot be
explained by the number of household members but by the intensity of
electricity use per person. Mean non-food expenditure excluding
electricity in Cluster 2 is about 4.31 times that of Cluster 1, yet the
share of electricity in non-food expenditure is almost the same in both
clusters, at 7.05 and 7.63 percent. The clusters differ in the size of
the budget, not in the share allocated to electricity. The household
head has on average 9.83 years of schooling in Cluster 1 and 13.74 years
in Cluster 2. Household heads with higher education account for only
2.91 percent of Cluster 1 but form the largest group in Cluster 2, at
50.44 percent.

**Table 6.** Weighted profile of households by cluster, DKI Jakarta,
March 2025.

  ------------------------------------------------------------------------
  Indicator                                      Cluster 1    Cluster 2
  ---------------------------------------------- ------------ ------------
  Sample households                              3,329        1,672

  Weighted households                            1,744,440    1,157,822

  Weighted share (%)                             60.11        39.89

  *Clustering variables and related indicators*               

  Electricity consumption, mean (kWh/month)      186.61       645.34

  Electricity consumption, median (kWh/month)    163.36       435.05

  Electricity consumption per capita, mean       60.08        198.88
  (kWh/month)                                                 

  Electricity expenditure, mean (IDR/month)      180,146      789,474

  Non-food expenditure excl. electricity, mean   2,509,606    10,821,847
  (IDR/month)                                                 

  Non-food expenditure excl. electricity, median 2,030,833    6,140,250
  (IDR/month)                                                 

  Electricity share of non-food expenditure,     7.05         7.63
  mean (%)                                                    

  Years of schooling of the head, mean           9.83         13.74

  *Profiling variables*                                       

  AC ownership (%)                               17.02        76.07

  Refrigerator ownership (%)                     87.27        98.25

  Floor area, mean (m^2^)                        42.52        106.17

  Floor area, median (m^2^)                      30           80

  Connected power 450 VA (%)                     8.9          6.3

  Connected power 900 VA (%)                     37.1         15.6

  Connected power 1,300 VA or more (%)           53.9         78.1

  Household size, weighted mean (persons)        3.65         3.71

  Household size, unweighted mean (persons)      3.03         3.24
  ------------------------------------------------------------------------

> Notes: Means and percentages are weighted with Susenas household
> weights unless stated otherwise; medians are unweighted. Floor area is
> winsorized at the 1st and 99th percentiles.
>
> Source: Susenas March 2025, processed.

Differences in the clustering variables cannot serve as evidence,
because these variables determine cluster membership; the evidence must
come from variables the algorithm does not use. Mean floor area in
Cluster 2 is about two and a half times that of Cluster 1, a difference
of about 64 m^2^, while the medians differ by 50 m^2^ (table 6). AC
ownership differs by 59 percentage points: three in four households in
Cluster 2 own an AC, compared with fewer than one in five in Cluster 1.
Refrigerator ownership shows a different pattern. The difference runs in
the same direction (98.25 versus 87.27 percent) but amounts to only
about eleven percentage points, because almost all households in both
clusters already own a refrigerator. The difference between the groups
therefore lies not in basic household equipment but in additional
high-power equipment such as AC. Most households in Cluster 2 have a
connected power of 1,300 VA or more (78.1 percent, against 53.9 percent
in Cluster 1). Because connected-power class sets the conversion tariff,
however, this distribution is presented only as a description of the
electricity characteristics of the two clusters.

**Table 7.** Tests of differences in profiling variables between
clusters, DKI Jakarta, March 2025.

  -----------------------------------------------------------------------------------------------------------------
  Profiling         Unweighted test   Statistic     *p*-value   Design-based test Statistic     *p*-value   *V*
  variable                                                                                                  
  ----------------- ----------------- ------------- ----------- ----------------- ------------- ----------- -------
  Floor area        Kruskal--Wallis   *H* =         \<0.001     Design-based      *t* = 24.356  \<0.001     --
                                      1,154.5859                Kruskal--Wallis   (df 505)                  
                                      (df 1)                                                                

  AC ownership      Pearson χ^2^      χ^2^ =        \<0.001     Rao--Scott,       *F* = 733.40  \<0.001     0.553
                                      1,529.4057                second order      (df 1; 506)               
                                      (df 1)                                                                

  Refrigerator      Pearson χ^2^      χ^2^ =        \<0.001     Rao--Scott,       *F* = 91.593  \<0.001     0.214
  ownership                           229.8040 (df              second order      (df 1; 506)               
                                      1)                                                                    

  Connected-power   Pearson χ^2^      χ^2^ = 292.96 \<0.001     Rao--Scott,       *F* = 62.124  \<0.001     0.242
  class                               (df 2)                    second order      (df 1.99;                 
                                                                                  1,008.05)                 

  Household size    Kruskal--Wallis   *H* = 24.2546 \<0.001     Design-based      *t* = 0.912   0.362       --
                                      (df 1)                    Kruskal--Wallis   (df 505)                  
  -----------------------------------------------------------------------------------------------------------------

Notes: Pearson chi-square is computed without Yates' correction.
Design-based tests account for weights, PSUs and strata; *F* degrees of
freedom are given as (numerator; denominator). Cramér's *V* is computed
from the unweighted chi-square.

Source: Susenas March 2025, processed.

Four of the five profiling variables (floor area, AC ownership,
refrigerator ownership, and connected-power class) differ significantly
between clusters at the 1 percent level, and this conclusion holds both
without weights and under the sampling design (table 7). Household size
is the only exception: its difference is significant in the unweighted
test (*p* \< 0.001) but not in the design-based test (*p* = 0.362) and
amounts to only 0.06 persons, so household size is not treated as a
characteristic that distinguishes the two clusters. Among the
categorical variables, AC ownership has a Cramér\'s *V* of 0.553, more
than twice that of connected-power class (0.242) and refrigerator
ownership (0.214).

These results form the basis for the hypothesis decision. The three
profiling variables named in the hypothesis differ significantly at the
1 percent level in the weighted tests, all in the hypothesised
direction, so the study hypothesis is supported. The three variables,
however, do not support it equally. AC ownership was used as a criterion
in choosing the specification of clustering variables, so its difference
is not completely independent of the cluster formation process.
Refrigerator ownership and floor area were not used at any stage before
profiling and show the same direction, so the support for the hypothesis
does not rest on AC ownership alone. Of these two, floor area provides
the clearer support, whereas the difference in refrigerator ownership is
small. This pattern is in line with previous research. Kubota et al.
\[9\] found AC to be a main determinant of household electricity
consumption in Jakarta, while refrigerator ownership remained high in
all of their household clusters. De Cian et al. \[12\] likewise found
that AC ownership significantly increases household electricity
consumption. The pattern is also in line with the energy ladder \[10\],
\[13\].

The difference in AC ownership also indicates which households may
experience an adaptation cooling deficit, that is, households that need
cooling but cannot obtain an AC \[15\]. The indication points to Cluster
1: more than four in five households in this cluster do not own an AC,
and their mean non-food expenditure excluding electricity is less than a
quarter of that in Cluster 2. Because this indication rests on low AC
ownership and economic capacity rather than on household-level
measurement of heat exposure, it is not interpreted as the size of the
adaptation cooling deficit itself.

This study has several limitations. Electricity consumption is derived
by converting expenditure with tariffs rather than taken from meter
records, and the conversion simplifications make the converted
consumption of some 900 VA and 1,300 VA-or-more households higher than
actual, while 40.87 percent of 450 VA households exceed their meter
capacity for reasons that cannot be identified from Susenas. The
analysis covers only households with PLN meters; the 78 excluded
households have lower average schooling of the household head (9.62
years) and lower AC ownership (10.3 percent), so the results do not
represent them. The data are also cross-sectional for a single period
and therefore describe household conditions in 2025 only.

4.  **Conclusion**

Household electricity consumption in DKI Jakarta in March 2025 is
right-skewed: the weighted mean reaches 369.61 kWh per month, whereas
the sample median is only 222.19 kWh. Based on electricity consumption,
non-food expenditure excluding electricity, and the household head\'s
years of schooling, households in DKI Jakarta fall into two clusters.
The average silhouette coefficient of 0.3640 indicates a weak cluster
structure, so the two clusters are better read as a division of a
continuous distribution than as groups with clear boundaries. Both
clusters are nonetheless very stable in the bootstrap test, with mean
Jaccard indices of 0.9911 and 0.9823. Cluster 2, representing 39.89
percent of households, consumes about 3.46 times as much electricity as
Cluster 1. Floor area, AC ownership, and refrigerator ownership differ
significantly between the two clusters at the 1 percent level and in the
hypothesised direction, while household size does not differ
significantly once the Susenas sampling design is taken into account.

These findings have three implications. First, the energy-efficiency
approach of the National Energy General Plan (RUEN), which applies SNI
to energy-using equipment and promotes energy saving through
socialisation \[18\], does not distinguish between household groups,
even though the two clusters differ in electricity consumption, economic
capacity, and ownership of high-power equipment. Household
energy-efficiency programmes in DKI Jakarta therefore need to be
differentiated by cluster. For Cluster 2, with more than three times the
electricity consumption of Cluster 1 and 76.07 percent AC ownership,
programmes are better directed at the efficiency of cooling and other
high-power equipment, for example by applying SNI to AC. Because
household heads with higher education form the largest group in this
cluster, socialisation can also emphasise environmental reasons, to
which more educated households tend to respond \[19\]. For Cluster 1,
electricity consumption is already low, so saving is not a reasonable
target; given the indication of an adaptation cooling deficit,
programmes are better directed at access to energy-efficient cooling
equipment. Second, floor area and AC ownership differ sharply between
clusters and are already recorded in Susenas, so both can be considered
practical indicators for identifying target households without measuring
electricity consumption directly. Third, for official statistics,
filling the kWh field in Susenas would allow household electricity
consumption to be measured directly rather than converted from
expenditure and tariffs. Further research could use metered consumption
data, compare K-Means with clustering methods that do not impose sharp
boundaries between groups, and incorporate the sampling design into the
clustering process itself.

**Acknowledgement**

The authors thank Badan Pusat Statistik (BPS) for the March 2025 Susenas
data.

**References**

\[1\] Kementerian PPN/Bappenas, *Background Study Visi Indonesia 2045:
Indonesia 2045 Berdaulat, Maju, Adil, dan Makmur*. Kementerian
PPN/Bappenas, 2019.

\[2\] Kementerian PPN/Bappenas, *Rencana Pembangunan Jangka Menengah
Nasional Tahun 2025--2029*. Kementerian PPN/Bappenas, 2025.

\[3\] K. Handayani, Y. Krozer, and T. Filatova, "Trade-offs between
electrification and climate change mitigation: An analysis of the
Java-Bali power system in Indonesia," *Appl. Energy*, vol. 208, pp.
1020--1037, 2017, doi: 10.1016/j.apenergy.2017.09.048.

\[4\] Badan Pusat Statistik and Kementerian PPN/Bappenas, *Indikator
Tujuan Pembangunan Berkelanjutan Indonesia 2025*, vol. 9, Publication
No. 07300.25034. Badan Pusat Statistik, 2025.

\[5\] Badan Pusat Statistik, *Indikator Perumahan dan Kesehatan
Lingkungan 2025*, vol. 11, Publication No. 04200.25024. Badan Pusat
Statistik, 2025.

\[6\] Badan Pusat Statistik Provinsi DKI Jakarta, *Provinsi DKI Jakarta
dalam Angka 2026*, vol. 56, Publication No. 31000.26005. Badan Pusat
Statistik Provinsi DKI Jakarta, 2026.

\[7\] Badan Pusat Statistik Provinsi DKI Jakarta, *Provinsi DKI Jakarta
dalam Angka 2019*, Publication No. 31000.1901. Badan Pusat Statistik
Provinsi DKI Jakarta, 2019.

\[8\] Dinas Lingkungan Hidup Provinsi DKI Jakarta, *Laporan Akhir
Inventarisasi Profil Emisi dan Pelaporan Penurunan Emisi Gas Rumah Kaca
Provinsi DKI Jakarta*. Dinas Lingkungan Hidup Provinsi DKI Jakarta,
2024.

\[9\] T. Kubota, U. Surahman, and O. Higashi, "A comparative analysis of
household energy consumption in Jakarta and Bandung," in *Proc. 30th
Int. PLEA Conf.*, Ahmedabad, India, 2014.

\[10\] M. Nazer and H. Handra, "Analisis konsumsi energi rumah tangga
perkotaan di Indonesia: Periode tahun 2008 dan 2011," *J. Ekon. Pembang.
Indones.*, vol. 16, no. 2, pp. 141--153, 2016, doi:
10.21002/jepi.v16i2.04.

\[11\] S. S. S. Ali, M. R. Razman, A. Awang, M. R. M. Asyraf, M. R.
Ishak, R. A. Ilyas, and R. J. Lawrence, "Critical determinants of
household electricity consumption in a rapidly growing city,"
*Sustainability*, vol. 13, no. 8, Art. no. 4441, 2021, doi:
10.3390/su13084441.

\[12\] E. De Cian, G. Falchetta, F. Pavanello, Y. Romitti, and I. S.
Wing, "The impact of air conditioning on residential electricity
consumption across world countries," *J. Environ. Econ. Manage.*, vol.
131, Art. no. 103122, 2025, doi: 10.1016/j.jeem.2025.103122.

\[13\] B. van der Kroon, R. Brouwer, and P. J. H. van Beukering, "The
energy ladder: Theoretical myth or empirical truth? Results from a
meta-analysis," *Renew. Sustain. Energy Rev.*, vol. 20, pp. 504--513,
2013, doi: 10.1016/j.rser.2012.11.045.

\[14\] S. Siswanto, D. E. Nuryanto, M. R. Ferdiansyah, A. D. Prastiwi,
O. C. Dewi, A. Gamal, and M. Dimyati, "Spatio-temporal characteristics
of urban heat island of Jakarta metropolitan," *Remote Sens. Appl.: Soc.
Environ.*, vol. 32, Art. no. 101062, 2023, doi:
10.1016/j.rsase.2023.101062.

\[15\] F. Pavanello, E. De Cian, M. Davide, M. Mistry, T. Cruz, P.
Bezerra, D. Jagu, S. Renner, R. Schaeffer, and A. F. P. Lucena,
"Air-conditioning and the adaptation cooling deficit in emerging
economies," *Nat. Commun.*, vol. 12, Art. no. 6460, 2021, doi:
10.1038/s41467-021-26592-2.

\[16\] Y. Takata, T. Kubota, S. N. Pratiwi, and H. A. Sani,
"Classification of daily lifestyle patterns and their relationships with
household energy consumption in apartment buildings: A case study of
Indonesia," *J. Asian Archit. Build. Eng.*, 2025, doi:
10.1080/13467581.2025.2574558.

\[17\] A. Oktasandira, "Analisis klaster pelanggan listrik berdasarkan
perilaku konsumsi di Kota Sukabumi menggunakan metode K-Means
clustering," Undergraduate thesis, Universitas Nusa Putra, Sukabumi,
Indonesia, 2025.

\[18\] Presiden Republik Indonesia, *Peraturan Presiden Republik
Indonesia Nomor 22 Tahun 2017 tentang Rencana Umum Energi Nasional*.
Lembaran Negara Republik Indonesia Tahun 2017 Nomor 43, 2017.

\[19\] B. Mills and J. Schleich, "Residential energy-efficient
technology adoption, energy conservation, knowledge, and attitudes: An
analysis of European countries," *Energy Policy*, vol. 49, pp. 616--628,
2012, doi: 10.1016/j.enpol.2012.07.008.

\[20\] Badan Pusat Statistik, *Survei Sosial Ekonomi Nasional (Susenas)
Maret 2025: Kuesioner VSEN25.K dan VSEN25.KP* \[Data set\]. Badan Pusat
Statistik, 2025.

\[21\] J. Haughton and S. R. Khandker, *Handbook on Poverty and
Inequality*. World Bank, 2009, doi: 10.1596/978-0-8213-7613-3.

\[22\] Badan Pusat Statistik Kota Yogyakarta, *Indeks Pembangunan
Manusia Kota Yogyakarta 2025*, vol. 12, Publication No. 34710.26006.
Badan Pusat Statistik Kota Yogyakarta, 2026.

\[23\] Kementerian Energi dan Sumber Daya Mineral, *Peraturan Menteri
Energi dan Sumber Daya Mineral Nomor 7 Tahun 2024 tentang Tarif Tenaga
Listrik yang Disediakan oleh PT Perusahaan Listrik Negara (Persero)*.
Berita Negara Republik Indonesia Tahun 2024, 2024.

\[24\] PT PLN (Persero), *Penetapan Tarif Tenaga Listrik PT PLN
(Persero) Periode Triwulan I Tahun 2025*. PT PLN (Persero), 2025.

\[25\] P. Mair and R. Wilcox, "Robust statistical methods in R using the
WRS2 package," *Behav. Res. Methods*, vol. 52, pp. 464--488, 2020, doi:
10.3758/s13428-019-01246-w.

\[26\] B. S. Everitt, S. Landau, M. Leese, and D. Stahl, *Cluster
Analysis*, 5th ed. John Wiley & Sons, 2011.

\[27\] J. MacQueen, "Some methods for classification and analysis of
multivariate observations," in *Proc. Fifth Berkeley Symp. Math.
Statist. Probab.*, L. Le Cam and J. Neyman, Eds., vol. 1. University of
California Press, 1967, pp. 281--297.

\[28\] R. A. Johnson and D. W. Wichern, *Applied Multivariate
Statistical Analysis*, 6th ed. Pearson Education Limited, 2014.

\[29\] I. H. Hassan, M. Abdullahi, B. I. Ahmad, and S. A. Yusuf,
"Analysis of techniques for selecting appropriate number of clusters in
k-means clustering algorithm," in *Proc. Int. Conf. Comput. Adv. Inf.
Technol. (ICCAIT 2021)*, Department of Computer Science, Ahmadu Bello
University, 2021, pp. 90--96.

\[30\] P. J. Rousseeuw, "Silhouettes: A graphical aid to the
interpretation and validation of cluster analysis," *J. Comput. Appl.
Math.*, vol. 20, pp. 53--65, 1987, doi: 10.1016/0377-0427(87)90125-7.

\[31\] L. Kaufman and P. J. Rousseeuw, *Finding Groups in Data: An
Introduction to Cluster Analysis*. John Wiley & Sons, 1990, doi:
10.1002/9780470316801.

\[32\] M. Maechler, P. Rousseeuw, A. Struyf, M. Hubert, and K. Hornik,
*cluster: Cluster Analysis Basics and Extensions*, R package version
2.1.8.2, 2026. \[Online\]. Available:
https://CRAN.R-project.org/package=cluster

\[33\] L. Hubert and P. Arabie, "Comparing partitions," *J. Classif.*,
vol. 2, no. 1, pp. 193--218, 1985, doi: 10.1007/BF01908075.

\[34\] C. Hennig, "Cluster-wise assessment of cluster stability,"
*Comput. Stat. Data Anal.*, vol. 52, no. 1, pp. 258--271, 2007, doi:
10.1016/j.csda.2006.11.025.

\[35\] C. Hennig, "Dissolution point and isolation robustness:
Robustness criteria for general cluster analysis methods," *J.
Multivariate Anal.*, vol. 99, no. 6, pp. 1154--1176, 2008, doi:
10.1016/j.jmva.2007.07.002.

\[36\] C. Hennig, *fpc: Flexible Procedures for Clustering*, R package
version 2.2-15, 2026. \[Online\]. Available:
https://CRAN.R-project.org/package=fpc

\[37\] A. K. Jain, "Data clustering: 50 years beyond K-means," *Pattern
Recognit. Lett.*, vol. 31, no. 8, pp. 651--666, 2010, doi:
10.1016/j.patrec.2009.09.011.

\[38\] J. N. K. Rao and A. J. Scott, "On chi-squared tests for multiway
contingency tables with cell proportions estimated from survey data,"
*Ann. Statist.*, vol. 12, no. 1, pp. 46--60, 1984.

\[39\] T. Lumley, *survey: Analysis of Complex Survey Samples*, R
package version 4.5, 2024. \[Online\]. Available:
https://CRAN.R-project.org/package=survey

\[40\] W. Bergsma, "A bias-correction for Cramér\'s V and Tschuprow\'s
T," *J. Korean Statist. Soc.*, vol. 42, no. 3, pp. 323--328, 2013, doi:
10.1016/j.jkss.2012.10.002.

\[41\] W. H. Kruskal and W. A. Wallis, "Use of ranks in one-criterion
variance analysis," *J. Amer. Statist. Assoc.*, vol. 47, no. 260, pp.
583--621, 1952, doi: 10.1080/01621459.1952.10483441.

\[42\] T. Lumley and A. Scott, "Two-sample rank tests under complex
sampling," Technical report, Department of Statistics, University of
Auckland, 2012.

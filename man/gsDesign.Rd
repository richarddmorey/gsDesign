\name{gsDesign}
\alias{gsDesign}
\title{2.1: Design Derivation}
\description{\code{gsDesign()} is used to find boundaries and trial size required for a group sequential design.}
\usage{
gsDesign(k=3, test.type=4, alpha=0.025, beta=0.1, astar=0,  
         delta=0, n.fix=1, timing=1, sfu=sfHSD, sfupar=-4,
         sfl=sfHSD, sflpar=-2, tol=0.000001, r=18, n.I = 0,
         maxn.IPlan = 0, nFixSurv=0, endpoint=NULL, delta1=1, delta0=0,overrun=0)
}
\arguments{
	\item{k}{Number of analyses planned, including interim and final.}
	\item{test.type}{\code{1=}one-sided \cr
		\code{2=}two-sided symmetric \cr
		\code{3=}two-sided, asymmetric, beta-spending with binding lower bound \cr
		\code{4=}two-sided, asymmetric, beta-spending with non-binding lower bound \cr
		\code{5=}two-sided, asymmetric, lower bound spending under the null hypothesis with binding lower bound \cr
		\code{6=}two-sided, asymmetric, lower bound spending under the null hypothesis with non-binding lower bound. \cr See details, examples and manual.}
	\item{alpha}{Type I error, always one-sided. Default value is 0.025.}
	\item{beta}{Type II error, default value is 0.1 (90\% power).}
	\item{astar}{Normally not specified. If \code{test.type=5} or \code{6}, \code{astar} specifies the total
	probability of crossing a lower bound at all analyses combined. 
	This will be changed to \eqn{1 - }\code{alpha} when default value of 0 is used. 
	Since this is the expected usage, normally \code{astar} is not specified by the user.}
	\item{delta}{Effect size for theta under alternative hypothesis. This can be set to the standardized effect size to generate a sample size if \code{n.fix=NULL}. See details and examples.}
	\item{n.fix}{Sample size for fixed design with no interim; used to find maximum group sequential sample size. For a time-to-event outcome, input number of events required for a fixed design rather than sample size
and enter fixed design sample size (optional) in \code{nFixSurv}.
	See details and examples.}
	\item{timing}{Sets relative timing of interim analyses. Default of 1 produces equally spaced analyses. 
	Otherwise, this is a vector of length \code{k} or \code{k-1}.
	The values should satisfy \code{0 < timing[1] < timing[2] < ... < timing[k-1] < 
timing[k]=1}.}
	\item{sfu}{A spending function or a character string indicating a boundary type (that is, \dQuote{WT} for Wang-Tsiatis bounds, \dQuote{OF} for O'Brien-Fleming bounds and \dQuote{Pocock} for Pocock bounds). 
	For one-sided and symmetric two-sided testing is used to completely specify spending (\code{test.type=1, 2}), \code{sfu}. 
	The default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending function.
	See details, \link{Spending function overview}, manual and examples.}
	\item{sfupar}{Real value, default is \eqn{-4} which is an O'Brien-Fleming-like conservative bound when used with the default Hwang-Shih-DeCani spending function. This is a real-vector for many spending functions.
	The parameter \code{sfupar} specifies any parameters needed for the spending function specified by \code{sfu}; this will be ignored for spending functions (\code{sfLDOF}, \code{sfLDPocock}) 
	or bound types (\dQuote{OF}, \dQuote{Pocock}) that do not require parameters.}
	\item{sfl}{Specifies the spending function for lower boundary crossing probabilities when asymmetric, two-sided testing is performed (\code{test.type = 3}, 
\code{4}, \code{5}, or \code{6}). 
	Unlike the upper bound, only spending functions are used to specify the lower bound.
	The default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending function.
	The parameter \code{sfl} is ignored for one-sided testing (\code{test.type=1}) or symmetric 2-sided testing (\code{test.type=2}). 
	See details, spending functions, manual and examples.}
	\item{sflpar}{Real value, default is \eqn{-2}, which, with the default Hwang-Shih-DeCani spending function, 
	specifies a less conservative spending rate than the default for the upper bound.}
	\item{tol}{Tolerance for error (default is 0.000001). Normally this will not be changed by the user.
	This does not translate directly to number of digits of accuracy, so use extra decimal places.}
	\item{r}{Integer value controlling grid for numerical integration as in Jennison and Turnbull (2000); 
	default is 18, range is 1 to 80. 
	Larger values provide larger number of grid points and greater accuracy.
	Normally \code{r} will not be changed by the user.}
	\item{n.I}{Used for re-setting bounds when timing of analyses changes from initial design; see examples.}
	\item{maxn.IPlan}{Used for re-setting bounds when timing of analyses changes from initial design; see examples.}
	\item{nFixSurv}{If a time-to-event variable is used, \code{nFixSurv} computed as the sample size from \code{nSurvival} may be entered to have \code{gsDesign}
	compute the total sample size required as well as the number of events at each analysis that will be returned in \code{n.fix}; this is rounded up to an even number.}

  \item{endpoint}{An optional character string that should represent the type of endpoint used for the study. This may be used by output functions. Types most likely to be recognized initially are "TTE" for time-to-event outcomes with fixed design sample size generated by \code{nSurvival()} and "Binomial" for 2-sample binomial outcomes with fixed design sample size generated by \code{nBinomial()}.}

	\item{delta1}{\code{delta1} and \code{delta0} may be used to store information about the natural parameter scale compared to \code{delta} that is a standardized effect size. \code{delta1} is the alternative hypothesis parameter value on the natural parameter scale (e.g., the difference in two binomial rates).}
  \item{delta0}{\code{delta0} is the null hypothesis parameter value on the natural parameter scale.}
  \item{overrun}{Scalar or vector of length \code{k-1} with patients enrolled that are not included in each interim analysis.}
}
\value{
An object of the class \code{gsDesign}. This class has the following elements and upon return from 
\code{gsDesign()} contains:
\item{k}{As input.}
\item{test.type}{As input.}
\item{alpha}{As input.}
\item{beta}{As input.}
\item{astar}{As input, except when \code{test.type=5} or \code{6} and \code{astar} is input as 0; in this case
\code{astar} is changed to \code{1-alpha}.}
\item{delta}{The standardized effect size for which the design is powered. Will be as input to \code{gsDesign()}
unless it was input as 0; in that case, value will be computed to give desired power for fixed design with input
sample size \code{n.fix}.}
\item{n.fix}{Sample size required to obtain desired power when effect size is \code{delta}.}
\item{timing}{A vector of length \code{k} containing the portion of the total planned information or sample size at each analysis.}
\item{tol}{As input.}
\item{r}{As input.}
\item{n.I}{Vector of length \code{k}. If values are input, same values are output.
Otherwise, \code{n.I} will contain the sample size required at each analysis 
to achieve desired \code{timing} and \code{beta} for the output value of \code{delta}. 
If \code{delta=0} was input, then this is the sample size required for the specified group sequential design when a fixed design requires a sample size of \code{n.fix}.
If \code{delta=0} and \code{n.fix=1} then this is the relative sample size compared to a fixed design; see details and examples.}
\item{maxn.IPlan}{As input.}
\item{nFixSurv}{As input.}
\item{nSurv}{Sample size for Lachin and Foulkes method when \code{nSurvival} is used for fixed design input. If \code{nSurvival} is used to compute \code{n.fix}, then \code{nFixSurv} is inflated by the same amount as \code{n.fix} and stored in \code{nSurv}. Note that if you use \code{gsSurv} for time-to-event sample size, this is not needed and a more complete output summary is given.}
\item{endpoint}{As input.}
\item{delta1}{As input.}
\item{delta0}{As input.}
\item{overrun}{As input.}
\item{upper}{Upper bound spending function, boundary and boundary crossing probabilities under the NULL and
alternate hypotheses. See \link{Spending function overview} and manual for further details.}
\item{lower}{Lower bound spending function, boundary and boundary crossing probabilities at each analysis.
Lower spending is under alternative hypothesis (beta spending) for \code{test.type=3} or \code{4}. 
For \code{test.type=2}, \code{5} or \code{6}, lower spending is under the null hypothesis.
For \code{test.type=1}, output value is \code{NULL}. See \link{Spending function overview} and manual.}
\item{theta}{Standarized effect size under null (0) and alternate hypothesis. If \code{delta} is input, \code{theta[1]=delta}. If \code{n.fix} is input, \code{theta[1]} is computed using a standard sample size formula (pseudocode): \code{((Zalpha+Zbeta)/theta[1])^2=n.fix}.}
\item{falseprobnb}{For \code{test.type=4} or \code{6}, this contains false positive probabilities under the null hypothesis assuming that crossing a futility bound does not stop the trial.}
\item{en}{Expected sample size accounting for early stopping. For time-to-event outcomes, this would be the expected number of events (although \code{gsSurv} will give expected sample size). For information-based-design, this would give the expected information when the trial stops. If \code{overrun} is specified, the expected sample size includes the overrun at each interim.}
}
\details{
Many parameters normally take on default values and thus do not require explicit specification.
One- and two-sided designs are supported. Two-sided designs may be symmetric or asymmetric.
Wang-Tsiatis designs, including O'Brien-Fleming and Pocock designs can be generated.
Designs with common spending functions as well as other built-in and user-specified functions for Type I error and 
futility are supported.
Type I error computations for asymmetric designs may assume binding or non-binding lower bounds.
The print function has been extended using \code{\link{print.gsDesign}()} to print \code{gsDesign} objects; see examples.

The user may ignore the structure of the value returned by \code{gsDesign()} if the standard
printing and plotting suffice; see examples.

\code{delta} and \code{n.fix} are used together to determine what sample size output options the user seeks.
The default, \code{delta=0} and \code{n.fix=1}, results in a \sQuote{generic} design that may be used with any sampling
situation. Sample size ratios are provided and the user multiplies these times the sample size for a fixed design
to obtain the corresponding group sequential analysis times. If \code{delta>0}, \code{n.fix} is ignored, and 
\code{delta} is taken as the standardized effect size - the signal to noise ratio for a single observation;
for example, the mean divided by the standard deviation for a one-sample normal problem. 
In this case, the sample size at each analysis is computed. 
When \code{delta=0} and \code{n.fix>1}, \code{n.fix} is assumed to be the sample size for a fixed design
with no interim analyses. See examples below. 

Following are further comments on the input argument \code{test.type} which is used to control what type of error measurements are used in trial design.
The manual may also be worth some review in order to see actual formulas for boundary crossing probabilities for the various options. 
Options 3 and 5 assume the trial stops if the lower bound is crossed for Type I and Type II error computation (binding lower bound). 
For the purpose of computing Type I error, options 4 and 6 assume the trial continues if the lower bound is crossed (non-binding lower bound); that is a Type I error can be made by crossing an upper bound after crossing a previous lower bound. 
Beta-spending refers to error spending for the lower bound crossing probabilities
under the alternative hypothesis (options 3 and 4).
In this case, the final analysis lower and upper boundaries are assumed to be the same.
The appropriate total beta spending (power) is determined by adjusting the maximum sample size
through an iterative process for all options.
Since options 3 and 4 must compute boundary crossing probabilities under both the null and alternative hypotheses,
deriving these designs can take longer than other options.
Options 5 and 6 compute lower bound spending under the null hypothesis.
}
\seealso{\link{gsDesign package overview}, \link{gsDesign print, summary and table summary functions}, \link{Plots for group sequential designs}, \code{\link{gsProbability}}, 
\link{Spending function overview}, \link{Wang-Tsiatis Bounds}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
#  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#  lower bound is non-binding (ignored in Type I error computation)
#  sample size is computed based on a fixed design requiring n=800
x <- gsDesign(k=5, test.type=2, n.fix=800)

# note that "x" below is equivalent to print(x) and print.gsDesign(x)
x
plot(x)
plot(x, plottype=2)

# Assuming after trial was designed actual analyses occurred after
# 300, 600, and 860 patients, reset bounds 
y <- gsDesign(k=3, test.type=2, n.fix=800, n.I=c(300,600,860),
   maxn.IPlan=x$n.I[x$k])
y

#  asymmetric design with user-specified spending that is non-binding
#  sample size is computed relative to a fixed design with n=1000
sfup <- c(.033333, .063367, .1)
sflp <- c(.25, .5, .75)
timing <- c(.1, .4, .7)
x <- gsDesign(k=4, timing=timing, sfu=sfPoints, sfupar=sfup, sfl=sfPoints,
	            sflpar=sflp,n.fix=1000) 
x
plot(x)
plot(x, plottype=2)

# same design, but with relative sample sizes
gsDesign(k=4, timing=timing, sfu=sfPoints, sfupar=sfup, sfl=sfPoints,
sflpar=sflp)
}
\keyword{design}

# AIC and BIC function for splm object #
AICsplm = function(object, k=2, criterion=c("AIC", "BIC")){ 
  sp = summary(object)
  l = sp$logLik
  np = length(coef(sp))
  N = nrow(sp$model)
  if (sp$effects=="sptpfe") {
    n = length(sp$res.eff[[1]]$res.sfe) 
    T = length(sp$res.eff[[1]]$res.tfe) 
    np = np+n+T
  }
  if (sp$effects=="spfe") {
    n = length(sp$res.eff[[1]]$res.sfe)
    np = np+n+1 
  }
  if (sp$effects=="tpfe") {
    T = length(sp$res.eff[[1]]$res.tfe)
    np = np+T+1
  }
  if (criterion=="AIC"){
    aic = -2*l+k*np
    names(aic) = "AIC"
    return(aic)
  }
  if (criterion=="BIC"){
    bic = -2*l+log(N)*np
    names(bic) = "BIC"
    return(bic)
  } 
}

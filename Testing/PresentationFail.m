tempUPA = UPA.*(UPA > 70);
tempUPB = UPB.*(UPB < 40);
tempUPR = tempUPA.*tempUPB;
PlotAssymetric4Function(tempUPR, W11, W12, W21, W22);

input('Press Return');

tempDOWNA = DOWNA.*(DOWNA < 40);
tempDOWNB = DOWNB.*(DOWNB > 70);
tempDOWNR = tempDOWNA.*tempDOWNB;
PlotAssymetric4Function(tempDOWNR, W11, W12, W21, W22);

input('Press Return');

tempDI = tempUPR.*tempDOWNR;
PlotAssymetric4Function(tempDI, W11, W12, W21, W22);
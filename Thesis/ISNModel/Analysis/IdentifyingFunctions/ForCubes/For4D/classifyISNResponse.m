function [respType] = classifyISNResponse(respstruct)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%MAKE SURE THIS AGREES WITH COLORMAP
        
    respType = 14;
    
    UnResp = IsISNUnResponsive(respstruct);
    if UnResp == 1,
        respType = 1; %'Unresponsive';
    else
        UnSel = IsISNUnselective(respstruct);
        if UnSel == 1,
            respType = 2;%'Unselective';
        else
            UnSelB = IsISNUnselectiveB(respstruct);
            if UnSelB == 1,
                respType = 3; %UnselectiveB
            else
                DS = IsISNDirectionalSelective(respstruct);
                if DS == 1,
                    respType = 4; %'DS';
                elseif DS == 2,
                    respType = 5; %'DS ISN';
                else
                    Uni = IsISNUniDirectional(respstruct);
                    if Uni == 1,
                        respType= 6; %'Uni';
                    elseif Uni == 2,
                        respType= 7; %'Uni ISN';
                    else
                        HalfUni = IsISNHalfUniDirectional(respstruct);
                        if HalfUni == 1,
                            respType = 8; %'HalfUni';
                        elseif HalfUni == 2,
                            respType = 9; %'HalfUni ISN';
                        else
                            HalfUni2 = IsISNHalfUni2Directional(respstruct);
                            if HalfUni2 == 1,
                                respType= 10; %'HalfUni2';
                            elseif HalfUni2 == 2,
                                respType = 11; %'Half2Uni ISN';
                            end
                        end
                    end
                end
            end
        end
    end
end


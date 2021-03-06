function [SE IE DE LEV_DIST] = Levenshtein(hypothesis,annotation_dir)
% Input:
%	hypothesis: The path to file containing the the recognition hypotheses
%	annotation_dir: The path to directory containing the annotations
%			(Ex. the Testing dir containing all the *.txt files)
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

    SE = [];
    IE = [];
    DE = [];
    LEV_DIST = [];

    hypoLines = textread(hypothesis, '%s','delimiter','\n');

    for iHypoLines = 1:length(hypoLines)
        hypoLine = hypoLines{iHypoLines};
        hypoWords = strsplit(strtrim(hypoLine));
        refWords = transpose(textread([annotation_dir, filesep, 'unkn_', num2str(iHypoLines), '.txt'], '%s'));

        del = 0;
        sub = 0;
        ins = 0;
        n = length(refWords) - 2;
        m = length(hypoWords);
        R = zeros(n + 1, m + 1);
        for i = 2:n + 1
            R(i, 1) = Inf;
        end
        for j = 2:m + 1
            R(1, j) = Inf;
        end
        for i = 2: n + 1
            for j = 2: m + 1
                del = R(i - 1, j) + 1;
                sub = R(i - 1, j - 1) + (~strcmp(upper(refWords{i + 1}), upper(hypoWords{j - 1})));
                ins = R(i, j - 1) + 1;
                R(i, j) = min(del, sub);
                R(i, j) = min(R(i, j), ins);
            end
        end

        SE{iHypoLines} = sub / n;
        IE{iHypoLines} = ins / n;
        DE{iHypoLines} = del / n;
        LEV_DIST{iHypoLines} = R(n + 1, m + 1) / n;
    end
end


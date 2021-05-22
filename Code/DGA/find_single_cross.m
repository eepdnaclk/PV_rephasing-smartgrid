function [ TempChromosome_1, TempChromosome_2] = find_single_cross( C1, C2 )
    crossoverPoint = randi([1,length(C1)]);
    
    TempChromosome_1 = C1;
    TempChromosome_2 = C2;
    
    TempChromosome_1(:,crossoverPoint:end) = C2(:,crossoverPoint:end);
    TempChromosome_2(:,crossoverPoint:end) = C1(:,crossoverPoint:end);
end


function countDown(wait)
    % countDown displays a countDown of wait seconds

    % Copyright 2023 The MathWorks, Inc.

    arguments
        wait int32 {mustBeNonnegative, mustBeReal, mustBeFinite, mustBeNonNan}
    end

    for n = 1:wait
        fprintf("%d ", wait - n + 1);
        pause(1);
        if mod(n, wait) == 0 && n ~= wait
            fprintf("\n");
        end
    end
    fprintf("\n");
end